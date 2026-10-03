package vte

import cairo "cairo:cairo"
import glib "glib:glib"
import gobj "glib:gobject"

// Typed pins for the post-generation rules (docs/PATCHED.md). A regeneration that drops one
// fails to compile here.

// gchar * is cstring, not ^char.
@(private = "file")
patched_get_user_shell: proc "c" () -> cstring = get_user_shell

@(private = "file")
patched_terminal_get_window_title: proc "c" (_: ^Terminal) -> cstring = terminal_get_window_title

// VteCharAttributes has bit-fields, which runic cannot read; it is declared by hand and
// must keep the C layout: two longs, two PangoColors and one guint of bit-fields.
#assert(size_of(CharAttributes) == 32)
#assert(align_of(CharAttributes) == 8)
#assert(offset_of(CharAttributes, flags) == 28)

// The version macros are numbers, not backtick strings.
#assert(MAJOR_VERSION == 0)

// Macros runic quotes as text are Odin values.
#assert(TEST_FLAGS_ALL == ~u64(0))
#assert(REGEX_FLAGS_DEFAULT != 0)
@(private = "file")
patched_type_terminal: proc "c" () -> gobj.Type = TYPE_TERMINAL

// FeatureFlags is a bit_set over u64 and cannot hold the C value -1; the mask is dropped.
@(private = "file")
patched_feature_flags: FeatureFlags = {.BIDI}

// One pin per `[^]T` parameter corrected to `^T` (docs/PATCHED.md, `single_params`): the C header
// passes one `T *`, not the array runic writes for a name ending in "s".

@(private = "file")
patched_pty_get_size: proc "c" (_: ^Pty, _: ^i32, _: ^i32, _: ^^glib.Error) -> glib.boolean = pty_get_size

@(private = "file")
patched_query_termprop: proc "c" (_: cstring, _: ^cstring, _: ^i32, _: ^PropertyType, _: ^PropertyFlags) -> glib.boolean = query_termprop

@(private = "file")
patched_terminal_check_regex_array_at: proc "c" (_: ^Terminal, _: f64, _: f64, _: [^]^Regex, _: glib.size, _: glib.uint32, _: ^glib.size) -> ^cstring = terminal_check_regex_array_at

@(private = "file")
patched_terminal_get_text: proc "c" (_: ^Terminal, _: SelectionFunc, _: glib.pointer, _: ^glib.Array) -> cstring = terminal_get_text

@(private = "file")
patched_terminal_set_font_options: proc "c" (_: ^Terminal, _: ^cairo.font_options_t) = terminal_set_font_options

@(private = "file")
patched_uuid_new_v5: proc "c" (_: ^Uuid, _: cstring, _: glib.ssize) -> ^Uuid = uuid_new_v5
