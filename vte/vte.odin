package vte

import cairo "cairo:cairo"
import gio "glib:gio"
import glib "glib:glib"
import gobj "glib:gobject"
import gtk4 "gtk4:gtk4"
import pango "pango:pango"

TEST_FLAGS_NONE :: u64(0)
TEST_FLAGS_ALL :: ~u64(0)
TERMPROP_NAME_PREFIX :: "vte.ext."
TERMPROP_CURRENT_DIRECTORY_URI :: "vte.cwd"
TERMPROP_CURRENT_FILE_URI :: "vte.cwf"
TERMPROP_XTERM_TITLE :: "xterm.title"
TERMPROP_CONTAINER_NAME :: "vte.container.name"
TERMPROP_CONTAINER_RUNTIME :: "vte.container.runtime"
TERMPROP_CONTAINER_UID :: "vte.container.uid"
TERMPROP_SHELL_PRECMD :: "vte.shell.precmd"
TERMPROP_SHELL_PREEXEC :: "vte.shell.preexec"
TERMPROP_SHELL_POSTEXEC :: "vte.shell.postexec"
TERMPROP_PROGRESS_HINT :: "vte.progress.hint"
TERMPROP_PROGRESS_VALUE :: "vte.progress.value"
TERMPROP_ICON_COLOR :: "vte.icon.color"
TERMPROP_ICON_IMAGE :: "vte.icon.image"
SPAWN_NO_PARENT_ENVV :: 1 << 25
SPAWN_NO_SYSTEMD_SCOPE :: 1 << 26
SPAWN_REQUIRE_SYSTEMD_SCOPE :: 1 << 27
PTY_ERROR :: pty_error_quark
TYPE_PTY :: pty_get_type
TYPE_REGEX :: regex_get_type
REGEX_ERROR :: regex_error_quark
REGEX_FLAGS_DEFAULT :: 0x00080000 | 0x40000000 | 0x00100000
TYPE_UUID :: uuid_get_type
TYPE_EVENT_CONTEXT :: event_context_get_type
TYPE_TERMINAL :: terminal_get_type
TYPE_CURSOR_BLINK_MODE :: cursor_blink_mode_get_type
TYPE_CURSOR_SHAPE :: cursor_shape_get_type
TYPE_TEXT_BLINK_MODE :: text_blink_mode_get_type
TYPE_ERASE_BINDING :: erase_binding_get_type
TYPE_PTY_ERROR :: pty_error_get_type
TYPE_PTY_FLAGS :: pty_flags_get_type
TYPE_WRITE_FLAGS :: write_flags_get_type
TYPE_REGEX_ERROR :: regex_error_get_type
TYPE_FORMAT :: format_get_type
TYPE_ALIGN :: align_get_type
TYPE_UUID_FORMAT :: uuid_format_get_type
TYPE_PROPERTY_FLAGS :: property_flags_get_type
TYPE_PROPERTY_TYPE :: property_type_get_type
TYPE_PROPERTY_ID :: property_id_get_type
TYPE_PROGRESS_HINT :: progress_hint_get_type
MAJOR_VERSION :: 0
MINOR_VERSION :: 84
MICRO_VERSION :: 1

CursorBlinkMode :: enum u32 {CURSOR_BLINK_SYSTEM = 0, CURSOR_BLINK_ON = 1, CURSOR_BLINK_OFF = 2 }
CursorShape :: enum u32 {BLOCK = 0, IBEAM = 1, UNDERLINE = 2 }
TextBlinkMode :: enum u32 {TEXT_BLINK_NEVER = 0, TEXT_BLINK_FOCUSED = 1, TEXT_BLINK_UNFOCUSED = 2, TEXT_BLINK_ALWAYS = 3 }
EraseBinding :: enum u32 {ERASE_AUTO = 0, ERASE_ASCII_BACKSPACE = 1, ERASE_ASCII_DELETE = 2, ERASE_DELETE_SEQUENCE = 3, ERASE_TTY = 4 }
PtyError :: enum u32 {PTY_HELPER_FAILED = 0, PTY98_FAILED = 1 }
PtyFlagsBit :: enum u32 {NO_LASTLOG = 0, NO_UTMP = 1, NO_WTMP = 2, NO_HELPER = 3, NO_FALLBACK = 4, NO_SESSION = 5, NO_CTTY = 6}
PtyFlags :: bit_set[PtyFlagsBit; u32]
PTY_DEFAULT :: PtyFlags{}
WriteFlags :: enum u32 {WRITE_DEFAULT = 0 }
RegexError :: enum u32 {INCOMPATIBLE = 2147483646, NOT_SUPPORTED = 2147483647 }
Format :: enum u32 {TEXT = 1, HTML = 2 }
FeatureFlagsBit :: enum u64 {BIDI = 0, ICU = 1, SYSTEMD = 2, SIXEL = 3}
FeatureFlags :: bit_set[FeatureFlagsBit; u64]
Align :: enum u32 {START = 0, CENTER = 1, END = 2 }
UuidFormatBit :: enum u32 {SIMPLE = 0, BRACED = 1, URN = 2}
UuidFormat :: bit_set[UuidFormatBit; u32]
UUID_FORMAT_ANY :: UuidFormat{.SIMPLE, .BRACED, .URN}
PropertyFlagsBit :: enum u32 {EPHEMERAL = 0}
PropertyFlags :: bit_set[PropertyFlagsBit; u32]
PROPERTY_FLAG_NONE :: PropertyFlags{}
PropertyType :: enum i32 {PROPERTY_INVALID = -1, PROPERTY_VALUELESS = 0, PROPERTY_BOOL = 1, PROPERTY_INT = 2, PROPERTY_UINT = 3, PROPERTY_DOUBLE = 4, PROPERTY_RGB = 5, PROPERTY_RGBA = 6, PROPERTY_STRING = 7, PROPERTY_DATA = 8, PROPERTY_UUID = 9, PROPERTY_URI = 10, PROPERTY_IMAGE = 11 }
PropertyId :: enum u32 {CURRENT_DIRECTORY_URI = 0, CURRENT_FILE_URI = 1, XTERM_TITLE = 2, CONTAINER_NAME = 3, CONTAINER_RUNTIME = 4, CONTAINER_UID = 5, SHELL_PRECMD = 6, SHELL_PREEXEC = 7, SHELL_POSTEXEC = 8, PROGRESS_HINT = 9, PROGRESS_VALUE = 10, ICON_COLOR = 11, ICON_IMAGE = 12 }
ProgressHint :: enum u32 {INACTIVE = 0, ACTIVE = 1, ERROR = 2, INDETERMINATE = 3, PAUSED = 4 }
Pty :: struct #packed {}

PtyClass :: struct #packed {}

Regex :: struct #packed {}

Uuid :: struct #packed {}

EventContext :: struct #packed {}

Terminal :: struct {
    widget: gtk4.Widget,
}

eof_func_ptr_anon_0 :: #type proc "c" (terminal: ^Terminal)
child_exited_func_ptr_anon_1 :: #type proc "c" (terminal: ^Terminal, status: i32)
encoding_changed_func_ptr_anon_2 :: #type proc "c" (terminal: ^Terminal)
char_size_changed_func_ptr_anon_3 :: #type proc "c" (terminal: ^Terminal, char_width: glib.uint_, char_height: glib.uint_)
window_title_changed_func_ptr_anon_4 :: #type proc "c" (terminal: ^Terminal)
icon_title_changed_func_ptr_anon_5 :: #type proc "c" (terminal: ^Terminal)
selection_changed_func_ptr_anon_6 :: #type proc "c" (terminal: ^Terminal)
contents_changed_func_ptr_anon_7 :: #type proc "c" (terminal: ^Terminal)
cursor_moved_func_ptr_anon_8 :: #type proc "c" (terminal: ^Terminal)
commit_func_ptr_anon_9 :: #type proc "c" (terminal: ^Terminal, text: cstring, size_p: glib.uint_)
deiconify_window_func_ptr_anon_10 :: #type proc "c" (terminal: ^Terminal)
iconify_window_func_ptr_anon_11 :: #type proc "c" (terminal: ^Terminal)
raise_window_func_ptr_anon_12 :: #type proc "c" (terminal: ^Terminal)
lower_window_func_ptr_anon_13 :: #type proc "c" (terminal: ^Terminal)
refresh_window_func_ptr_anon_14 :: #type proc "c" (terminal: ^Terminal)
restore_window_func_ptr_anon_15 :: #type proc "c" (terminal: ^Terminal)
maximize_window_func_ptr_anon_16 :: #type proc "c" (terminal: ^Terminal)
resize_window_func_ptr_anon_17 :: #type proc "c" (terminal: ^Terminal, width: glib.uint_, height: glib.uint_)
move_window_func_ptr_anon_18 :: #type proc "c" (terminal: ^Terminal, x: glib.uint_, y: glib.uint_)
increase_font_size_func_ptr_anon_19 :: #type proc "c" (terminal: ^Terminal)
decrease_font_size_func_ptr_anon_20 :: #type proc "c" (terminal: ^Terminal)
copy_clipboard_func_ptr_anon_21 :: #type proc "c" (terminal: ^Terminal)
paste_clipboard_func_ptr_anon_22 :: #type proc "c" (terminal: ^Terminal)
bell_func_ptr_anon_23 :: #type proc "c" (terminal: ^Terminal)
setup_context_menu_func_ptr_anon_24 :: #type proc "c" (terminal: ^Terminal, context_p: ^EventContext)
termprops_changed_func_ptr_anon_25 :: #type proc "c" (terminal: ^Terminal, props: [^]i32, n_props: i32) -> glib.boolean
termprop_changed_func_ptr_anon_26 :: #type proc "c" (terminal: ^Terminal, prop: cstring)
TerminalClassPrivate :: struct #packed {}

TerminalClass :: struct {
    parent_class: gtk4.WidgetClass,
    eof: eof_func_ptr_anon_0,
    child_exited: child_exited_func_ptr_anon_1,
    encoding_changed: encoding_changed_func_ptr_anon_2,
    char_size_changed: char_size_changed_func_ptr_anon_3,
    window_title_changed: window_title_changed_func_ptr_anon_4,
    icon_title_changed: icon_title_changed_func_ptr_anon_5,
    selection_changed: selection_changed_func_ptr_anon_6,
    contents_changed: contents_changed_func_ptr_anon_7,
    cursor_moved: cursor_moved_func_ptr_anon_8,
    commit: commit_func_ptr_anon_9,
    deiconify_window: deiconify_window_func_ptr_anon_10,
    iconify_window: iconify_window_func_ptr_anon_11,
    raise_window: raise_window_func_ptr_anon_12,
    lower_window: lower_window_func_ptr_anon_13,
    refresh_window: refresh_window_func_ptr_anon_14,
    restore_window: restore_window_func_ptr_anon_15,
    maximize_window: maximize_window_func_ptr_anon_16,
    resize_window: resize_window_func_ptr_anon_17,
    move_window: move_window_func_ptr_anon_18,
    increase_font_size: increase_font_size_func_ptr_anon_19,
    decrease_font_size: decrease_font_size_func_ptr_anon_20,
    copy_clipboard: copy_clipboard_func_ptr_anon_21,
    paste_clipboard: paste_clipboard_func_ptr_anon_22,
    bell: bell_func_ptr_anon_23,
    setup_context_menu: setup_context_menu_func_ptr_anon_24,
    termprops_changed: termprops_changed_func_ptr_anon_25,
    termprop_changed: termprop_changed_func_ptr_anon_26,
    _padding: [13]glib.pointer,
    priv: ^TerminalClassPrivate,
}

TerminalSpawnAsyncCallback :: #type proc "c" (terminal: ^Terminal, pid: glib.Pid, error: ^glib.Error, user_data: glib.pointer)
SelectionFunc :: #type proc "c" (terminal: ^Terminal, column: glib.long, row: glib.long, data: glib.pointer) -> glib.boolean
CharAttributes :: struct {
    row, column: i64,
    fore, back:  pango.Color,
    flags:       bit_field u32 {
        underline:     u32 | 1,
        strikethrough: u32 | 1,
        columns:       u32 | 4,
    },
}


@(default_calling_convention = "c")
foreign vte_runic {
    @(link_name = "vte_get_user_shell")
    get_user_shell :: proc() -> cstring ---

    @(link_name = "vte_get_features")
    get_features :: proc() -> cstring ---

    @(link_name = "vte_get_feature_flags")
    get_feature_flags :: proc() -> FeatureFlags ---

    @(link_name = "vte_set_test_flags")
    set_test_flags :: proc(flags: glib.uint64) ---

    @(link_name = "vte_get_test_flags")
    get_test_flags :: proc() -> glib.uint64 ---

    @(link_name = "vte_install_termprop")
    install_termprop :: proc(name: cstring, type: PropertyType, flags: PropertyFlags) -> i32 ---

    @(link_name = "vte_install_termprop_alias")
    install_termprop_alias :: proc(name: cstring, target_name: cstring) -> i32 ---

    @(link_name = "vte_get_termprops")
    get_termprops :: proc(length: ^glib.size) -> ^cstring ---

    @(link_name = "vte_query_termprop")
    query_termprop :: proc(name: cstring, resolved_name: ^cstring, prop: ^i32, type: ^PropertyType, flags: ^PropertyFlags) -> glib.boolean ---

    @(link_name = "vte_query_termprop_by_id")
    query_termprop_by_id :: proc(prop: i32, name: ^cstring, type: ^PropertyType, flags: ^PropertyFlags) -> glib.boolean ---

    @(link_name = "vte_pty_error_quark")
    pty_error_quark :: proc() -> glib.Quark ---

    @(link_name = "vte_pty_get_type")
    pty_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_pty_new_sync")
    pty_new_sync :: proc(flags: PtyFlags, cancellable: ^gio.Cancellable, error: ^^glib.Error) -> ^Pty ---

    @(link_name = "vte_pty_new_foreign_sync")
    pty_new_foreign_sync :: proc(fd: i32, cancellable: ^gio.Cancellable, error: ^^glib.Error) -> ^Pty ---

    @(link_name = "vte_pty_get_fd")
    pty_get_fd :: proc(pty: ^Pty) -> i32 ---

    @(link_name = "vte_pty_child_setup")
    pty_child_setup :: proc(pty: ^Pty) ---

    @(link_name = "vte_pty_get_size")
    pty_get_size :: proc(pty: ^Pty, rows: ^i32, columns: ^i32, error: ^^glib.Error) -> glib.boolean ---

    @(link_name = "vte_pty_set_size")
    pty_set_size :: proc(pty: ^Pty, rows: i32, columns: i32, error: ^^glib.Error) -> glib.boolean ---

    @(link_name = "vte_pty_set_utf8")
    pty_set_utf8 :: proc(pty: ^Pty, utf8: glib.boolean, error: ^^glib.Error) -> glib.boolean ---

    @(link_name = "vte_pty_spawn_async")
    pty_spawn_async :: proc(pty: ^Pty, working_directory: cstring, argv: ^cstring, envv: ^cstring, spawn_flags: glib.SpawnFlags, child_setup: glib.SpawnChildSetupFunc, child_setup_data: glib.pointer, child_setup_data_destroy: glib.DestroyNotify, timeout: i32, cancellable: ^gio.Cancellable, callback: gio.AsyncReadyCallback, user_data: glib.pointer) ---

    @(link_name = "vte_pty_spawn_with_fds_async")
    pty_spawn_with_fds_async :: proc(pty: ^Pty, working_directory: cstring, argv: ^cstring, envv: ^cstring, fds: [^]i32, n_fds: i32, map_fds: [^]i32, n_map_fds: i32, spawn_flags: glib.SpawnFlags, child_setup: glib.SpawnChildSetupFunc, child_setup_data: glib.pointer, child_setup_data_destroy: glib.DestroyNotify, timeout: i32, cancellable: ^gio.Cancellable, callback: gio.AsyncReadyCallback, user_data: glib.pointer) ---

    @(link_name = "vte_pty_spawn_finish")
    pty_spawn_finish :: proc(pty: ^Pty, result: ^gio.AsyncResult, child_pid: ^glib.Pid, error: ^^glib.Error) -> glib.boolean ---

    @(link_name = "vte_regex_get_type")
    regex_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_regex_error_quark")
    regex_error_quark :: proc() -> glib.Quark ---

    @(link_name = "vte_regex_ref")
    regex_ref :: proc(regex: ^Regex) -> ^Regex ---

    @(link_name = "vte_regex_unref")
    regex_unref :: proc(regex: ^Regex) -> ^Regex ---

    @(link_name = "vte_regex_new_for_match")
    regex_new_for_match :: proc(pattern: cstring, pattern_length: glib.ssize, flags: glib.uint32, error: ^^glib.Error) -> ^Regex ---

    @(link_name = "vte_regex_new_for_match_full")
    regex_new_for_match_full :: proc(pattern: cstring, pattern_length: glib.ssize, flags: u32, extra_flags: u32, error_offset: ^glib.size, error: ^^glib.Error) -> ^Regex ---

    @(link_name = "vte_regex_new_for_search")
    regex_new_for_search :: proc(pattern: cstring, pattern_length: glib.ssize, flags: glib.uint32, error: ^^glib.Error) -> ^Regex ---

    @(link_name = "vte_regex_new_for_search_full")
    regex_new_for_search_full :: proc(pattern: cstring, pattern_length: glib.ssize, flags: u32, extra_flags: u32, error_offset: ^glib.size, error: ^^glib.Error) -> ^Regex ---

    @(link_name = "vte_regex_jit")
    regex_jit :: proc(regex: ^Regex, flags: glib.uint32, error: ^^glib.Error) -> glib.boolean ---

    @(link_name = "vte_regex_substitute")
    regex_substitute :: proc(regex: ^Regex, subject: cstring, replacement: cstring, flags: glib.uint32, error: ^^glib.Error) -> cstring ---

    @(link_name = "vte_uuid_get_type")
    uuid_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_uuid_new_v4")
    uuid_new_v4 :: proc() -> ^Uuid ---

    @(link_name = "vte_uuid_new_v5")
    uuid_new_v5 :: proc(ns: ^Uuid, data: cstring, len: glib.ssize) -> ^Uuid ---

    @(link_name = "vte_uuid_new_from_string")
    uuid_new_from_string :: proc(str: cstring, len: glib.ssize, fmt: UuidFormat) -> ^Uuid ---

    @(link_name = "vte_uuid_dup")
    uuid_dup :: proc(uuid: ^Uuid) -> ^Uuid ---

    @(link_name = "vte_uuid_free")
    uuid_free :: proc(uuid: ^Uuid) ---

    @(link_name = "vte_uuid_free_to_string")
    uuid_free_to_string :: proc(uuid: ^Uuid, fmt: UuidFormat, len: ^glib.size) -> cstring ---

    @(link_name = "vte_uuid_to_string")
    uuid_to_string :: proc(uuid: ^Uuid, fmt: UuidFormat, len: ^glib.size) -> cstring ---

    @(link_name = "vte_uuid_equal")
    uuid_equal :: proc(uuid: ^Uuid, other: ^Uuid) -> glib.boolean ---

    @(link_name = "vte_uuid_validate_string")
    uuid_validate_string :: proc(str: cstring, len: glib.ssize, fmt: UuidFormat) -> glib.boolean ---

    @(link_name = "vte_terminal_get_type")
    terminal_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_terminal_new")
    terminal_new :: proc() -> ^gtk4.Widget ---

    @(link_name = "vte_terminal_pty_new_sync")
    terminal_pty_new_sync :: proc(terminal: ^Terminal, flags: PtyFlags, cancellable: ^gio.Cancellable, error: ^^glib.Error) -> ^Pty ---

    @(link_name = "vte_terminal_watch_child")
    terminal_watch_child :: proc(terminal: ^Terminal, child_pid: glib.Pid) ---

    @(link_name = "vte_terminal_spawn_async")
    terminal_spawn_async :: proc(terminal: ^Terminal, pty_flags: PtyFlags, working_directory: cstring, argv: ^cstring, envv: ^cstring, spawn_flags: glib.SpawnFlags, child_setup: glib.SpawnChildSetupFunc, child_setup_data: glib.pointer, child_setup_data_destroy: glib.DestroyNotify, timeout: i32, cancellable: ^gio.Cancellable, callback: TerminalSpawnAsyncCallback, user_data: glib.pointer) ---

    @(link_name = "vte_terminal_spawn_with_fds_async")
    terminal_spawn_with_fds_async :: proc(terminal: ^Terminal, pty_flags: PtyFlags, working_directory: cstring, argv: ^cstring, envv: ^cstring, fds: [^]i32, n_fds: i32, map_fds: [^]i32, n_map_fds: i32, spawn_flags: glib.SpawnFlags, child_setup: glib.SpawnChildSetupFunc, child_setup_data: glib.pointer, child_setup_data_destroy: glib.DestroyNotify, timeout: i32, cancellable: ^gio.Cancellable, callback: TerminalSpawnAsyncCallback, user_data: glib.pointer) ---

    @(link_name = "vte_terminal_feed")
    terminal_feed :: proc(terminal: ^Terminal, data: cstring, length: glib.ssize) ---

    @(link_name = "vte_terminal_feed_child")
    terminal_feed_child :: proc(terminal: ^Terminal, text: cstring, length: glib.ssize) ---

    @(link_name = "vte_terminal_copy_clipboard_format")
    terminal_copy_clipboard_format :: proc(terminal: ^Terminal, format: Format) ---

    @(link_name = "vte_terminal_paste_clipboard")
    terminal_paste_clipboard :: proc(terminal: ^Terminal) ---

    @(link_name = "vte_terminal_paste_text")
    terminal_paste_text :: proc(terminal: ^Terminal, text: cstring) ---

    @(link_name = "vte_terminal_copy_primary")
    terminal_copy_primary :: proc(terminal: ^Terminal) ---

    @(link_name = "vte_terminal_paste_primary")
    terminal_paste_primary :: proc(terminal: ^Terminal) ---

    @(link_name = "vte_terminal_select_all")
    terminal_select_all :: proc(terminal: ^Terminal) ---

    @(link_name = "vte_terminal_unselect_all")
    terminal_unselect_all :: proc(terminal: ^Terminal) ---

    @(link_name = "vte_terminal_set_word_char_exceptions")
    terminal_set_word_char_exceptions :: proc(terminal: ^Terminal, exceptions: cstring) ---

    @(link_name = "vte_terminal_get_word_char_exceptions")
    terminal_get_word_char_exceptions :: proc(terminal: ^Terminal) -> cstring ---

    @(link_name = "vte_terminal_set_size")
    terminal_set_size :: proc(terminal: ^Terminal, columns: glib.long, rows: glib.long) ---

    @(link_name = "vte_terminal_set_font_scale")
    terminal_set_font_scale :: proc(terminal: ^Terminal, scale: glib.double) ---

    @(link_name = "vte_terminal_get_font_scale")
    terminal_get_font_scale :: proc(terminal: ^Terminal) -> glib.double ---

    @(link_name = "vte_terminal_set_font_options")
    terminal_set_font_options :: proc(terminal: ^Terminal, font_options: ^cairo.font_options_t) ---

    @(link_name = "vte_terminal_get_font_options")
    terminal_get_font_options :: proc(terminal: ^Terminal) -> ^cairo.font_options_t ---

    @(link_name = "vte_terminal_set_cell_width_scale")
    terminal_set_cell_width_scale :: proc(terminal: ^Terminal, scale: f64) ---

    @(link_name = "vte_terminal_get_cell_width_scale")
    terminal_get_cell_width_scale :: proc(terminal: ^Terminal) -> f64 ---

    @(link_name = "vte_terminal_set_cell_height_scale")
    terminal_set_cell_height_scale :: proc(terminal: ^Terminal, scale: f64) ---

    @(link_name = "vte_terminal_get_cell_height_scale")
    terminal_get_cell_height_scale :: proc(terminal: ^Terminal) -> f64 ---

    @(link_name = "vte_terminal_set_text_blink_mode")
    terminal_set_text_blink_mode :: proc(terminal: ^Terminal, text_blink_mode: TextBlinkMode) ---

    @(link_name = "vte_terminal_get_text_blink_mode")
    terminal_get_text_blink_mode :: proc(terminal: ^Terminal) -> TextBlinkMode ---

    @(link_name = "vte_terminal_set_audible_bell")
    terminal_set_audible_bell :: proc(terminal: ^Terminal, is_audible: glib.boolean) ---

    @(link_name = "vte_terminal_get_audible_bell")
    terminal_get_audible_bell :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_scroll_on_output")
    terminal_set_scroll_on_output :: proc(terminal: ^Terminal, scroll: glib.boolean) ---

    @(link_name = "vte_terminal_set_scroll_on_insert")
    terminal_set_scroll_on_insert :: proc(terminal: ^Terminal, scroll: glib.boolean) ---

    @(link_name = "vte_terminal_get_scroll_on_insert")
    terminal_get_scroll_on_insert :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_get_scroll_on_output")
    terminal_get_scroll_on_output :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_scroll_on_keystroke")
    terminal_set_scroll_on_keystroke :: proc(terminal: ^Terminal, scroll: glib.boolean) ---

    @(link_name = "vte_terminal_get_scroll_on_keystroke")
    terminal_get_scroll_on_keystroke :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_enable_fallback_scrolling")
    terminal_set_enable_fallback_scrolling :: proc(terminal: ^Terminal, enable: glib.boolean) ---

    @(link_name = "vte_terminal_get_enable_fallback_scrolling")
    terminal_get_enable_fallback_scrolling :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_scroll_unit_is_pixels")
    terminal_set_scroll_unit_is_pixels :: proc(terminal: ^Terminal, enable: glib.boolean) ---

    @(link_name = "vte_terminal_get_scroll_unit_is_pixels")
    terminal_get_scroll_unit_is_pixels :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_color_bold")
    terminal_set_color_bold :: proc(terminal: ^Terminal, bold: ^gtk4.RGBA) ---

    @(link_name = "vte_terminal_set_color_foreground")
    terminal_set_color_foreground :: proc(terminal: ^Terminal, foreground: ^gtk4.RGBA) ---

    @(link_name = "vte_terminal_set_color_background")
    terminal_set_color_background :: proc(terminal: ^Terminal, background: ^gtk4.RGBA) ---

    @(link_name = "vte_terminal_set_color_cursor")
    terminal_set_color_cursor :: proc(terminal: ^Terminal, cursor_background: ^gtk4.RGBA) ---

    @(link_name = "vte_terminal_set_color_cursor_foreground")
    terminal_set_color_cursor_foreground :: proc(terminal: ^Terminal, cursor_foreground: ^gtk4.RGBA) ---

    @(link_name = "vte_terminal_set_color_highlight")
    terminal_set_color_highlight :: proc(terminal: ^Terminal, highlight_background: ^gtk4.RGBA) ---

    @(link_name = "vte_terminal_set_color_highlight_foreground")
    terminal_set_color_highlight_foreground :: proc(terminal: ^Terminal, highlight_foreground: ^gtk4.RGBA) ---

    @(link_name = "vte_terminal_set_colors")
    terminal_set_colors :: proc(terminal: ^Terminal, foreground: ^gtk4.RGBA, background: ^gtk4.RGBA, palette: ^gtk4.RGBA, palette_size: glib.size) ---

    @(link_name = "vte_terminal_set_default_colors")
    terminal_set_default_colors :: proc(terminal: ^Terminal) ---

    @(link_name = "vte_terminal_set_cursor_blink_mode")
    terminal_set_cursor_blink_mode :: proc(terminal: ^Terminal, mode: CursorBlinkMode) ---

    @(link_name = "vte_terminal_get_cursor_blink_mode")
    terminal_get_cursor_blink_mode :: proc(terminal: ^Terminal) -> CursorBlinkMode ---

    @(link_name = "vte_terminal_set_cursor_shape")
    terminal_set_cursor_shape :: proc(terminal: ^Terminal, shape: CursorShape) ---

    @(link_name = "vte_terminal_get_cursor_shape")
    terminal_get_cursor_shape :: proc(terminal: ^Terminal) -> CursorShape ---

    @(link_name = "vte_terminal_set_scrollback_lines")
    terminal_set_scrollback_lines :: proc(terminal: ^Terminal, lines: glib.long) ---

    @(link_name = "vte_terminal_get_scrollback_lines")
    terminal_get_scrollback_lines :: proc(terminal: ^Terminal) -> glib.long ---

    @(link_name = "vte_terminal_set_font")
    terminal_set_font :: proc(terminal: ^Terminal, font_desc: ^pango.FontDescription) ---

    @(link_name = "vte_terminal_get_font")
    terminal_get_font :: proc(terminal: ^Terminal) -> ^pango.FontDescription ---

    @(link_name = "vte_terminal_set_bold_is_bright")
    terminal_set_bold_is_bright :: proc(terminal: ^Terminal, bold_is_bright: glib.boolean) ---

    @(link_name = "vte_terminal_get_bold_is_bright")
    terminal_get_bold_is_bright :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_allow_hyperlink")
    terminal_set_allow_hyperlink :: proc(terminal: ^Terminal, allow_hyperlink: glib.boolean) ---

    @(link_name = "vte_terminal_get_allow_hyperlink")
    terminal_get_allow_hyperlink :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_get_has_selection")
    terminal_get_has_selection :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_get_text_selected")
    terminal_get_text_selected :: proc(terminal: ^Terminal, format: Format) -> cstring ---

    @(link_name = "vte_terminal_get_text_selected_full")
    terminal_get_text_selected_full :: proc(terminal: ^Terminal, format: Format, length: ^glib.size) -> cstring ---

    @(link_name = "vte_terminal_set_backspace_binding")
    terminal_set_backspace_binding :: proc(terminal: ^Terminal, binding: EraseBinding) ---

    @(link_name = "vte_terminal_set_delete_binding")
    terminal_set_delete_binding :: proc(terminal: ^Terminal, binding: EraseBinding) ---

    @(link_name = "vte_terminal_set_enable_a11y")
    terminal_set_enable_a11y :: proc(terminal: ^Terminal, enable_a11y: glib.boolean) ---

    @(link_name = "vte_terminal_get_enable_a11y")
    terminal_get_enable_a11y :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_enable_bidi")
    terminal_set_enable_bidi :: proc(terminal: ^Terminal, enable_bidi: glib.boolean) ---

    @(link_name = "vte_terminal_get_enable_bidi")
    terminal_get_enable_bidi :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_enable_shaping")
    terminal_set_enable_shaping :: proc(terminal: ^Terminal, enable_shaping: glib.boolean) ---

    @(link_name = "vte_terminal_get_enable_shaping")
    terminal_get_enable_shaping :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_mouse_autohide")
    terminal_set_mouse_autohide :: proc(terminal: ^Terminal, setting: glib.boolean) ---

    @(link_name = "vte_terminal_get_mouse_autohide")
    terminal_get_mouse_autohide :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_reset")
    terminal_reset :: proc(terminal: ^Terminal, clear_tabstops: glib.boolean, clear_history: glib.boolean) ---

    @(link_name = "vte_terminal_get_text_format")
    terminal_get_text_format :: proc(terminal: ^Terminal, format: Format) -> cstring ---

    @(link_name = "vte_terminal_get_text_range_format")
    terminal_get_text_range_format :: proc(terminal: ^Terminal, format: Format, start_row: i64, start_col: i64, end_row: i64, end_col: i64, length: ^glib.size) -> cstring ---

    @(link_name = "vte_terminal_get_cursor_position")
    terminal_get_cursor_position :: proc(terminal: ^Terminal, column: ^glib.long, row: ^glib.long) ---

    @(link_name = "vte_terminal_check_hyperlink_at")
    terminal_check_hyperlink_at :: proc(terminal: ^Terminal, x: f64, y: f64) -> cstring ---

    @(link_name = "vte_terminal_match_add_regex")
    terminal_match_add_regex :: proc(terminal: ^Terminal, regex: ^Regex, flags: glib.uint32) -> i32 ---

    @(link_name = "vte_terminal_match_set_cursor_name")
    terminal_match_set_cursor_name :: proc(terminal: ^Terminal, tag: i32, cursor_name: cstring) ---

    @(link_name = "vte_terminal_match_remove")
    terminal_match_remove :: proc(terminal: ^Terminal, tag: i32) ---

    @(link_name = "vte_terminal_match_remove_all")
    terminal_match_remove_all :: proc(terminal: ^Terminal) ---

    @(link_name = "vte_terminal_check_match_at")
    terminal_check_match_at :: proc(terminal: ^Terminal, x: f64, y: f64, tag: ^i32) -> cstring ---

    @(link_name = "vte_terminal_check_regex_array_at")
    terminal_check_regex_array_at :: proc(terminal: ^Terminal, x: f64, y: f64, regexes: [^]^Regex, n_regexes: glib.size, match_flags: glib.uint32, n_matches: ^glib.size) -> ^cstring ---

    @(link_name = "vte_terminal_check_regex_simple_at")
    terminal_check_regex_simple_at :: proc(terminal: ^Terminal, x: f64, y: f64, regexes: [^]^Regex, n_regexes: glib.size, match_flags: glib.uint32, matches: [^]cstring) -> glib.boolean ---

    @(link_name = "vte_terminal_search_set_regex")
    terminal_search_set_regex :: proc(terminal: ^Terminal, regex: ^Regex, flags: glib.uint32) ---

    @(link_name = "vte_terminal_search_get_regex")
    terminal_search_get_regex :: proc(terminal: ^Terminal) -> ^Regex ---

    @(link_name = "vte_terminal_search_set_wrap_around")
    terminal_search_set_wrap_around :: proc(terminal: ^Terminal, wrap_around: glib.boolean) ---

    @(link_name = "vte_terminal_search_get_wrap_around")
    terminal_search_get_wrap_around :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_search_find_previous")
    terminal_search_find_previous :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_search_find_next")
    terminal_search_find_next :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_cjk_ambiguous_width")
    terminal_set_cjk_ambiguous_width :: proc(terminal: ^Terminal, width: i32) ---

    @(link_name = "vte_terminal_get_cjk_ambiguous_width")
    terminal_get_cjk_ambiguous_width :: proc(terminal: ^Terminal) -> i32 ---

    @(link_name = "vte_terminal_set_pty")
    terminal_set_pty :: proc(terminal: ^Terminal, pty: ^Pty) ---

    @(link_name = "vte_terminal_get_pty")
    terminal_get_pty :: proc(terminal: ^Terminal) -> ^Pty ---

    @(link_name = "vte_terminal_get_char_width")
    terminal_get_char_width :: proc(terminal: ^Terminal) -> glib.long ---

    @(link_name = "vte_terminal_get_char_height")
    terminal_get_char_height :: proc(terminal: ^Terminal) -> glib.long ---

    @(link_name = "vte_terminal_get_row_count")
    terminal_get_row_count :: proc(terminal: ^Terminal) -> glib.long ---

    @(link_name = "vte_terminal_get_column_count")
    terminal_get_column_count :: proc(terminal: ^Terminal) -> glib.long ---

    @(link_name = "vte_terminal_set_input_enabled")
    terminal_set_input_enabled :: proc(terminal: ^Terminal, enabled: glib.boolean) ---

    @(link_name = "vte_terminal_get_input_enabled")
    terminal_get_input_enabled :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_clear_background")
    terminal_set_clear_background :: proc(terminal: ^Terminal, setting: glib.boolean) ---

    @(link_name = "vte_terminal_get_color_background_for_draw")
    terminal_get_color_background_for_draw :: proc(terminal: ^Terminal, color: ^gtk4.RGBA) ---

    @(link_name = "vte_terminal_set_suppress_legacy_signals")
    terminal_set_suppress_legacy_signals :: proc(terminal: ^Terminal) ---

    @(link_name = "vte_terminal_write_contents_sync")
    terminal_write_contents_sync :: proc(terminal: ^Terminal, stream: ^gio.OutputStream, flags: WriteFlags, cancellable: ^gio.Cancellable, error: ^^glib.Error) -> glib.boolean ---

    @(link_name = "vte_terminal_set_enable_sixel")
    terminal_set_enable_sixel :: proc(terminal: ^Terminal, enabled: glib.boolean) ---

    @(link_name = "vte_terminal_get_enable_sixel")
    terminal_get_enable_sixel :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_xalign")
    terminal_set_xalign :: proc(terminal: ^Terminal, align: Align) ---

    @(link_name = "vte_terminal_get_xalign")
    terminal_get_xalign :: proc(terminal: ^Terminal) -> Align ---

    @(link_name = "vte_terminal_set_yalign")
    terminal_set_yalign :: proc(terminal: ^Terminal, align: Align) ---

    @(link_name = "vte_terminal_get_yalign")
    terminal_get_yalign :: proc(terminal: ^Terminal) -> Align ---

    @(link_name = "vte_terminal_set_xfill")
    terminal_set_xfill :: proc(terminal: ^Terminal, fill: glib.boolean) ---

    @(link_name = "vte_terminal_get_xfill")
    terminal_get_xfill :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_yfill")
    terminal_set_yfill :: proc(terminal: ^Terminal, fill: glib.boolean) ---

    @(link_name = "vte_terminal_get_yfill")
    terminal_get_yfill :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_enable_legacy_osc777")
    terminal_set_enable_legacy_osc777 :: proc(terminal: ^Terminal, enable: glib.boolean) ---

    @(link_name = "vte_terminal_get_enable_legacy_osc777")
    terminal_get_enable_legacy_osc777 :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_context_menu_model")
    terminal_set_context_menu_model :: proc(terminal: ^Terminal, model: ^gio.MenuModel) ---

    @(link_name = "vte_terminal_get_context_menu_model")
    terminal_get_context_menu_model :: proc(terminal: ^Terminal) -> ^gio.MenuModel ---

    @(link_name = "vte_terminal_set_context_menu")
    terminal_set_context_menu :: proc(terminal: ^Terminal, menu: ^gtk4.Widget) ---

    @(link_name = "vte_terminal_get_context_menu")
    terminal_get_context_menu :: proc(terminal: ^Terminal) -> ^gtk4.Widget ---

    @(link_name = "vte_event_context_get_type")
    event_context_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_event_context_get_coordinates")
    event_context_get_coordinates :: proc(context_p: ^EventContext, x: ^f64, y: ^f64) -> glib.boolean ---

    @(link_name = "vte_terminal_get_termprop_bool")
    terminal_get_termprop_bool :: proc(terminal: ^Terminal, prop: cstring, valuep: ^glib.boolean) -> glib.boolean ---

    @(link_name = "vte_terminal_get_termprop_bool_by_id")
    terminal_get_termprop_bool_by_id :: proc(terminal: ^Terminal, prop: i32, valuep: ^glib.boolean) -> glib.boolean ---

    @(link_name = "vte_terminal_get_termprop_int")
    terminal_get_termprop_int :: proc(terminal: ^Terminal, prop: cstring, valuep: ^i64) -> glib.boolean ---

    @(link_name = "vte_terminal_get_termprop_int_by_id")
    terminal_get_termprop_int_by_id :: proc(terminal: ^Terminal, prop: i32, valuep: ^i64) -> glib.boolean ---

    @(link_name = "vte_terminal_get_termprop_uint")
    terminal_get_termprop_uint :: proc(terminal: ^Terminal, prop: cstring, valuep: ^u64) -> glib.boolean ---

    @(link_name = "vte_terminal_get_termprop_uint_by_id")
    terminal_get_termprop_uint_by_id :: proc(terminal: ^Terminal, prop: i32, valuep: ^u64) -> glib.boolean ---

    @(link_name = "vte_terminal_get_termprop_double")
    terminal_get_termprop_double :: proc(terminal: ^Terminal, prop: cstring, valuep: ^f64) -> glib.boolean ---

    @(link_name = "vte_terminal_get_termprop_double_by_id")
    terminal_get_termprop_double_by_id :: proc(terminal: ^Terminal, prop: i32, valuep: ^f64) -> glib.boolean ---

    @(link_name = "vte_terminal_get_termprop_rgba")
    terminal_get_termprop_rgba :: proc(terminal: ^Terminal, prop: cstring, color: ^gtk4.RGBA) -> glib.boolean ---

    @(link_name = "vte_terminal_get_termprop_rgba_by_id")
    terminal_get_termprop_rgba_by_id :: proc(terminal: ^Terminal, prop: i32, color: ^gtk4.RGBA) -> glib.boolean ---

    @(link_name = "vte_terminal_get_termprop_string")
    terminal_get_termprop_string :: proc(terminal: ^Terminal, prop: cstring, size_p: ^uint) -> cstring ---

    @(link_name = "vte_terminal_get_termprop_string_by_id")
    terminal_get_termprop_string_by_id :: proc(terminal: ^Terminal, prop: i32, size_p: ^uint) -> cstring ---

    @(link_name = "vte_terminal_dup_termprop_string")
    terminal_dup_termprop_string :: proc(terminal: ^Terminal, prop: cstring, size_p: ^uint) -> cstring ---

    @(link_name = "vte_terminal_dup_termprop_string_by_id")
    terminal_dup_termprop_string_by_id :: proc(terminal: ^Terminal, prop: i32, size_p: ^uint) -> cstring ---

    @(link_name = "vte_terminal_get_termprop_data")
    terminal_get_termprop_data :: proc(terminal: ^Terminal, prop: cstring, size_p: ^uint) -> ^u8 ---

    @(link_name = "vte_terminal_get_termprop_data_by_id")
    terminal_get_termprop_data_by_id :: proc(terminal: ^Terminal, prop: i32, size_p: ^uint) -> ^u8 ---

    @(link_name = "vte_terminal_ref_termprop_data_bytes")
    terminal_ref_termprop_data_bytes :: proc(terminal: ^Terminal, prop: cstring) -> ^glib.Bytes ---

    @(link_name = "vte_terminal_ref_termprop_data_bytes_by_id")
    terminal_ref_termprop_data_bytes_by_id :: proc(terminal: ^Terminal, prop: i32) -> ^glib.Bytes ---

    @(link_name = "vte_terminal_dup_termprop_uuid")
    terminal_dup_termprop_uuid :: proc(terminal: ^Terminal, prop: cstring) -> ^Uuid ---

    @(link_name = "vte_terminal_dup_termprop_uuid_by_id")
    terminal_dup_termprop_uuid_by_id :: proc(terminal: ^Terminal, prop: i32) -> ^Uuid ---

    @(link_name = "vte_terminal_ref_termprop_uri")
    terminal_ref_termprop_uri :: proc(terminal: ^Terminal, prop: cstring) -> ^glib.Uri ---

    @(link_name = "vte_terminal_ref_termprop_uri_by_id")
    terminal_ref_termprop_uri_by_id :: proc(terminal: ^Terminal, prop: i32) -> ^glib.Uri ---

    @(link_name = "vte_terminal_ref_termprop_image_surface")
    terminal_ref_termprop_image_surface :: proc(terminal: ^Terminal, prop: cstring) -> ^cairo.surface_t ---

    @(link_name = "vte_terminal_ref_termprop_image_surface_by_id")
    terminal_ref_termprop_image_surface_by_id :: proc(terminal: ^Terminal, prop: i32) -> ^cairo.surface_t ---

    @(link_name = "vte_terminal_ref_termprop_image_texture")
    terminal_ref_termprop_image_texture :: proc(terminal: ^Terminal, prop: cstring) -> ^gtk4.Texture ---

    @(link_name = "vte_terminal_ref_termprop_image_texture_by_id")
    terminal_ref_termprop_image_texture_by_id :: proc(terminal: ^Terminal, prop: i32) -> ^gtk4.Texture ---

    @(link_name = "vte_terminal_get_termprop_value")
    terminal_get_termprop_value :: proc(terminal: ^Terminal, prop: cstring, gvalue: ^gobj.Value) -> glib.boolean ---

    @(link_name = "vte_terminal_get_termprop_value_by_id")
    terminal_get_termprop_value_by_id :: proc(terminal: ^Terminal, prop: i32, gvalue: ^gobj.Value) -> glib.boolean ---

    @(link_name = "vte_terminal_ref_termprop_variant")
    terminal_ref_termprop_variant :: proc(terminal: ^Terminal, prop: cstring) -> ^glib.Variant ---

    @(link_name = "vte_terminal_ref_termprop_variant_by_id")
    terminal_ref_termprop_variant_by_id :: proc(terminal: ^Terminal, prop: i32) -> ^glib.Variant ---

    @(link_name = "vte_terminal_get_termprop_enum")
    terminal_get_termprop_enum :: proc(terminal: ^Terminal, prop: cstring, gtype: gobj.Type, valuep: ^i64) -> glib.boolean ---

    @(link_name = "vte_terminal_get_termprop_enum_by_id")
    terminal_get_termprop_enum_by_id :: proc(terminal: ^Terminal, prop: i32, gtype: gobj.Type, valuep: ^i64) -> glib.boolean ---

    @(link_name = "vte_terminal_get_termprop_flags")
    terminal_get_termprop_flags :: proc(terminal: ^Terminal, prop: cstring, gtype: gobj.Type, ignore_unknown_flags: glib.boolean, valuep: ^u64) -> glib.boolean ---

    @(link_name = "vte_terminal_get_termprop_flags_by_id")
    terminal_get_termprop_flags_by_id :: proc(terminal: ^Terminal, prop: i32, gtype: gobj.Type, ignore_unknown_flags: glib.boolean, valuep: ^u64) -> glib.boolean ---

    @(link_name = "vte_terminal_reset_termprop")
    terminal_reset_termprop :: proc(terminal: ^Terminal, prop: cstring) ---

    @(link_name = "vte_terminal_reset_termprop_by_id")
    terminal_reset_termprop_by_id :: proc(terminal: ^Terminal, prop: i32) ---

    @(link_name = "vte_cursor_blink_mode_get_type")
    cursor_blink_mode_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_cursor_shape_get_type")
    cursor_shape_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_text_blink_mode_get_type")
    text_blink_mode_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_erase_binding_get_type")
    erase_binding_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_pty_error_get_type")
    pty_error_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_pty_flags_get_type")
    pty_flags_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_write_flags_get_type")
    write_flags_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_regex_error_get_type")
    regex_error_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_format_get_type")
    format_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_align_get_type")
    align_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_uuid_format_get_type")
    uuid_format_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_property_flags_get_type")
    property_flags_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_property_type_get_type")
    property_type_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_property_id_get_type")
    property_id_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_progress_hint_get_type")
    progress_hint_get_type :: proc() -> gobj.Type ---

    @(link_name = "vte_get_major_version")
    get_major_version :: proc() -> glib.uint_ ---

    @(link_name = "vte_get_minor_version")
    get_minor_version :: proc() -> glib.uint_ ---

    @(link_name = "vte_get_micro_version")
    get_micro_version :: proc() -> glib.uint_ ---

    @(link_name = "vte_terminal_match_set_cursor")
    terminal_match_set_cursor :: proc(terminal: ^Terminal, tag: i32, cursor: ^gtk4.Cursor) ---

    @(link_name = "vte_terminal_match_check")
    terminal_match_check :: proc(terminal: ^Terminal, column: glib.long, row: glib.long, tag: ^i32) -> cstring ---

    @(link_name = "vte_terminal_spawn_sync")
    terminal_spawn_sync :: proc(terminal: ^Terminal, pty_flags: PtyFlags, working_directory: cstring, argv: ^cstring, envv: ^cstring, spawn_flags: glib.SpawnFlags, child_setup: glib.SpawnChildSetupFunc, child_setup_data: glib.pointer, child_pid: ^glib.Pid, cancellable: ^gio.Cancellable, error: ^^glib.Error) -> glib.boolean ---

    @(link_name = "vte_pty_close")
    pty_close :: proc(pty: ^Pty) ---

    @(link_name = "vte_terminal_copy_clipboard")
    terminal_copy_clipboard :: proc(terminal: ^Terminal) ---

    @(link_name = "vte_terminal_get_icon_title")
    terminal_get_icon_title :: proc(terminal: ^Terminal) -> cstring ---

    @(link_name = "vte_terminal_set_encoding")
    terminal_set_encoding :: proc(terminal: ^Terminal, codeset: cstring, error: ^^glib.Error) -> glib.boolean ---

    @(link_name = "vte_terminal_get_encoding")
    terminal_get_encoding :: proc(terminal: ^Terminal) -> cstring ---

    @(link_name = "vte_terminal_get_text")
    terminal_get_text :: proc(terminal: ^Terminal, is_selected: SelectionFunc, user_data: glib.pointer, attributes: ^glib.Array) -> cstring ---

    @(link_name = "vte_terminal_get_text_range")
    terminal_get_text_range :: proc(terminal: ^Terminal, start_row: glib.long, start_col: glib.long, end_row: glib.long, end_col: glib.long, is_selected: SelectionFunc, user_data: glib.pointer, attributes: ^glib.Array) -> cstring ---

    @(link_name = "vte_terminal_get_text_include_trailing_spaces")
    terminal_get_text_include_trailing_spaces :: proc(terminal: ^Terminal, is_selected: SelectionFunc, user_data: glib.pointer, attributes: ^glib.Array) -> cstring ---

    @(link_name = "vte_terminal_set_rewrap_on_resize")
    terminal_set_rewrap_on_resize :: proc(terminal: ^Terminal, rewrap: glib.boolean) ---

    @(link_name = "vte_terminal_get_rewrap_on_resize")
    terminal_get_rewrap_on_resize :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_set_allow_bold")
    terminal_set_allow_bold :: proc(terminal: ^Terminal, allow_bold: glib.boolean) ---

    @(link_name = "vte_terminal_get_allow_bold")
    terminal_get_allow_bold :: proc(terminal: ^Terminal) -> glib.boolean ---

    @(link_name = "vte_terminal_feed_child_binary")
    terminal_feed_child_binary :: proc(terminal: ^Terminal, data: ^glib.uint8, length: glib.size) ---

    @(link_name = "vte_get_encodings")
    get_encodings :: proc(include_aliases: glib.boolean) -> ^cstring ---

    @(link_name = "vte_get_encoding_supported")
    get_encoding_supported :: proc(encoding: cstring) -> glib.boolean ---

    @(link_name = "vte_terminal_get_window_title")
    terminal_get_window_title :: proc(terminal: ^Terminal) -> cstring ---

    @(link_name = "vte_terminal_get_current_directory_uri")
    terminal_get_current_directory_uri :: proc(terminal: ^Terminal) -> cstring ---

    @(link_name = "vte_terminal_get_current_file_uri")
    terminal_get_current_file_uri :: proc(terminal: ^Terminal) -> cstring ---

}

foreign import vte_runic "system:vte-2.91-gtk4"

