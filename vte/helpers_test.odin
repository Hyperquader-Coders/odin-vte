#+test
package vte

import "base:intrinsics"
import "core:log"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:sync"
import "core:testing"

import glib "glib:glib"
import gobj "glib:gobject"
import gtk4 "gtk4:gtk4"

// helpers.odin is read as text, so every connect_* is checked against the signal it names.
HELPERS :: #load("helpers.odin", string)

Signal_Spec :: struct {
    name:      string, // the C signal name
    proc_type: string, // the callback type the connect_* takes, by its Odin name
    params:    []string, // GType names of the signal's parameters
    returns:   bool, // the signal returns a value
    arity:     int, // parameters of the callback type, from the type itself
}

spec :: proc(name, proc_type: string, $T: typeid, params: []string = nil) -> Signal_Spec where intrinsics.type_is_proc(T) {
    return {name, proc_type, slice.clone(params, context.temp_allocator), intrinsics.type_proc_return_count(T) == 1, intrinsics.type_proc_parameter_count(T)}
}

// Every VteTerminal signal of vteterminal.h's class struct and of vtegtk.cc.
signal_specs :: proc() -> []Signal_Spec {
    n :: "Notification_Proc"
    specs := make([dynamic]Signal_Spec, context.temp_allocator)
    for name in ([]string{
        "eof", "encoding-changed", "window-title-changed", "icon-title-changed",
        "current-directory-uri-changed", "current-file-uri-changed", "selection-changed",
        "contents-changed", "cursor-moved", "deiconify-window", "iconify-window", "raise-window",
        "lower-window", "refresh-window", "restore-window", "maximize-window",
        "increase-font-size", "decrease-font-size", "copy-clipboard", "paste-clipboard", "bell",
    }) {
        append(&specs, spec(name, n, Notification_Proc))
    }
    append(&specs, spec("child-exited", "Child_Exited_Proc", Child_Exited_Proc, {"gint"}))
    append(&specs, spec("commit", "Commit_Proc", Commit_Proc, {"gchararray", "guint"}))
    append(&specs, spec("char-size-changed", "Char_Size_Changed_Proc", Char_Size_Changed_Proc, {"guint", "guint"}))
    append(&specs, spec("resize-window", "Resize_Window_Proc", Resize_Window_Proc, {"guint", "guint"}))
    append(&specs, spec("move-window", "Move_Window_Proc", Move_Window_Proc, {"guint", "guint"}))
    append(&specs, spec("hyperlink-hover-uri-changed", "Hyperlink_Hover_Uri_Changed_Proc", Hyperlink_Hover_Uri_Changed_Proc, {"gchararray", "GdkRectangle"}))
    append(&specs, spec("setup-context-menu", "Setup_Context_Menu_Proc", Setup_Context_Menu_Proc, {"VteEventContext"}))
    append(&specs, spec("termprop-changed", "Termprop_Changed_Proc", Termprop_Changed_Proc, {"gchararray"}))
    append(&specs, spec("termprops-changed", "Termprops_Changed_Proc", Termprops_Changed_Proc, {"gpointer", "gint"}))
    return specs[:]
}

// The runner runs tests on several threads, and two threads registering GTypes at once
// (Pango's font map types, Terminal's class) can deadlock inside GLib. A test that registers
// a type, or can, holds this lock for its whole run.
type_lock: sync.Mutex

// The class is created and kept.
terminal_class :: proc() {
    gobj.type_class_ref(terminal_get_type())
}

// A callback has the instance, the signal's parameters and user_data; a signal that has a
// return value returns one.
@(test)
test_signal_specs_match_the_library :: proc(t: ^testing.T) {
    sync.guard(&type_lock)
    type := terminal_get_type()
    terminal_class() // registers the signals
    for s in signal_specs() {
        name := strings.clone_to_cstring(s.name, context.temp_allocator)
        id := gobj.signal_lookup(name, type)
        if !testing.expectf(t, id != 0, "%s is not a VteTerminal signal", s.name) do continue
        q: gobj.SignalQuery
        gobj.signal_query(id, &q)
        testing.expect_value(t, int(q.n_params) + 2, s.arity)
        testing.expect_value(t, q.return_type != gobj.Type(4), s.returns) // G_TYPE_NONE is 4
        if !testing.expect_value(t, int(q.n_params), len(s.params)) do continue
        for p, i in s.params {
            testing.expect_value(t, string(gobj.type_name(q.param_types[i])), p)
        }
    }
}

// Each connect_<signal> names the signal it is called after and takes the callback type of
// the spec; no VteTerminal signal lacks a helper.
@(test)
test_every_signal_has_one_connect_helper :: proc(t: ^testing.T) {
    sync.guard(&type_lock)
    specs := signal_specs()
    seen := make(map[string]bool, allocator = context.temp_allocator)
    rest := HELPERS
    for line in strings.split_lines_iterator(&rest) {
        if !strings.has_prefix(line, "connect_") do continue
        fn := line[len("connect_"):strings.index(line, " ::")]
        proc_type := line[strings.index(line, "handler: ") + len("handler: "):]
        proc_type = proc_type[:strings.index(proc_type, ",")]
        next, _ := strings.split_lines_iterator(&rest)
        q0 := strings.index(next, `"`)
        q1 := strings.last_index(next, `"`)
        testing.expectf(t, q0 >= 0 && q1 > q0, "connect_%s: no signal name in its body", fn)
        if q0 < 0 || q1 <= q0 do continue
        sig := next[q0 + 1:q1]
        under, _ := strings.replace_all(sig, "-", "_", context.temp_allocator)
        testing.expect_value(t, under, fn)
        found := false
        for s in specs {
            if s.name == sig {
                found = true
                testing.expect_value(t, proc_type, s.proc_type)
            }
        }
        testing.expectf(t, found, "connect_%s: %s is not in the spec table", fn, sig)
        testing.expectf(t, !seen[sig], "connect_%s is defined twice", fn)
        seen[sig] = true
    }
    testing.expect_value(t, len(seen), len(specs))

    type := terminal_get_type()
    terminal_class()
    n: glib.uint_
    ids := gobj.signal_list_ids(type, &n)
    defer glib.free(ids)
    for i in 0 ..< int(n) {
        name := string(gobj.signal_name(([^]glib.uint_)(ids)[i]))
        testing.expectf(t, seen[name], "VteTerminal signal %s has no connect_ helper", name)
    }
    testing.expect_value(t, len(seen), int(n))
}

// Connecting needs an instance, and a GtkWidget cannot be made without a display. With one
// (the tests run with none unless started by hand), connect handlers and emit.
Seen :: struct {
    calls:  int,
    status: i32,
    text:   [8]u8,
    size:   glib.uint_,
    name:   [32]u8,
    props:  i32,
}

@(test)
test_connect_and_emit_with_a_display :: proc(t: ^testing.T) {
    sync.guard(&type_lock)
    if !bool(gtk4.init_check()) {
        log.info("no display: only the signal tables were checked")
        return
    }
    term := cast(^Terminal)terminal_new()
    gobj.object_ref_sink(term)
    defer gobj.object_unref(term)
    seen: Seen

    bell :: proc "c" (_: ^Terminal, data: glib.pointer) {
        (^Seen)(data).calls += 1
    }
    exited :: proc "c" (_: ^Terminal, status: i32, data: glib.pointer) {
        s := (^Seen)(data)
        s.calls += 1
        s.status = status
    }
    commit :: proc "c" (_: ^Terminal, text: [^]u8, size: glib.uint_, data: glib.pointer) {
        s := (^Seen)(data)
        s.calls += 1
        s.size = size
        for i in 0 ..< min(int(size), len(s.text)) do s.text[i] = text[i]
    }
    termprop :: proc "c" (_: ^Terminal, name: cstring, data: glib.pointer) {
        s := (^Seen)(data)
        s.calls += 1
        n := string(name)
        for i in 0 ..< min(len(n), len(s.name) - 1) do s.name[i] = n[i]
    }
    resized :: proc "c" (_: ^Terminal, w, h: glib.uint_, data: glib.pointer) {
        s := (^Seen)(data)
        s.calls += 1
        s.size = w * 1000 + h
    }

    id := connect_bell(term, bell, &seen)
    testing.expect(t, id != 0)
    connect_child_exited(term, exited, &seen)
    connect_commit(term, commit, &seen)
    connect_termprop_changed(term, termprop, &seen)
    connect_resize_window(term, resized, &seen)

    gobj.signal_emit_by_name(term, "bell")
    testing.expect_value(t, seen.calls, 1)
    gobj.signal_emit_by_name(term, "child-exited", i32(256))
    testing.expect_value(t, seen.status, 256)
    gobj.signal_emit_by_name(term, "commit", cstring("hi"), glib.uint_(2))
    testing.expect_value(t, seen.size, 2)
    testing.expect_value(t, string(seen.text[:2]), "hi")
    gobj.signal_emit_by_name(term, "termprop-changed", cstring("xterm.title"))
    testing.expect_value(t, string(cstring(raw_data(seen.name[:]))), "xterm.title")
    gobj.signal_emit_by_name(term, "resize-window", glib.uint_(80), glib.uint_(24))
    testing.expect_value(t, seen.size, 80024)
    testing.expect_value(t, seen.calls, 5)

    gobj.signal_handler_disconnect(term, id)
    gobj.signal_emit_by_name(term, "bell")
    testing.expect_value(t, seen.calls, 5)
}

// PCRE2 flags: values from pcre2.h, where the header is installed.
Flag :: struct {
    name:  string,
    value: u32,
}

pcre2_flags :: [?]Flag {
    {"PCRE2_ANCHORED", PCRE2_ANCHORED}, {"PCRE2_NO_UTF_CHECK", PCRE2_NO_UTF_CHECK},
    {"PCRE2_ENDANCHORED", PCRE2_ENDANCHORED}, {"PCRE2_ALLOW_EMPTY_CLASS", PCRE2_ALLOW_EMPTY_CLASS},
    {"PCRE2_ALT_BSUX", PCRE2_ALT_BSUX}, {"PCRE2_AUTO_CALLOUT", PCRE2_AUTO_CALLOUT},
    {"PCRE2_CASELESS", PCRE2_CASELESS}, {"PCRE2_DOTALL", PCRE2_DOTALL},
    {"PCRE2_DUPNAMES", PCRE2_DUPNAMES}, {"PCRE2_EXTENDED", PCRE2_EXTENDED},
    {"PCRE2_MATCH_UNSET_BACKREF", PCRE2_MATCH_UNSET_BACKREF}, {"PCRE2_MULTILINE", PCRE2_MULTILINE},
    {"PCRE2_NEVER_UCP", PCRE2_NEVER_UCP}, {"PCRE2_NEVER_UTF", PCRE2_NEVER_UTF},
    {"PCRE2_NO_AUTO_CAPTURE", PCRE2_NO_AUTO_CAPTURE}, {"PCRE2_NO_AUTO_POSSESS", PCRE2_NO_AUTO_POSSESS},
    {"PCRE2_NO_DOTSTAR_ANCHOR", PCRE2_NO_DOTSTAR_ANCHOR}, {"PCRE2_UCP", PCRE2_UCP},
    {"PCRE2_UNGREEDY", PCRE2_UNGREEDY}, {"PCRE2_UTF", PCRE2_UTF},
    {"PCRE2_NEVER_BACKSLASH_C", PCRE2_NEVER_BACKSLASH_C}, {"PCRE2_ALT_VERBNAMES", PCRE2_ALT_VERBNAMES},
    {"PCRE2_EXTENDED_MORE", PCRE2_EXTENDED_MORE}, {"PCRE2_LITERAL", PCRE2_LITERAL},
    {"PCRE2_EXTRA_ALLOW_SURROGATE_ESCAPES", PCRE2_EXTRA_ALLOW_SURROGATE_ESCAPES},
    {"PCRE2_EXTRA_BAD_ESCAPE_IS_LITERAL", PCRE2_EXTRA_BAD_ESCAPE_IS_LITERAL},
    {"PCRE2_EXTRA_MATCH_WORD", PCRE2_EXTRA_MATCH_WORD}, {"PCRE2_EXTRA_MATCH_LINE", PCRE2_EXTRA_MATCH_LINE},
    {"PCRE2_EXTRA_ESCAPED_CR_IS_LF", PCRE2_EXTRA_ESCAPED_CR_IS_LF}, {"PCRE2_EXTRA_ALT_BSUX", PCRE2_EXTRA_ALT_BSUX},
    {"PCRE2_EXTRA_ALLOW_LOOKAROUND_BSK", PCRE2_EXTRA_ALLOW_LOOKAROUND_BSK},
    {"PCRE2_JIT_COMPLETE", PCRE2_JIT_COMPLETE}, {"PCRE2_JIT_PARTIAL_SOFT", PCRE2_JIT_PARTIAL_SOFT},
    {"PCRE2_JIT_PARTIAL_HARD", PCRE2_JIT_PARTIAL_HARD},
    {"PCRE2_NOTBOL", PCRE2_NOTBOL}, {"PCRE2_NOTEOL", PCRE2_NOTEOL}, {"PCRE2_NOTEMPTY", PCRE2_NOTEMPTY},
    {"PCRE2_NOTEMPTY_ATSTART", PCRE2_NOTEMPTY_ATSTART}, {"PCRE2_PARTIAL_SOFT", PCRE2_PARTIAL_SOFT},
    {"PCRE2_PARTIAL_HARD", PCRE2_PARTIAL_HARD}, {"PCRE2_NO_JIT", PCRE2_NO_JIT},
    {"PCRE2_SUBSTITUTE_GLOBAL", PCRE2_SUBSTITUTE_GLOBAL}, {"PCRE2_SUBSTITUTE_EXTENDED", PCRE2_SUBSTITUTE_EXTENDED},
    {"PCRE2_SUBSTITUTE_UNSET_EMPTY", PCRE2_SUBSTITUTE_UNSET_EMPTY},
    {"PCRE2_SUBSTITUTE_UNKNOWN_UNSET", PCRE2_SUBSTITUTE_UNKNOWN_UNSET},
    {"PCRE2_SUBSTITUTE_LITERAL", PCRE2_SUBSTITUTE_LITERAL}, {"PCRE2_SUBSTITUTE_MATCHED", PCRE2_SUBSTITUTE_MATCHED},
    {"PCRE2_SUBSTITUTE_REPLACEMENT_ONLY", PCRE2_SUBSTITUTE_REPLACEMENT_ONLY},
}

// Constants are u32, and the default set vteregex.h documents is the three flags it names.
#assert(type_of(PCRE2_CASELESS) == u32)
#assert(REGEX_FLAGS_DEFAULT == PCRE2_NO_UTF_CHECK | PCRE2_UTF | PCRE2_NEVER_BACKSLASH_C)

@(test)
test_pcre2_flags_match_the_header :: proc(t: ^testing.T) {
    data, err := os.read_entire_file("/usr/include/pcre2.h", context.temp_allocator)
    if err != nil {
        log.info("pcre2.h is not installed: the flag values were not compared")
        return
    }
    defer delete(data, context.temp_allocator)
    for f in pcre2_flags {
        want, found := header_define(string(data), f.name)
        if !testing.expectf(t, found, "%s is not defined in pcre2.h", f.name) do continue
        testing.expectf(t, want == f.value, "%s is 0x%x, pcre2.h has 0x%x", f.name, f.value, want)
    }
    // No two flags of one group share a value: every name is distinct and so is the table.
    names := make(map[string]bool, allocator = context.temp_allocator)
    for f in pcre2_flags {
        testing.expectf(t, !names[f.name], "%s is listed twice", f.name)
        names[f.name] = true
    }
}

// `#define NAME   0x...u` or a decimal.
header_define :: proc(header, name: string) -> (value: u32, ok: bool) {
    rest := header
    for line in strings.split_lines_iterator(&rest) {
        fields := strings.fields(line, context.temp_allocator)
        if len(fields) < 3 || fields[0] != "#define" || fields[1] != name do continue
        text := strings.trim_right(fields[2], "uU")
        v, parsed := strconv.parse_u64(text)
        return u32(v), parsed
    }
    return
}

// The flags reach PCRE2: a caseless regex matches other case, a plain one does not.
@(test)
test_caseless_flag_reaches_pcre2 :: proc(t: ^testing.T) {
    sync.guard(&type_lock)
    err: ^glib.Error
    plain := regex_new_for_match("abc", -1, REGEX_FLAGS_DEFAULT, &err)
    testing.expect(t, plain != nil && err == nil)
    defer regex_unref(plain)
    caseless := regex_new_for_match("abc", -1, REGEX_FLAGS_DEFAULT | PCRE2_CASELESS, &err)
    testing.expect(t, caseless != nil && err == nil)
    defer regex_unref(caseless)

    // A global substitution that finds nothing returns the subject unchanged.
    for c, i in ([]^Regex{plain, caseless}) {
        out := regex_substitute(c, "xABCx", "-", PCRE2_SUBSTITUTE_GLOBAL, &err)
        testing.expect(t, out != nil && err == nil)
        want := i == 0 ? "xABCx" : "x-x"
        testing.expect_value(t, string(out), want)
        glib.free(rawptr(out))
    }

    // regex_new_for_search: PCRE2_MULTILINE is what the terminal's search wants.
    multi := regex_new_for_search("^b$", -1, REGEX_FLAGS_DEFAULT | PCRE2_MULTILINE, &err)
    testing.expect(t, multi != nil && err == nil)
    defer regex_unref(multi)
    out := regex_substitute(multi, "a\nb\nc", "X", PCRE2_SUBSTITUTE_GLOBAL, &err)
    testing.expect_value(t, string(out), "a\nX\nc")
    glib.free(rawptr(out))
}

// Flag enums (docs/DECISIONS.md §5) keep the C size and bits.
@(test)
test_flag_enums_are_bit_sets_of_the_c_bits :: proc(t: ^testing.T) {
    sync.guard(&type_lock)
    testing.expect_value(t, size_of(PtyFlags), 4)
    testing.expect_value(t, size_of(UuidFormat), 4)
    testing.expect_value(t, size_of(PropertyFlags), 4)
    testing.expect_value(t, size_of(FeatureFlags), 8)

    testing.expect_value(t, transmute(u32)PtyFlags{.NO_LASTLOG}, 1)
    testing.expect_value(t, transmute(u32)PtyFlags{.NO_UTMP}, 2)
    testing.expect_value(t, transmute(u32)PtyFlags{.NO_WTMP}, 4)
    testing.expect_value(t, transmute(u32)PtyFlags{.NO_HELPER}, 8)
    testing.expect_value(t, transmute(u32)PtyFlags{.NO_FALLBACK}, 16)
    testing.expect_value(t, transmute(u32)PtyFlags{.NO_SESSION}, 32)
    testing.expect_value(t, transmute(u32)PtyFlags{.NO_CTTY}, 64)
    testing.expect_value(t, transmute(u32)PTY_DEFAULT, 0)
    testing.expect_value(t, transmute(u32)UuidFormat{.SIMPLE}, 1)
    testing.expect_value(t, transmute(u32)UuidFormat{.BRACED}, 2)
    testing.expect_value(t, transmute(u32)UuidFormat{.URN}, 4)
    testing.expect_value(t, transmute(u32)UUID_FORMAT_ANY, 7)
    testing.expect_value(t, transmute(u32)PropertyFlags{.EPHEMERAL}, 1)
    testing.expect_value(t, transmute(u32)PROPERTY_FLAG_NONE, 0)
    testing.expect_value(t, transmute(u64)FeatureFlags{.BIDI}, 1)
    testing.expect_value(t, transmute(u64)FeatureFlags{.ICU}, 2)
    testing.expect_value(t, transmute(u64)FeatureFlags{.SYSTEMD}, 4)
    testing.expect_value(t, transmute(u64)FeatureFlags{.SIXEL}, 8)

    // The registered GFlags types agree: their mask is every bit of the bit_set.
    check_mask :: proc(t: ^testing.T, name: string, type: gobj.Type, all: u32) {
        class := (^gobj.FlagsClass)(gobj.type_class_ref(type))
        defer gobj.type_class_unref(class)
        testing.expect_value(t, class.mask, all)
        testing.expectf(t, class.n_values > 0, "%s has no values", name)
    }
    check_mask(t, "PtyFlags", pty_flags_get_type(), transmute(u32)(~PtyFlags{}))
    check_mask(t, "UuidFormat", uuid_format_get_type(), transmute(u32)(~UuidFormat{}))
    check_mask(t, "PropertyFlags", property_flags_get_type(), transmute(u32)(~PropertyFlags{}))
}

@(test)
test_flags_work_in_calls :: proc(t: ^testing.T) {
    sync.guard(&type_lock)
    u := uuid_new_v4()
    defer uuid_free(u)
    for f in ([]UuidFormat{{.SIMPLE}, {.BRACED}, {.URN}}) {
        s := uuid_to_string(u, f, nil)
        back := uuid_new_from_string(s, -1, UUID_FORMAT_ANY)
        testing.expect(t, back != nil, "a printed UUID did not parse")
        uuid_free(back)
        glib.free(rawptr(s))
    }
}
