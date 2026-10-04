#!/usr/bin/env bash
# Rewrites runic's output where runic gets Odin wrong. Run by `make generate` after runic,
# once per package: scripts/postprocess.sh vte. Deterministic: the same runic output always
# gives the same file. Every rule is listed in docs/PATCHED.md. Flag enums become bit_sets
# (bit_sets below).
set -euo pipefail

# The GFlags types, and VteFeatureFlags, which is a flag set too (a guint64 enum with no
# GType). runic emits them as `enum u32` (u64) of the C values; a value rule cannot tell them
# from sequential enums, so they are listed. The list is the g_flags_register_static entries of
# vtetypebuiltins plus VteFeatureFlags. VteWriteFlags and VteFormat are registered as enums
# (WriteFlags has only a zero member; Format is one of two values) and stay enums.
# Each type's members carry their own prefix, stripped from the bit names.

# bit_sets <file> <strip-prefix> <enum>...: `Foo :: enum u32 {A = 1, B = 4, C = 5, NONE = 0}` (or u64)
# becomes
#   FooBit :: enum u32 {A = 0, B = 2}        bit indices, prefix stripped from the members
#   Foo :: bit_set[FooBit; u32]              same size and bits as the C type
#   C :: Foo{.A, .B}                         composite masks, by their C names
#   NONE :: Foo{}                            zero members, by their C names; a name with no
#                                            underscore (NONE, FAMILY) is prefixed FOO_ so it is unique
# Members that are not one bit or zero are composites; a composite with a bit that has no
# member is a transmute of the C value. Fails if a listed enum is missing, has a negative
# value or has no single-bit member, so a header bump that changes a flag type is noticed.
bit_sets() {
    local file=$1 strip=$2
    shift 2
    STRIP=$strip NAMES="$*" perl -i -ne '
        BEGIN { $strip = $ENV{STRIP}; %want = map { $_ => 1 } split " ", $ENV{NAMES}; }
        if (/^(\w+) :: enum (u32|u64) \{(.*)\}\s*$/ && $want{$1}) {
            my ($name, $ty, $body) = ($1, $2, $3);
            delete $want{$name};
            my (@bits, @zero, @comp, $all);
            (my $pre = uc($name =~ s/([a-z0-9])([A-Z])/$1_$2/gr)) .= "_";
            for my $m (split /,\s*/, $body =~ s/\s+$//r) {
                $m =~ /^(\w+) = (-?\d+)$/ or die "postprocess: $name: cannot read member $m\n";
                my ($id, $v) = ($1, $2);
                die "postprocess: $name.$id is negative\n" if $v < 0;
                if ($v == 0) { push @zero, $id }
                elsif (($v & ($v - 1)) == 0) { push @bits, [$id, $v] }
                else { push @comp, [$id, $v] }
            }
            die "postprocess: $name has no single-bit member\n" unless @bits;
            my %idx; my $mask = 0;
            for (@bits) {
                my $i = 0; $i++ while (1 << $i) != $_->[1];
                ($id = $_->[0]) =~ s/^\Q$strip\E//;
                $idx{$_->[1]} = $id; $mask |= $_->[1];
                $_ = [$id, $i];
            }
            print "${name}Bit :: enum $ty {", join(", ", map { "$_->[0] = $_->[1]" } @bits), "}\n";
            print "$name :: bit_set[${name}Bit; $ty]\n";
            for (@zero) { my $c = /_/ ? $_ : "$pre$_"; print "$c :: $name\{}\n" }
            for (@comp) {
                my ($id, $v) = @$_;
                $id = "$pre$id" unless $id =~ /_/;
                if (($v & ~$mask) == 0) {
                    print "$id :: $name\{", join(", ", map { ".$idx{$_}" } grep { $v & $_ } sort { $a <=> $b } keys %idx), "}\n";
                } else { print "$id :: transmute($name)$ty($v)\n" }
            }
        } else { print }
        END { die "postprocess: flag enum(s) not found: " . join(" ", sort keys %want) . "\n" if %want; }
    ' "$file"
}


pkg=${1:?usage: postprocess.sh vte}
cd "$(dirname "$0")/.."
file="$pkg/$pkg.odin"
[ -f "$file" ] || { echo "postprocess: $file not found" >&2; exit 2; }

case "$pkg" in
vte)
    # Macros runic quotes as backtick strings become Odin expressions: TYPE_FOO names
    # vte_foo_get_type, the error quarks their functions, the version macros their numbers.
    # `Foo :: _VteFoo` is dropped and `_VteFoo` becomes Foo. gchar * is cstring.
    # VteCharAttributes has bit-fields, which runic cannot read: it is declared by hand.
    # TEST_FLAGS_* are u64 values. FeatureFlags.MASK is the C value -1, which a u64 enum cannot hold.
    sed -i "$file" \
        -e 's/\^glib\.char/cstring/g' \
        -e '/^\(TYPE\|PTY\|REGEX\)_[A-Z_]* :: `(\?[a-z0-9_]* \?())\?`$/ {s/`(\?//; s/ \?())\?`//; s/ vte_/ /}' \
        -e '/^\(MAJOR_VERSION\|MINOR_VERSION\|MICRO_VERSION\) ::/ {s/`//g; s/(\([0-9]*\))/\1/}' \
        -e '/^SPAWN_[A-Z_]* ::/ {s/`//g; s/(\(.*\))/\1/}' \
        -e '/^REGEX_FLAGS_DEFAULT ::/ {s/`//g; s/(\(.*\))/\1/; s/\([0-9a-fx]*\)u\b/\1/g}' \
        -e 's/^TEST_FLAGS_NONE :: .*/TEST_FLAGS_NONE :: u64(0)/' \
        -e 's/^TEST_FLAGS_ALL :: .*/TEST_FLAGS_ALL :: ~u64(0)/' \
        -e 's/, MASK = -1 }/ }/' \
        -e 's/, _VTE_PROPERTY_ID_MAX = [0-9]* }/ }/' \
        -e 's#^\([a-zA-Z][a-zA-Z_0-9]*\)\s*::\s*_Vte\1$##' \
        -e 's#^_Vte\([a-zA-Z][a-zA-Z_0-9]*\)\s*::\s*\(.*\)$#\1 :: \2#'
    awk '
        /^CharAttributes :: struct #packed \{\}$/ {
            print "CharAttributes :: struct {"
            print "    row, column: i64,"
            print "    fore, back:  pango.Color,"
            print "    flags:       bit_field u32 {"
            print "        underline:     u32 | 1,"
            print "        strikethrough: u32 | 1,"
            print "        columns:       u32 | 4,"
            print "    },"
            print "}"
            next
        }
        { print }
    ' "$file" >"$file.tmp"
    mv "$file.tmp" "$file"
    bit_sets "$file" PTY_ PtyFlags
    bit_sets "$file" "" UuidFormat
    bit_sets "$file" PROPERTY_FLAG_ PropertyFlags
    bit_sets "$file" FEATURE_FLAG_ FeatureFlags
    # `parameters: declared` cannot list the parameters of a function-pointer type, so the
    # counted `props` of VteTermpropsChangedFunc (with n_props) is restored by hand.
    sed -i 's/^\(termprops_changed_func_ptr_anon_[0-9]* :: .*props: \)^i32/\1[^]i32/' "$file"
    ;;
*)
    echo "postprocess: unknown package $pkg" >&2
    exit 2
    ;;
esac
