package vte

// Hand-written helpers over the generated API; regeneration does not touch this file.
// Typed connect_<signal> procedures for the VteTerminal signals (docs/SPEC.md), built on
// gobject.signal_connect, and the PCRE2 flag values the regex API takes. The callback types
// follow the C signal signatures: the instance first, the signal's parameters, then user_data.

import glib "glib:glib"
import gobj "glib:gobject"
import gtk4 "gtk4:gtk4"

// Handler of a signal that has no parameters: eof, bell, selection-changed, the *-window
// requests, the *-title and *-uri changes, ...
Notification_Proc :: #type proc "c" (terminal: ^Terminal, user_data: glib.pointer)

// "child-exited": status is the exit status of the child watched with watch_child.
Child_Exited_Proc :: #type proc "c" (terminal: ^Terminal, status: i32, user_data: glib.pointer)

// "commit": everything the terminal wants to send to its child: encoded keystrokes, IME
// commits, mouse reports, query replies, pasted text. text is size bytes and not NUL
// terminated. Emitted even with no PTY attached (vte#222).
Commit_Proc :: #type proc "c" (terminal: ^Terminal, text: [^]u8, size: glib.uint_, user_data: glib.pointer)

// "char-size-changed": the cell size in pixels.
Char_Size_Changed_Proc :: #type proc "c" (terminal: ^Terminal, char_width, char_height: glib.uint_, user_data: glib.pointer)

// "resize-window": the size in pixels the application asked for.
Resize_Window_Proc :: #type proc "c" (terminal: ^Terminal, width, height: glib.uint_, user_data: glib.pointer)

// "move-window": the position the application asked for.
Move_Window_Proc :: #type proc "c" (terminal: ^Terminal, x, y: glib.uint_, user_data: glib.pointer)

// "hyperlink-hover-uri-changed": uri and bbox are nil when no hyperlink is hovered. Both are
// owned by VTE and may change after the handler returns.
Hyperlink_Hover_Uri_Changed_Proc :: #type proc "c" (terminal: ^Terminal, uri: cstring, bbox: ^gtk4.Rectangle, user_data: glib.pointer)

// "setup-context-menu": menu_context is non-nil before a context menu is shown and nil after it was
// dismissed; it is valid only during the emission.
Setup_Context_Menu_Proc :: #type proc "c" (terminal: ^Terminal, menu_context: ^EventContext, user_data: glib.pointer)

// "termprop-changed" (0.78): fired with the property name on change or reset. The handler may
// only call vte_terminal_get_termprop_* on the terminal.
Termprop_Changed_Proc :: #type proc "c" (terminal: ^Terminal, name: cstring, user_data: glib.pointer)

// "termprops-changed" (0.78): props lists the n_props ids of the properties that changed.
// Returning true from a handler that runs before the default one suppresses the per-property
// "termprop-changed" emissions.
Termprops_Changed_Proc :: #type proc "c" (terminal: ^Terminal, props: [^]i32, n_props: i32, user_data: glib.pointer) -> glib.boolean

connect_eof :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "eof", handler, data)
}

connect_encoding_changed :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "encoding-changed", handler, data)
}

connect_window_title_changed :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "window-title-changed", handler, data)
}

connect_icon_title_changed :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "icon-title-changed", handler, data)
}

connect_current_directory_uri_changed :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "current-directory-uri-changed", handler, data)
}

connect_current_file_uri_changed :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "current-file-uri-changed", handler, data)
}

connect_selection_changed :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "selection-changed", handler, data)
}

connect_contents_changed :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "contents-changed", handler, data)
}

connect_cursor_moved :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "cursor-moved", handler, data)
}

connect_deiconify_window :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "deiconify-window", handler, data)
}

connect_iconify_window :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "iconify-window", handler, data)
}

connect_raise_window :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "raise-window", handler, data)
}

connect_lower_window :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "lower-window", handler, data)
}

connect_refresh_window :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "refresh-window", handler, data)
}

connect_restore_window :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "restore-window", handler, data)
}

connect_maximize_window :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "maximize-window", handler, data)
}

connect_increase_font_size :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "increase-font-size", handler, data)
}

connect_decrease_font_size :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "decrease-font-size", handler, data)
}

connect_copy_clipboard :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "copy-clipboard", handler, data)
}

connect_paste_clipboard :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "paste-clipboard", handler, data)
}

connect_bell :: #force_inline proc "c" (terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "bell", handler, data)
}

connect_child_exited :: #force_inline proc "c" (terminal: ^Terminal, handler: Child_Exited_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "child-exited", handler, data)
}

connect_commit :: #force_inline proc "c" (terminal: ^Terminal, handler: Commit_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "commit", handler, data)
}

connect_char_size_changed :: #force_inline proc "c" (terminal: ^Terminal, handler: Char_Size_Changed_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "char-size-changed", handler, data)
}

connect_resize_window :: #force_inline proc "c" (terminal: ^Terminal, handler: Resize_Window_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "resize-window", handler, data)
}

connect_move_window :: #force_inline proc "c" (terminal: ^Terminal, handler: Move_Window_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "move-window", handler, data)
}

connect_hyperlink_hover_uri_changed :: #force_inline proc "c" (terminal: ^Terminal, handler: Hyperlink_Hover_Uri_Changed_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "hyperlink-hover-uri-changed", handler, data)
}

connect_setup_context_menu :: #force_inline proc "c" (terminal: ^Terminal, handler: Setup_Context_Menu_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "setup-context-menu", handler, data)
}

connect_termprop_changed :: #force_inline proc "c" (terminal: ^Terminal, handler: Termprop_Changed_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "termprop-changed", handler, data)
}

connect_termprops_changed :: #force_inline proc "c" (terminal: ^Terminal, handler: Termprops_Changed_Proc, data: glib.pointer = nil) -> glib.ulong {
    return gobj.signal_connect(terminal, "termprops-changed", handler, data)
}

// PCRE2 flags (pcre2.h, PCRE2 10.42), the values vteregex.h leaves to the caller. They are
// u32 constants for the guint32 flags parameters; combine with |.

// Compile flags: regex_new_for_match and regex_new_for_search (flags). VTE adds PCRE2_UTF,
// PCRE2_NEVER_BACKSLASH_C and PCRE2_USE_OFFSET_LIMIT itself; REGEX_FLAGS_DEFAULT is the
// recommended set. The terminal's regex search and matching need PCRE2_MULTILINE.
PCRE2_ANCHORED :: u32(0x80000000)
PCRE2_NO_UTF_CHECK :: u32(0x40000000)
PCRE2_ENDANCHORED :: u32(0x20000000)
PCRE2_ALLOW_EMPTY_CLASS :: u32(0x00000001)
PCRE2_ALT_BSUX :: u32(0x00000002)
PCRE2_AUTO_CALLOUT :: u32(0x00000004)
PCRE2_CASELESS :: u32(0x00000008)
PCRE2_DOTALL :: u32(0x00000020)
PCRE2_DUPNAMES :: u32(0x00000040)
PCRE2_EXTENDED :: u32(0x00000080)
PCRE2_MATCH_UNSET_BACKREF :: u32(0x00000200)
PCRE2_MULTILINE :: u32(0x00000400)
PCRE2_NEVER_UCP :: u32(0x00000800)
PCRE2_NEVER_UTF :: u32(0x00001000)
PCRE2_NO_AUTO_CAPTURE :: u32(0x00002000)
PCRE2_NO_AUTO_POSSESS :: u32(0x00004000)
PCRE2_NO_DOTSTAR_ANCHOR :: u32(0x00008000)
PCRE2_UCP :: u32(0x00020000)
PCRE2_UNGREEDY :: u32(0x00040000)
PCRE2_UTF :: u32(0x00080000)
PCRE2_NEVER_BACKSLASH_C :: u32(0x00100000)
PCRE2_ALT_VERBNAMES :: u32(0x00400000)
PCRE2_EXTENDED_MORE :: u32(0x01000000)
PCRE2_LITERAL :: u32(0x02000000)

// Extra compile flags: regex_new_for_match_full and regex_new_for_search_full (extra_flags).
PCRE2_EXTRA_ALLOW_SURROGATE_ESCAPES :: u32(0x00000001)
PCRE2_EXTRA_BAD_ESCAPE_IS_LITERAL :: u32(0x00000002)
PCRE2_EXTRA_MATCH_WORD :: u32(0x00000004)
PCRE2_EXTRA_MATCH_LINE :: u32(0x00000008)
PCRE2_EXTRA_ESCAPED_CR_IS_LF :: u32(0x00000010)
PCRE2_EXTRA_ALT_BSUX :: u32(0x00000020)
PCRE2_EXTRA_ALLOW_LOOKAROUND_BSK :: u32(0x00000040)

// JIT flags: regex_jit.
PCRE2_JIT_COMPLETE :: u32(0x00000001)
PCRE2_JIT_PARTIAL_SOFT :: u32(0x00000002)
PCRE2_JIT_PARTIAL_HARD :: u32(0x00000004)

// Match flags: the flags of terminal_match_add_regex, terminal_search_set_regex and
// terminal_check_regex_simple_at, and, with the PCRE2_SUBSTITUTE_* ones, of regex_substitute
// (which refuses PCRE2_SUBSTITUTE_OVERFLOW_LENGTH, so it is not defined here).
PCRE2_NOTBOL :: u32(0x00000001)
PCRE2_NOTEOL :: u32(0x00000002)
PCRE2_NOTEMPTY :: u32(0x00000004)
PCRE2_NOTEMPTY_ATSTART :: u32(0x00000008)
PCRE2_PARTIAL_SOFT :: u32(0x00000010)
PCRE2_PARTIAL_HARD :: u32(0x00000020)
PCRE2_NO_JIT :: u32(0x00002000)
PCRE2_SUBSTITUTE_GLOBAL :: u32(0x00000100)
PCRE2_SUBSTITUTE_EXTENDED :: u32(0x00000200)
PCRE2_SUBSTITUTE_UNSET_EMPTY :: u32(0x00000400)
PCRE2_SUBSTITUTE_UNKNOWN_UNSET :: u32(0x00000800)
PCRE2_SUBSTITUTE_LITERAL :: u32(0x00008000)
PCRE2_SUBSTITUTE_MATCHED :: u32(0x00010000)
PCRE2_SUBSTITUTE_REPLACEMENT_ONLY :: u32(0x00020000)
