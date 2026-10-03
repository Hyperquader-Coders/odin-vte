#!/usr/bin/env bash
# Fails when one of runic's three known faults is back in the generated output:
#   - a `#c_vararg` procedure whose C declaration took a `va_list` (runic drops the trailing
#     `va_list` and marks the procedure `#c_vararg ..any`, which is a wrong call), or
#   - a parameter listed in `corrected` typed `[^]T` again (runic writes `[^]T` for any pointer
#     parameter whose C name ends in "s", however many elements it holds).
#   - a `T **` out-parameter of one pointer typed `[^]^T` (listed in `arrays` when it is a real
#     array).
# rune.yml (`detect: parameters: declared`, `arrays:`) and the fork hold the fixes; `make check-generated` runs this, `make lint` runs that.
set -euo pipefail
cd "$(dirname "$0")/.."

files=("vte/vte.odin")

# Procedures removed because they take a `va_list`.
removed=""

# Link names that mark a va_list procedure, wherever it comes from.
valist_re='_valist|_va_list|vprintf|vsnprintf|vsprintf|vasprintf|_vfprintf|_logv|_vscanf'

# `proc name, parameter` lines: parameters the C headers pass as one `T *`, which `parameters: declared`
# types `^T` (`^^T` for an out-parameter). A line is a failure when it is `[^]` again.
corrected='
pty_get_size, columns
pty_get_size, rows
query_termprop_by_id, flags
query_termprop, flags
terminal_check_regex_array_at, n_matches
terminal_get_text, attributes
terminal_get_text_include_trailing_spaces, attributes
terminal_get_text_range, attributes
terminal_set_font_options, font_options
uuid_new_v5, ns
'

fail=0

for f in "${files[@]}"; do
    [ -f "$f" ] || { echo "check-generated: $f not found" >&2; exit 2; }
    for n in $removed; do
        if grep -Eq "^[[:space:]]+$n :: proc" "$f"; then
            echo "$f: $n is back; it takes a va_list and is bound wrongly (runic skips va_list procedures)"
            fail=1
        fi
    done
    bad=$(awk -v re="$valist_re" '
        /link_name = / { match($0, /"[^"]*"/); link = substr($0, RSTART + 1, RLENGTH - 2); next }
        /#c_vararg/ && link ~ re { print "  " link }
        /::[[:space:]]*proc/ { link = "" }
    ' "$f")
    if [ -n "$bad" ]; then
        echo "$f: #c_vararg procedures that take a va_list:"
        echo "$bad"
        fail=1
    fi
done

while IFS=', ' read -r proc param; do
    [ -n "$proc" ] || continue
    for f in "${files[@]}"; do
        if grep -Eq "^[[:space:]]+$proc :: proc\(.*[( ]$param: \[\^\]" "$f"; then
            echo "$f: $proc, $param is [^] again; the header passes one object (rune.yml parameters: declared; list real arrays under arrays:)"
            fail=1
        fi
    done
done <<<"$corrected"

# Parameters typed `[^]^T` that are real arrays: a pointer and a count, or an out-array. Any
# other `[^]^T` parameter is a `T **` out-parameter of one pointer, which runic mistypes and
# `parameters: declared` types `^^T`. Read the header and the `(out)` / `(array)`
# annotations before adding a line here.
arrays='
terminal_check_regex_array_at, regexes
terminal_check_regex_simple_at, regexes
'

for f in "${files[@]}"; do
    out=$(ARRAYS="$arrays" perl -ne '
        BEGIN { for (split /\n/, $ENV{ARRAYS}) { next unless /\S/; my ($p, $a) = split /,\s*/; $ok{"$p, $a"} = 1 } }
        if (/^\s*(\w+) :: proc\b.*?\((.*)\)/) {
            my ($n, $args) = ($1, $2);
            while ($args =~ /\b(\w+): \[\^\]\^/g) {
                print "$ARGV:$.: $n, $1 is [^]^T and not a listed array; a T ** out-parameter of one pointer is ^^T (rune.yml parameters: declared; list real arrays under arrays:)\n" unless $ok{"$n, $1"};
            }
        }
    ' "$f")
    if [ -n "$out" ]; then echo "$out"; fail=1; fi
done

if [ "$fail" -ne 0 ]; then
    echo "check-generated: runic's output regressed; fix rune.yml (detect.arrays) and run make generate"
    exit 1
fi
echo "check-generated: ok"
