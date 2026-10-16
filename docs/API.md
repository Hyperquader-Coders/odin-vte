# odin-vte API

Every public declaration of every package, generated from the source by `make api`; do not
edit. The short form is the [cheat sheet](CHEATSHEET.md); the rules of the bindings are in the
[README](../README.md) and [PATCHED.md](PATCHED.md).

## vte:vte

```text
package vte
	constants
		MAJOR_VERSION :: 0
		MICRO_VERSION :: 1
		MINOR_VERSION :: 84
		PCRE2_ALLOW_EMPTY_CLASS :: u32(0x00000001)
		PCRE2_ALT_BSUX :: u32(0x00000002)
		PCRE2_ALT_VERBNAMES :: u32(0x00400000)
		PCRE2_ANCHORED :: u32(0x80000000)
			Compile flags: regex_new_for_match and regex_new_for_search (flags). VTE adds PCRE2_UTF,
			PCRE2_NEVER_BACKSLASH_C and PCRE2_USE_OFFSET_LIMIT itself; REGEX_FLAGS_DEFAULT is the
			recommended set. The terminal's regex search and matching need PCRE2_MULTILINE.

		PCRE2_AUTO_CALLOUT :: u32(0x00000004)
		PCRE2_CASELESS :: u32(0x00000008)
		PCRE2_DOTALL :: u32(0x00000020)
		PCRE2_DUPNAMES :: u32(0x00000040)
		PCRE2_ENDANCHORED :: u32(0x20000000)
		PCRE2_EXTENDED :: u32(0x00000080)
		PCRE2_EXTENDED_MORE :: u32(0x01000000)
		PCRE2_EXTRA_ALLOW_LOOKAROUND_BSK :: u32(0x00000040)
		PCRE2_EXTRA_ALLOW_SURROGATE_ESCAPES :: u32(0x00000001)
			Extra compile flags: regex_new_for_match_full and regex_new_for_search_full (extra_flags).

		PCRE2_EXTRA_ALT_BSUX :: u32(0x00000020)
		PCRE2_EXTRA_BAD_ESCAPE_IS_LITERAL :: u32(0x00000002)
		PCRE2_EXTRA_ESCAPED_CR_IS_LF :: u32(0x00000010)
		PCRE2_EXTRA_MATCH_LINE :: u32(0x00000008)
		PCRE2_EXTRA_MATCH_WORD :: u32(0x00000004)
		PCRE2_JIT_COMPLETE :: u32(0x00000001)
			JIT flags: regex_jit.

		PCRE2_JIT_PARTIAL_HARD :: u32(0x00000004)
		PCRE2_JIT_PARTIAL_SOFT :: u32(0x00000002)
		PCRE2_LITERAL :: u32(0x02000000)
		PCRE2_MATCH_UNSET_BACKREF :: u32(0x00000200)
		PCRE2_MULTILINE :: u32(0x00000400)
		PCRE2_NEVER_BACKSLASH_C :: u32(0x00100000)
		PCRE2_NEVER_UCP :: u32(0x00000800)
		PCRE2_NEVER_UTF :: u32(0x00001000)
		PCRE2_NOTBOL :: u32(0x00000001)
			Match flags: the flags of terminal_match_add_regex, terminal_search_set_regex and
			terminal_check_regex_simple_at, and, with the PCRE2_SUBSTITUTE_* ones, of regex_substitute
			(which refuses PCRE2_SUBSTITUTE_OVERFLOW_LENGTH, so it is not defined here).

		PCRE2_NOTEMPTY :: u32(0x00000004)
		PCRE2_NOTEMPTY_ATSTART :: u32(0x00000008)
		PCRE2_NOTEOL :: u32(0x00000002)
		PCRE2_NO_AUTO_CAPTURE :: u32(0x00002000)
		PCRE2_NO_AUTO_POSSESS :: u32(0x00004000)
		PCRE2_NO_DOTSTAR_ANCHOR :: u32(0x00008000)
		PCRE2_NO_JIT :: u32(0x00002000)
		PCRE2_NO_UTF_CHECK :: u32(0x40000000)
		PCRE2_PARTIAL_HARD :: u32(0x00000020)
		PCRE2_PARTIAL_SOFT :: u32(0x00000010)
		PCRE2_SUBSTITUTE_EXTENDED :: u32(0x00000200)
		PCRE2_SUBSTITUTE_GLOBAL :: u32(0x00000100)
		PCRE2_SUBSTITUTE_LITERAL :: u32(0x00008000)
		PCRE2_SUBSTITUTE_MATCHED :: u32(0x00010000)
		PCRE2_SUBSTITUTE_REPLACEMENT_ONLY :: u32(0x00020000)
		PCRE2_SUBSTITUTE_UNKNOWN_UNSET :: u32(0x00000800)
		PCRE2_SUBSTITUTE_UNSET_EMPTY :: u32(0x00000400)
		PCRE2_UCP :: u32(0x00020000)
		PCRE2_UNGREEDY :: u32(0x00040000)
		PCRE2_UTF :: u32(0x00080000)
		PROPERTY_FLAG_NONE :: PropertyFlags{}
		PTY_DEFAULT :: PtyFlags{}
		REGEX_FLAGS_DEFAULT :: 0x00080000 | 0x40000000 | 0x00100000
		SPAWN_NO_PARENT_ENVV :: 1 << 25
		SPAWN_NO_SYSTEMD_SCOPE :: 1 << 26
		SPAWN_REQUIRE_SYSTEMD_SCOPE :: 1 << 27
		TERMPROP_CONTAINER_NAME :: "vte.container.name"
		TERMPROP_CONTAINER_RUNTIME :: "vte.container.runtime"
		TERMPROP_CONTAINER_UID :: "vte.container.uid"
		TERMPROP_CURRENT_DIRECTORY_URI :: "vte.cwd"
		TERMPROP_CURRENT_FILE_URI :: "vte.cwf"
		TERMPROP_ICON_COLOR :: "vte.icon.color"
		TERMPROP_ICON_IMAGE :: "vte.icon.image"
		TERMPROP_NAME_PREFIX :: "vte.ext."
		TERMPROP_PROGRESS_HINT :: "vte.progress.hint"
		TERMPROP_PROGRESS_VALUE :: "vte.progress.value"
		TERMPROP_SHELL_POSTEXEC :: "vte.shell.postexec"
		TERMPROP_SHELL_PRECMD :: "vte.shell.precmd"
		TERMPROP_SHELL_PREEXEC :: "vte.shell.preexec"
		TERMPROP_XTERM_TITLE :: "xterm.title"
		TEST_FLAGS_ALL :: ~u64(0)
		TEST_FLAGS_NONE :: u64(0)
		UUID_FORMAT_ANY :: UuidFormat{.SIMPLE, .BRACED, .URN}

	procedures
		align_get_type :: proc() -> gobj.Type ---
		connect_bell :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_char_size_changed :: proc(terminal: ^Terminal, handler: Char_Size_Changed_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_child_exited :: proc(terminal: ^Terminal, handler: Child_Exited_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_commit :: proc(terminal: ^Terminal, handler: Commit_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_contents_changed :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_copy_clipboard :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_current_directory_uri_changed :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_current_file_uri_changed :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_cursor_moved :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_decrease_font_size :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_deiconify_window :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_encoding_changed :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_eof :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_hyperlink_hover_uri_changed :: proc(terminal: ^Terminal, handler: Hyperlink_Hover_Uri_Changed_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_icon_title_changed :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_iconify_window :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_increase_font_size :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_lower_window :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_maximize_window :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_move_window :: proc(terminal: ^Terminal, handler: Move_Window_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_paste_clipboard :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_raise_window :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_refresh_window :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_resize_window :: proc(terminal: ^Terminal, handler: Resize_Window_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_restore_window :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_selection_changed :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_setup_context_menu :: proc(terminal: ^Terminal, handler: Setup_Context_Menu_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_termprop_changed :: proc(terminal: ^Terminal, handler: Termprop_Changed_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_termprops_changed :: proc(terminal: ^Terminal, handler: Termprops_Changed_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		connect_window_title_changed :: proc(terminal: ^Terminal, handler: Notification_Proc, data: glib.pointer = nil) -> glib.ulong {...}
		cursor_blink_mode_get_type :: proc() -> gobj.Type ---
		cursor_shape_get_type :: proc() -> gobj.Type ---
		erase_binding_get_type :: proc() -> gobj.Type ---
		event_context_get_coordinates :: proc(context_p: ^EventContext, x: ^f64, y: ^f64) -> glib.boolean ---
		event_context_get_type :: proc() -> gobj.Type ---
		format_get_type :: proc() -> gobj.Type ---
		get_encoding_supported :: proc(encoding: cstring) -> glib.boolean ---
		get_encodings :: proc(include_aliases: glib.boolean) -> ^cstring ---
		get_feature_flags :: proc() -> FeatureFlags ---
		get_features :: proc() -> cstring ---
		get_major_version :: proc() -> glib.uint_ ---
		get_micro_version :: proc() -> glib.uint_ ---
		get_minor_version :: proc() -> glib.uint_ ---
		get_termprops :: proc(length: ^glib.size) -> ^cstring ---
		get_test_flags :: proc() -> glib.uint64 ---
		get_user_shell :: proc() -> cstring ---
		install_termprop :: proc(name: cstring, type: PropertyType, flags: PropertyFlags) -> i32 ---
		install_termprop_alias :: proc(name: cstring, target_name: cstring) -> i32 ---
		progress_hint_get_type :: proc() -> gobj.Type ---
		property_flags_get_type :: proc() -> gobj.Type ---
		property_id_get_type :: proc() -> gobj.Type ---
		property_type_get_type :: proc() -> gobj.Type ---
		pty_child_setup :: proc(pty: ^Pty) ---
		pty_close :: proc(pty: ^Pty) ---
		pty_error_get_type :: proc() -> gobj.Type ---
		pty_error_quark :: proc() -> glib.Quark ---
		pty_flags_get_type :: proc() -> gobj.Type ---
		pty_get_fd :: proc(pty: ^Pty) -> i32 ---
		pty_get_size :: proc(pty: ^Pty, rows: ^i32, columns: ^i32, error: ^^glib.Error) -> glib.boolean ---
		pty_get_type :: proc() -> gobj.Type ---
		pty_new_foreign_sync :: proc(fd: i32, cancellable: ^gio.Cancellable, error: ^^glib.Error) -> ^Pty ---
		pty_new_sync :: proc(flags: PtyFlags, cancellable: ^gio.Cancellable, error: ^^glib.Error) -> ^Pty ---
		pty_set_size :: proc(pty: ^Pty, rows: i32, columns: i32, error: ^^glib.Error) -> glib.boolean ---
		pty_set_utf8 :: proc(pty: ^Pty, utf8: glib.boolean, error: ^^glib.Error) -> glib.boolean ---
		pty_spawn_async :: proc(pty: ^Pty, working_directory: cstring, argv: ^cstring, envv: ^cstring, spawn_flags: glib.SpawnFlags, child_setup: glib.SpawnChildSetupFunc, child_setup_data: glib.pointer, child_setup_data_destroy: glib.DestroyNotify, timeout: i32, cancellable: ^gio.Cancellable, callback: gio.AsyncReadyCallback, user_data: glib.pointer) ---
		pty_spawn_finish :: proc(pty: ^Pty, result: ^gio.AsyncResult, child_pid: ^glib.Pid, error: ^^glib.Error) -> glib.boolean ---
		pty_spawn_with_fds_async :: proc(pty: ^Pty, working_directory: cstring, argv: ^cstring, envv: ^cstring, fds: [^]i32, n_fds: i32, map_fds: [^]i32, n_map_fds: i32, spawn_flags: glib.SpawnFlags, child_setup: glib.SpawnChildSetupFunc, child_setup_data: glib.pointer, child_setup_data_destroy: glib.DestroyNotify, timeout: i32, cancellable: ^gio.Cancellable, callback: gio.AsyncReadyCallback, user_data: glib.pointer) ---
		query_termprop :: proc(name: cstring, resolved_name: ^cstring, prop: ^i32, type: ^PropertyType, flags: ^PropertyFlags) -> glib.boolean ---
		query_termprop_by_id :: proc(prop: i32, name: ^cstring, type: ^PropertyType, flags: ^PropertyFlags) -> glib.boolean ---
		regex_error_get_type :: proc() -> gobj.Type ---
		regex_error_quark :: proc() -> glib.Quark ---
		regex_get_type :: proc() -> gobj.Type ---
		regex_jit :: proc(regex: ^Regex, flags: glib.uint32, error: ^^glib.Error) -> glib.boolean ---
		regex_new_for_match :: proc(pattern: cstring, pattern_length: glib.ssize, flags: glib.uint32, error: ^^glib.Error) -> ^Regex ---
		regex_new_for_match_full :: proc(pattern: cstring, pattern_length: glib.ssize, flags: u32, extra_flags: u32, error_offset: ^glib.size, error: ^^glib.Error) -> ^Regex ---
		regex_new_for_search :: proc(pattern: cstring, pattern_length: glib.ssize, flags: glib.uint32, error: ^^glib.Error) -> ^Regex ---
		regex_new_for_search_full :: proc(pattern: cstring, pattern_length: glib.ssize, flags: u32, extra_flags: u32, error_offset: ^glib.size, error: ^^glib.Error) -> ^Regex ---
		regex_ref :: proc(regex: ^Regex) -> ^Regex ---
		regex_substitute :: proc(regex: ^Regex, subject: cstring, replacement: cstring, flags: glib.uint32, error: ^^glib.Error) -> cstring ---
		regex_unref :: proc(regex: ^Regex) -> ^Regex ---
		set_test_flags :: proc(flags: glib.uint64) ---
		terminal_check_hyperlink_at :: proc(terminal: ^Terminal, x: f64, y: f64) -> cstring ---
		terminal_check_match_at :: proc(terminal: ^Terminal, x: f64, y: f64, tag: ^i32) -> cstring ---
		terminal_check_regex_array_at :: proc(terminal: ^Terminal, x: f64, y: f64, regexes: [^]^Regex, n_regexes: glib.size, match_flags: glib.uint32, n_matches: ^glib.size) -> ^cstring ---
		terminal_check_regex_simple_at :: proc(terminal: ^Terminal, x: f64, y: f64, regexes: [^]^Regex, n_regexes: glib.size, match_flags: glib.uint32, matches: [^]cstring) -> glib.boolean ---
		terminal_copy_clipboard :: proc(terminal: ^Terminal) ---
		terminal_copy_clipboard_format :: proc(terminal: ^Terminal, format: Format) ---
		terminal_copy_primary :: proc(terminal: ^Terminal) ---
		terminal_dup_termprop_string :: proc(terminal: ^Terminal, prop: cstring, size_p: ^uint) -> cstring ---
		terminal_dup_termprop_string_by_id :: proc(terminal: ^Terminal, prop: i32, size_p: ^uint) -> cstring ---
		terminal_dup_termprop_uuid :: proc(terminal: ^Terminal, prop: cstring) -> ^Uuid ---
		terminal_dup_termprop_uuid_by_id :: proc(terminal: ^Terminal, prop: i32) -> ^Uuid ---
		terminal_feed :: proc(terminal: ^Terminal, data: cstring, length: glib.ssize) ---
		terminal_feed_child :: proc(terminal: ^Terminal, text: cstring, length: glib.ssize) ---
		terminal_feed_child_binary :: proc(terminal: ^Terminal, data: ^glib.uint8, length: glib.size) ---
		terminal_get_allow_bold :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_allow_hyperlink :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_audible_bell :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_bold_is_bright :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_cell_height_scale :: proc(terminal: ^Terminal) -> f64 ---
		terminal_get_cell_width_scale :: proc(terminal: ^Terminal) -> f64 ---
		terminal_get_char_height :: proc(terminal: ^Terminal) -> glib.long ---
		terminal_get_char_width :: proc(terminal: ^Terminal) -> glib.long ---
		terminal_get_cjk_ambiguous_width :: proc(terminal: ^Terminal) -> i32 ---
		terminal_get_color_background_for_draw :: proc(terminal: ^Terminal, color: ^gtk4.RGBA) ---
		terminal_get_column_count :: proc(terminal: ^Terminal) -> glib.long ---
		terminal_get_context_menu :: proc(terminal: ^Terminal) -> ^gtk4.Widget ---
		terminal_get_context_menu_model :: proc(terminal: ^Terminal) -> ^gio.MenuModel ---
		terminal_get_current_directory_uri :: proc(terminal: ^Terminal) -> cstring ---
		terminal_get_current_file_uri :: proc(terminal: ^Terminal) -> cstring ---
		terminal_get_cursor_blink_mode :: proc(terminal: ^Terminal) -> CursorBlinkMode ---
		terminal_get_cursor_position :: proc(terminal: ^Terminal, column: ^glib.long, row: ^glib.long) ---
		terminal_get_cursor_shape :: proc(terminal: ^Terminal) -> CursorShape ---
		terminal_get_enable_a11y :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_enable_bidi :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_enable_fallback_scrolling :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_enable_legacy_osc777 :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_enable_shaping :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_enable_sixel :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_encoding :: proc(terminal: ^Terminal) -> cstring ---
		terminal_get_font :: proc(terminal: ^Terminal) -> ^pango.FontDescription ---
		terminal_get_font_options :: proc(terminal: ^Terminal) -> ^cairo.font_options_t ---
		terminal_get_font_scale :: proc(terminal: ^Terminal) -> glib.double ---
		terminal_get_has_selection :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_icon_title :: proc(terminal: ^Terminal) -> cstring ---
		terminal_get_input_enabled :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_mouse_autohide :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_pty :: proc(terminal: ^Terminal) -> ^Pty ---
		terminal_get_rewrap_on_resize :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_row_count :: proc(terminal: ^Terminal) -> glib.long ---
		terminal_get_scroll_on_insert :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_scroll_on_keystroke :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_scroll_on_output :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_scroll_unit_is_pixels :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_scrollback_lines :: proc(terminal: ^Terminal) -> glib.long ---
		terminal_get_termprop_bool :: proc(terminal: ^Terminal, prop: cstring, valuep: ^glib.boolean) -> glib.boolean ---
		terminal_get_termprop_bool_by_id :: proc(terminal: ^Terminal, prop: i32, valuep: ^glib.boolean) -> glib.boolean ---
		terminal_get_termprop_data :: proc(terminal: ^Terminal, prop: cstring, size_p: ^uint) -> ^u8 ---
		terminal_get_termprop_data_by_id :: proc(terminal: ^Terminal, prop: i32, size_p: ^uint) -> ^u8 ---
		terminal_get_termprop_double :: proc(terminal: ^Terminal, prop: cstring, valuep: ^f64) -> glib.boolean ---
		terminal_get_termprop_double_by_id :: proc(terminal: ^Terminal, prop: i32, valuep: ^f64) -> glib.boolean ---
		terminal_get_termprop_enum :: proc(terminal: ^Terminal, prop: cstring, gtype: gobj.Type, valuep: ^i64) -> glib.boolean ---
		terminal_get_termprop_enum_by_id :: proc(terminal: ^Terminal, prop: i32, gtype: gobj.Type, valuep: ^i64) -> glib.boolean ---
		terminal_get_termprop_flags :: proc(terminal: ^Terminal, prop: cstring, gtype: gobj.Type, ignore_unknown_flags: glib.boolean, valuep: ^u64) -> glib.boolean ---
		terminal_get_termprop_flags_by_id :: proc(terminal: ^Terminal, prop: i32, gtype: gobj.Type, ignore_unknown_flags: glib.boolean, valuep: ^u64) -> glib.boolean ---
		terminal_get_termprop_int :: proc(terminal: ^Terminal, prop: cstring, valuep: ^i64) -> glib.boolean ---
		terminal_get_termprop_int_by_id :: proc(terminal: ^Terminal, prop: i32, valuep: ^i64) -> glib.boolean ---
		terminal_get_termprop_rgba :: proc(terminal: ^Terminal, prop: cstring, color: ^gtk4.RGBA) -> glib.boolean ---
		terminal_get_termprop_rgba_by_id :: proc(terminal: ^Terminal, prop: i32, color: ^gtk4.RGBA) -> glib.boolean ---
		terminal_get_termprop_string :: proc(terminal: ^Terminal, prop: cstring, size_p: ^uint) -> cstring ---
		terminal_get_termprop_string_by_id :: proc(terminal: ^Terminal, prop: i32, size_p: ^uint) -> cstring ---
		terminal_get_termprop_uint :: proc(terminal: ^Terminal, prop: cstring, valuep: ^u64) -> glib.boolean ---
		terminal_get_termprop_uint_by_id :: proc(terminal: ^Terminal, prop: i32, valuep: ^u64) -> glib.boolean ---
		terminal_get_termprop_value :: proc(terminal: ^Terminal, prop: cstring, gvalue: ^gobj.Value) -> glib.boolean ---
		terminal_get_termprop_value_by_id :: proc(terminal: ^Terminal, prop: i32, gvalue: ^gobj.Value) -> glib.boolean ---
		terminal_get_text :: proc(terminal: ^Terminal, is_selected: SelectionFunc, user_data: glib.pointer, attributes: ^glib.Array) -> cstring ---
		terminal_get_text_blink_mode :: proc(terminal: ^Terminal) -> TextBlinkMode ---
		terminal_get_text_format :: proc(terminal: ^Terminal, format: Format) -> cstring ---
		terminal_get_text_include_trailing_spaces :: proc(terminal: ^Terminal, is_selected: SelectionFunc, user_data: glib.pointer, attributes: ^glib.Array) -> cstring ---
		terminal_get_text_range :: proc(terminal: ^Terminal, start_row: glib.long, start_col: glib.long, end_row: glib.long, end_col: glib.long, is_selected: SelectionFunc, user_data: glib.pointer, attributes: ^glib.Array) -> cstring ---
		terminal_get_text_range_format :: proc(terminal: ^Terminal, format: Format, start_row: i64, start_col: i64, end_row: i64, end_col: i64, length: ^glib.size) -> cstring ---
		terminal_get_text_selected :: proc(terminal: ^Terminal, format: Format) -> cstring ---
		terminal_get_text_selected_full :: proc(terminal: ^Terminal, format: Format, length: ^glib.size) -> cstring ---
		terminal_get_type :: proc() -> gobj.Type ---
		terminal_get_window_title :: proc(terminal: ^Terminal) -> cstring ---
		terminal_get_word_char_exceptions :: proc(terminal: ^Terminal) -> cstring ---
		terminal_get_xalign :: proc(terminal: ^Terminal) -> Align ---
		terminal_get_xfill :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_get_yalign :: proc(terminal: ^Terminal) -> Align ---
		terminal_get_yfill :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_match_add_regex :: proc(terminal: ^Terminal, regex: ^Regex, flags: glib.uint32) -> i32 ---
		terminal_match_check :: proc(terminal: ^Terminal, column: glib.long, row: glib.long, tag: ^i32) -> cstring ---
		terminal_match_remove :: proc(terminal: ^Terminal, tag: i32) ---
		terminal_match_remove_all :: proc(terminal: ^Terminal) ---
		terminal_match_set_cursor :: proc(terminal: ^Terminal, tag: i32, cursor: ^gtk4.Cursor) ---
		terminal_match_set_cursor_name :: proc(terminal: ^Terminal, tag: i32, cursor_name: cstring) ---
		terminal_new :: proc() -> ^gtk4.Widget ---
		terminal_paste_clipboard :: proc(terminal: ^Terminal) ---
		terminal_paste_primary :: proc(terminal: ^Terminal) ---
		terminal_paste_text :: proc(terminal: ^Terminal, text: cstring) ---
		terminal_pty_new_sync :: proc(terminal: ^Terminal, flags: PtyFlags, cancellable: ^gio.Cancellable, error: ^^glib.Error) -> ^Pty ---
		terminal_ref_termprop_data_bytes :: proc(terminal: ^Terminal, prop: cstring) -> ^glib.Bytes ---
		terminal_ref_termprop_data_bytes_by_id :: proc(terminal: ^Terminal, prop: i32) -> ^glib.Bytes ---
		terminal_ref_termprop_image_surface :: proc(terminal: ^Terminal, prop: cstring) -> ^cairo.surface_t ---
		terminal_ref_termprop_image_surface_by_id :: proc(terminal: ^Terminal, prop: i32) -> ^cairo.surface_t ---
		terminal_ref_termprop_image_texture :: proc(terminal: ^Terminal, prop: cstring) -> ^gtk4.Texture ---
		terminal_ref_termprop_image_texture_by_id :: proc(terminal: ^Terminal, prop: i32) -> ^gtk4.Texture ---
		terminal_ref_termprop_uri :: proc(terminal: ^Terminal, prop: cstring) -> ^glib.Uri ---
		terminal_ref_termprop_uri_by_id :: proc(terminal: ^Terminal, prop: i32) -> ^glib.Uri ---
		terminal_ref_termprop_variant :: proc(terminal: ^Terminal, prop: cstring) -> ^glib.Variant ---
		terminal_ref_termprop_variant_by_id :: proc(terminal: ^Terminal, prop: i32) -> ^glib.Variant ---
		terminal_reset :: proc(terminal: ^Terminal, clear_tabstops: glib.boolean, clear_history: glib.boolean) ---
		terminal_reset_termprop :: proc(terminal: ^Terminal, prop: cstring) ---
		terminal_reset_termprop_by_id :: proc(terminal: ^Terminal, prop: i32) ---
		terminal_search_find_next :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_search_find_previous :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_search_get_regex :: proc(terminal: ^Terminal) -> ^Regex ---
		terminal_search_get_wrap_around :: proc(terminal: ^Terminal) -> glib.boolean ---
		terminal_search_set_regex :: proc(terminal: ^Terminal, regex: ^Regex, flags: glib.uint32) ---
		terminal_search_set_wrap_around :: proc(terminal: ^Terminal, wrap_around: glib.boolean) ---
		terminal_select_all :: proc(terminal: ^Terminal) ---
		terminal_set_allow_bold :: proc(terminal: ^Terminal, allow_bold: glib.boolean) ---
		terminal_set_allow_hyperlink :: proc(terminal: ^Terminal, allow_hyperlink: glib.boolean) ---
		terminal_set_audible_bell :: proc(terminal: ^Terminal, is_audible: glib.boolean) ---
		terminal_set_backspace_binding :: proc(terminal: ^Terminal, binding: EraseBinding) ---
		terminal_set_bold_is_bright :: proc(terminal: ^Terminal, bold_is_bright: glib.boolean) ---
		terminal_set_cell_height_scale :: proc(terminal: ^Terminal, scale: f64) ---
		terminal_set_cell_width_scale :: proc(terminal: ^Terminal, scale: f64) ---
		terminal_set_cjk_ambiguous_width :: proc(terminal: ^Terminal, width: i32) ---
		terminal_set_clear_background :: proc(terminal: ^Terminal, setting: glib.boolean) ---
		terminal_set_color_background :: proc(terminal: ^Terminal, background: ^gtk4.RGBA) ---
		terminal_set_color_bold :: proc(terminal: ^Terminal, bold: ^gtk4.RGBA) ---
		terminal_set_color_cursor :: proc(terminal: ^Terminal, cursor_background: ^gtk4.RGBA) ---
		terminal_set_color_cursor_foreground :: proc(terminal: ^Terminal, cursor_foreground: ^gtk4.RGBA) ---
		terminal_set_color_foreground :: proc(terminal: ^Terminal, foreground: ^gtk4.RGBA) ---
		terminal_set_color_highlight :: proc(terminal: ^Terminal, highlight_background: ^gtk4.RGBA) ---
		terminal_set_color_highlight_foreground :: proc(terminal: ^Terminal, highlight_foreground: ^gtk4.RGBA) ---
		terminal_set_colors :: proc(terminal: ^Terminal, foreground: ^gtk4.RGBA, background: ^gtk4.RGBA, palette: ^gtk4.RGBA, palette_size: glib.size) ---
		terminal_set_context_menu :: proc(terminal: ^Terminal, menu: ^gtk4.Widget) ---
		terminal_set_context_menu_model :: proc(terminal: ^Terminal, model: ^gio.MenuModel) ---
		terminal_set_cursor_blink_mode :: proc(terminal: ^Terminal, mode: CursorBlinkMode) ---
		terminal_set_cursor_shape :: proc(terminal: ^Terminal, shape: CursorShape) ---
		terminal_set_default_colors :: proc(terminal: ^Terminal) ---
		terminal_set_delete_binding :: proc(terminal: ^Terminal, binding: EraseBinding) ---
		terminal_set_enable_a11y :: proc(terminal: ^Terminal, enable_a11y: glib.boolean) ---
		terminal_set_enable_bidi :: proc(terminal: ^Terminal, enable_bidi: glib.boolean) ---
		terminal_set_enable_fallback_scrolling :: proc(terminal: ^Terminal, enable: glib.boolean) ---
		terminal_set_enable_legacy_osc777 :: proc(terminal: ^Terminal, enable: glib.boolean) ---
		terminal_set_enable_shaping :: proc(terminal: ^Terminal, enable_shaping: glib.boolean) ---
		terminal_set_enable_sixel :: proc(terminal: ^Terminal, enabled: glib.boolean) ---
		terminal_set_encoding :: proc(terminal: ^Terminal, codeset: cstring, error: ^^glib.Error) -> glib.boolean ---
		terminal_set_font :: proc(terminal: ^Terminal, font_desc: ^pango.FontDescription) ---
		terminal_set_font_options :: proc(terminal: ^Terminal, font_options: ^cairo.font_options_t) ---
		terminal_set_font_scale :: proc(terminal: ^Terminal, scale: glib.double) ---
		terminal_set_input_enabled :: proc(terminal: ^Terminal, enabled: glib.boolean) ---
		terminal_set_mouse_autohide :: proc(terminal: ^Terminal, setting: glib.boolean) ---
		terminal_set_pty :: proc(terminal: ^Terminal, pty: ^Pty) ---
		terminal_set_rewrap_on_resize :: proc(terminal: ^Terminal, rewrap: glib.boolean) ---
		terminal_set_scroll_on_insert :: proc(terminal: ^Terminal, scroll: glib.boolean) ---
		terminal_set_scroll_on_keystroke :: proc(terminal: ^Terminal, scroll: glib.boolean) ---
		terminal_set_scroll_on_output :: proc(terminal: ^Terminal, scroll: glib.boolean) ---
		terminal_set_scroll_unit_is_pixels :: proc(terminal: ^Terminal, enable: glib.boolean) ---
		terminal_set_scrollback_lines :: proc(terminal: ^Terminal, lines: glib.long) ---
		terminal_set_size :: proc(terminal: ^Terminal, columns: glib.long, rows: glib.long) ---
		terminal_set_suppress_legacy_signals :: proc(terminal: ^Terminal) ---
		terminal_set_text_blink_mode :: proc(terminal: ^Terminal, text_blink_mode: TextBlinkMode) ---
		terminal_set_word_char_exceptions :: proc(terminal: ^Terminal, exceptions: cstring) ---
		terminal_set_xalign :: proc(terminal: ^Terminal, align: Align) ---
		terminal_set_xfill :: proc(terminal: ^Terminal, fill: glib.boolean) ---
		terminal_set_yalign :: proc(terminal: ^Terminal, align: Align) ---
		terminal_set_yfill :: proc(terminal: ^Terminal, fill: glib.boolean) ---
		terminal_spawn_async :: proc(terminal: ^Terminal, pty_flags: PtyFlags, working_directory: cstring, argv: ^cstring, envv: ^cstring, spawn_flags: glib.SpawnFlags, child_setup: glib.SpawnChildSetupFunc, child_setup_data: glib.pointer, child_setup_data_destroy: glib.DestroyNotify, timeout: i32, cancellable: ^gio.Cancellable, callback: TerminalSpawnAsyncCallback, user_data: glib.pointer) ---
		terminal_spawn_sync :: proc(terminal: ^Terminal, pty_flags: PtyFlags, working_directory: cstring, argv: ^cstring, envv: ^cstring, spawn_flags: glib.SpawnFlags, child_setup: glib.SpawnChildSetupFunc, child_setup_data: glib.pointer, child_pid: ^glib.Pid, cancellable: ^gio.Cancellable, error: ^^glib.Error) -> glib.boolean ---
		terminal_spawn_with_fds_async :: proc(terminal: ^Terminal, pty_flags: PtyFlags, working_directory: cstring, argv: ^cstring, envv: ^cstring, fds: [^]i32, n_fds: i32, map_fds: [^]i32, n_map_fds: i32, spawn_flags: glib.SpawnFlags, child_setup: glib.SpawnChildSetupFunc, child_setup_data: glib.pointer, child_setup_data_destroy: glib.DestroyNotify, timeout: i32, cancellable: ^gio.Cancellable, callback: TerminalSpawnAsyncCallback, user_data: glib.pointer) ---
		terminal_unselect_all :: proc(terminal: ^Terminal) ---
		terminal_watch_child :: proc(terminal: ^Terminal, child_pid: glib.Pid) ---
		terminal_write_contents_sync :: proc(terminal: ^Terminal, stream: ^gio.OutputStream, flags: WriteFlags, cancellable: ^gio.Cancellable, error: ^^glib.Error) -> glib.boolean ---
		text_blink_mode_get_type :: proc() -> gobj.Type ---
		uuid_dup :: proc(uuid: ^Uuid) -> ^Uuid ---
		uuid_equal :: proc(uuid: ^Uuid, other: ^Uuid) -> glib.boolean ---
		uuid_format_get_type :: proc() -> gobj.Type ---
		uuid_free :: proc(uuid: ^Uuid) ---
		uuid_free_to_string :: proc(uuid: ^Uuid, fmt: UuidFormat, len: ^glib.size) -> cstring ---
		uuid_get_type :: proc() -> gobj.Type ---
		uuid_new_from_string :: proc(str: cstring, len: glib.ssize, fmt: UuidFormat) -> ^Uuid ---
		uuid_new_v4 :: proc() -> ^Uuid ---
		uuid_new_v5 :: proc(ns: ^Uuid, data: cstring, len: glib.ssize) -> ^Uuid ---
		uuid_to_string :: proc(uuid: ^Uuid, fmt: UuidFormat, len: ^glib.size) -> cstring ---
		uuid_validate_string :: proc(str: cstring, len: glib.ssize, fmt: UuidFormat) -> glib.boolean ---
		write_flags_get_type :: proc() -> gobj.Type ---

	types
		Align :: enum u32 {START = 0, CENTER = 1, END = 2}
		CharAttributes :: struct {row, column: i64, fore, back: pango.Color, flags: bit_field u32 {underline: u32 | 1, strikethrough: u32 | 1, columns: u32 | 4}}
		Char_Size_Changed_Proc :: #type proc(terminal: ^Terminal, char_width, char_height: glib.uint_, user_data: glib.pointer)
			"char-size-changed": the cell size in pixels.

		Child_Exited_Proc :: #type proc(terminal: ^Terminal, status: i32, user_data: glib.pointer)
			"child-exited": status is the exit status of the child watched with watch_child.

		Commit_Proc :: #type proc(terminal: ^Terminal, text: [^]u8, size: glib.uint_, user_data: glib.pointer)
			"commit": everything the terminal wants to send to its child: encoded keystrokes, IME
			commits, mouse reports, query replies, pasted text. text is size bytes and not NUL
			terminated. Emitted even with no PTY attached (vte#222).

		CursorBlinkMode :: enum u32 {CURSOR_BLINK_SYSTEM = 0, CURSOR_BLINK_ON = 1, CURSOR_BLINK_OFF = 2}
		CursorShape :: enum u32 {BLOCK = 0, IBEAM = 1, UNDERLINE = 2}
		EraseBinding :: enum u32 {ERASE_AUTO = 0, ERASE_ASCII_BACKSPACE = 1, ERASE_ASCII_DELETE = 2, ERASE_DELETE_SEQUENCE = 3, ERASE_TTY = 4}
		EventContext :: struct #packed {}
		FeatureFlags :: bit_set[FeatureFlagsBit]
		FeatureFlagsBit :: enum u64 {BIDI = 0, ICU = 1, SYSTEMD = 2, SIXEL = 3}
		Format :: enum u32 {TEXT = 1, HTML = 2}
		Hyperlink_Hover_Uri_Changed_Proc :: #type proc(terminal: ^Terminal, uri: cstring, bbox: ^gtk4.Rectangle, user_data: glib.pointer)
			"hyperlink-hover-uri-changed": uri and bbox are nil when no hyperlink is hovered. Both are
			owned by VTE and may change after the handler returns.

		Move_Window_Proc :: #type proc(terminal: ^Terminal, x, y: glib.uint_, user_data: glib.pointer)
			"move-window": the position the application asked for.

		Notification_Proc :: #type proc(terminal: ^Terminal, user_data: glib.pointer)
			Handler of a signal that has no parameters: eof, bell, selection-changed, the *-window
			requests, the *-title and *-uri changes, ...

		ProgressHint :: enum u32 {INACTIVE = 0, ACTIVE = 1, ERROR = 2, INDETERMINATE = 3, PAUSED = 4}
		PropertyFlags :: bit_set[PropertyFlagsBit]
		PropertyFlagsBit :: enum u32 {EPHEMERAL = 0}
		PropertyId :: enum u32 {CURRENT_DIRECTORY_URI = 0, CURRENT_FILE_URI = 1, XTERM_TITLE = 2, CONTAINER_NAME = 3, CONTAINER_RUNTIME = 4, CONTAINER_UID = 5, SHELL_PRECMD = 6, SHELL_PREEXEC = 7, SHELL_POSTEXEC = 8, PROGRESS_HINT = 9, PROGRESS_VALUE = 10, ICON_COLOR = 11, ICON_IMAGE = 12}
		PropertyType :: enum i32 {PROPERTY_INVALID = -1, PROPERTY_VALUELESS = 0, PROPERTY_BOOL = 1, PROPERTY_INT = 2, PROPERTY_UINT = 3, PROPERTY_DOUBLE = 4, PROPERTY_RGB = 5, PROPERTY_RGBA = 6, PROPERTY_STRING = 7, PROPERTY_DATA = 8, PROPERTY_UUID = 9, PROPERTY_URI = 10, PROPERTY_IMAGE = 11}
		Pty :: struct #packed {}
		PtyClass :: struct #packed {}
		PtyError :: enum u32 {PTY_HELPER_FAILED = 0, PTY98_FAILED = 1}
		PtyFlags :: bit_set[PtyFlagsBit]
		PtyFlagsBit :: enum u32 {NO_LASTLOG = 0, NO_UTMP = 1, NO_WTMP = 2, NO_HELPER = 3, NO_FALLBACK = 4, NO_SESSION = 5, NO_CTTY = 6}
		Regex :: struct #packed {}
		RegexError :: enum u32 {INCOMPATIBLE = 2147483646, NOT_SUPPORTED = 2147483647}
		Resize_Window_Proc :: #type proc(terminal: ^Terminal, width, height: glib.uint_, user_data: glib.pointer)
			"resize-window": the size in pixels the application asked for.

		SelectionFunc :: #type proc(terminal: ^Terminal, column: glib.long, row: glib.long, data: glib.pointer) -> glib.boolean
		Setup_Context_Menu_Proc :: #type proc(terminal: ^Terminal, menu_context: ^EventContext, user_data: glib.pointer)
			"setup-context-menu": menu_context is non-nil before a context menu is shown and nil after it was
			dismissed; it is valid only during the emission.

		Terminal :: struct {widget: gtk4.Widget}
		TerminalClass :: struct {parent_class: gtk4.WidgetClass, eof: eof_func_ptr_anon_0, child_exited: child_exited_func_ptr_anon_1, encoding_changed: encoding_changed_func_ptr_anon_2, char_size_changed: char_size_changed_func_ptr_anon_3, window_title_changed: window_title_changed_func_ptr_anon_4, icon_title_changed: icon_title_changed_func_ptr_anon_5, selection_changed: selection_changed_func_ptr_anon_6, contents_changed: contents_changed_func_ptr_anon_7, cursor_moved: cursor_moved_func_ptr_anon_8, commit: commit_func_ptr_anon_9, deiconify_window: deiconify_window_func_ptr_anon_10, iconify_window: iconify_window_func_ptr_anon_11, raise_window: raise_window_func_ptr_anon_12, lower_window: lower_window_func_ptr_anon_13, refresh_window: refresh_window_func_ptr_anon_14, restore_window: restore_window_func_ptr_anon_15, maximize_window: maximize_window_func_ptr_anon_16, resize_window: resize_window_func_ptr_anon_17, move_window: move_window_func_ptr_anon_18, increase_font_size: increase_font_size_func_ptr_anon_19, decrease_font_size: decrease_font_size_func_ptr_anon_20, copy_clipboard: copy_clipboard_func_ptr_anon_21, paste_clipboard: paste_clipboard_func_ptr_anon_22, bell: bell_func_ptr_anon_23, setup_context_menu: setup_context_menu_func_ptr_anon_24, termprops_changed: termprops_changed_func_ptr_anon_25, termprop_changed: termprop_changed_func_ptr_anon_26, _padding: [13]glib.pointer, priv: ^TerminalClassPrivate}
		TerminalClassPrivate :: struct #packed {}
		TerminalSpawnAsyncCallback :: #type proc(terminal: ^Terminal, pid: glib.Pid, error: ^glib.Error, user_data: glib.pointer)
		Termprop_Changed_Proc :: #type proc(terminal: ^Terminal, name: cstring, user_data: glib.pointer)
			"termprop-changed" (0.78): fired with the property name on change or reset. The handler may
			only call vte_terminal_get_termprop_* on the terminal.

		Termprops_Changed_Proc :: #type proc(terminal: ^Terminal, props: [^]i32, n_props: i32, user_data: glib.pointer) -> glib.boolean
			"termprops-changed" (0.78): props lists the n_props ids of the properties that changed.
			Returning true from a handler that runs before the default one suppresses the per-property
			"termprop-changed" emissions.

		TextBlinkMode :: enum u32 {TEXT_BLINK_NEVER = 0, TEXT_BLINK_FOCUSED = 1, TEXT_BLINK_UNFOCUSED = 2, TEXT_BLINK_ALWAYS = 3}
		Uuid :: struct #packed {}
		UuidFormat :: bit_set[UuidFormatBit]
		UuidFormatBit :: enum u32 {SIMPLE = 0, BRACED = 1, URN = 2}
		WriteFlags :: enum u32 {WRITE_DEFAULT = 0}
		bell_func_ptr_anon_23 :: #type proc(terminal: ^Terminal)
		char_size_changed_func_ptr_anon_3 :: #type proc(terminal: ^Terminal, char_width: glib.uint_, char_height: glib.uint_)
		child_exited_func_ptr_anon_1 :: #type proc(terminal: ^Terminal, status: i32)
		commit_func_ptr_anon_9 :: #type proc(terminal: ^Terminal, text: cstring, size_p: glib.uint_)
		contents_changed_func_ptr_anon_7 :: #type proc(terminal: ^Terminal)
		copy_clipboard_func_ptr_anon_21 :: #type proc(terminal: ^Terminal)
		cursor_moved_func_ptr_anon_8 :: #type proc(terminal: ^Terminal)
		decrease_font_size_func_ptr_anon_20 :: #type proc(terminal: ^Terminal)
		deiconify_window_func_ptr_anon_10 :: #type proc(terminal: ^Terminal)
		encoding_changed_func_ptr_anon_2 :: #type proc(terminal: ^Terminal)
		eof_func_ptr_anon_0 :: #type proc(terminal: ^Terminal)
		icon_title_changed_func_ptr_anon_5 :: #type proc(terminal: ^Terminal)
		iconify_window_func_ptr_anon_11 :: #type proc(terminal: ^Terminal)
		increase_font_size_func_ptr_anon_19 :: #type proc(terminal: ^Terminal)
		lower_window_func_ptr_anon_13 :: #type proc(terminal: ^Terminal)
		maximize_window_func_ptr_anon_16 :: #type proc(terminal: ^Terminal)
		move_window_func_ptr_anon_18 :: #type proc(terminal: ^Terminal, x: glib.uint_, y: glib.uint_)
		paste_clipboard_func_ptr_anon_22 :: #type proc(terminal: ^Terminal)
		raise_window_func_ptr_anon_12 :: #type proc(terminal: ^Terminal)
		refresh_window_func_ptr_anon_14 :: #type proc(terminal: ^Terminal)
		resize_window_func_ptr_anon_17 :: #type proc(terminal: ^Terminal, width: glib.uint_, height: glib.uint_)
		restore_window_func_ptr_anon_15 :: #type proc(terminal: ^Terminal)
		selection_changed_func_ptr_anon_6 :: #type proc(terminal: ^Terminal)
		setup_context_menu_func_ptr_anon_24 :: #type proc(terminal: ^Terminal, context_p: ^EventContext)
		termprop_changed_func_ptr_anon_26 :: #type proc(terminal: ^Terminal, prop: cstring)
		termprops_changed_func_ptr_anon_25 :: #type proc(terminal: ^Terminal, props: [^]i32, n_props: i32) -> glib.boolean
		window_title_changed_func_ptr_anon_4 :: #type proc(terminal: ^Terminal)

	files:
		helpers.odin
		patched.odin
		vte.odin
```
