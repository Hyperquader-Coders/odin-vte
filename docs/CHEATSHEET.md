# odin-vte cheat sheet

One screen per job: the calls a program makes, in the order it makes them, and the few rules
worth remembering. Every `vte.` name here is a public declaration in [API.md](API.md), and
`make lint` fails when one is not. VTE's own documentation is the reference; this is the idiom
layer over the generated names.

Conventions that hold everywhere: `import "vte:vte"` with `glib:glib`, `glib:gobject` and
`gtk4:gtk4` ([Use](../README.md#use)); a procedure is the C name without `vte_`, a type the C
name without `Vte`; a `boolean` result or parameter is `glib.boolean`, so `bool(x)` and
`glib.boolean(b)` convert; flag sets are `bit_set`s (`vte.PtyFlags`, written `{}` for the
default, [PATCHED.md](PATCHED.md#generation-rules)). A callback is a `proc "c"`: its first line
is `context = app_ctx`, the `runtime.Context` saved at startup. The `vte` package has no
`TERMINAL(w)` cast; use `gobject.type_cast`.

## vte:Terminal — the widget

```odin
import "glib:glib"
import "glib:gobject"
import "gtk4:gtk4"
import "vte:vte"

widget := vte.terminal_new()                         // ^gtk4.Widget, floating until a parent takes it
term := gobject.type_cast(vte.Terminal, widget, vte.terminal_get_type)

vte.terminal_set_scrollback_lines(term, 10000)
vte.terminal_set_scroll_on_output(term, false)
vte.terminal_set_cursor_shape(term, .IBEAM)                  // .BLOCK .IBEAM .UNDERLINE
vte.terminal_set_cursor_blink_mode(term, .CURSOR_BLINK_OFF)
vte.terminal_set_font(term, font)                            // ^pango.FontDescription; free yours after
vte.terminal_set_colors(term, &fg, &bg, &palette[0], 16)     // ^gtk4.RGBA; palette 0, 8, 16, 232 or 256 entries, or nil, 0
vte.terminal_set_font_scale(term, 1.2)

handler := vte.connect_window_title_changed(term, on_title, nil)   // typed helpers over gobject.signal_connect
vte.connect_child_exited(term, on_exited, nil)
vte.connect_selection_changed(term, on_selection, nil)
gobject.signal_handler_disconnect(term, handler)

on_title :: proc "c" (term: ^vte.Terminal, data: glib.pointer) {
	context = app_ctx
	title := vte.terminal_get_window_title(term)     // borrowed; copy it
}

on_exited :: proc "c" (term: ^vte.Terminal, status: i32, data: glib.pointer) {
	context = app_ctx
	signal, code := status & 0x7f, (status >> 8) & 0xff      // a raw wait(2) status
}

on_selection :: proc "c" (term: ^vte.Terminal, data: glib.pointer) {
	context = app_ctx
}
```

| remember | |
|---|---|
| Use the `connect_<signal>` helpers, not `gobject.signal_connect`, for the terminal's signals | the callback types are checked against the C signature ([SPEC](SPEC.md#hand-written-vtehelpersodin)); `Notification_Proc`, `Child_Exited_Proc` and `Commit_Proc` are the ones you name |
| The handler's last parameter is `glib.pointer`, the one you passed | `rawptr(p)` in, `(^Pane)(data)` out |
| `vte.terminal_set_colors` takes a palette of 0, 8, 16, 232 or 256 entries | any other size is refused; `nil, 0` keeps the default palette |
| `vte.get_major_version()` is the library loaded, `vte.MAJOR_VERSION` the header's | the binding is 0.84.1; the distro's 0.76.0 is the floor ([DECISIONS §3](DECISIONS.md#3-the-version-test-and-the-loaded-library)) |

## vte:spawn — run a child in the terminal

```odin
import "glib:glib"
import "vte:vte"

argv := [?]cstring{"/bin/bash", "-l", nil}            // nil-terminated; &argv[0] is the ^cstring
env := glib.get_environ()                             // ^cstring, nil-terminated; free it
defer glib.strfreev(env)
env = glib.environ_setenv(env, "TERM", "xterm-256color", true)

vte.terminal_spawn_async(term, {}, cwd, &argv[0], env, {.SPAWN_SEARCH_PATH}, nil, nil, nil, -1, nil, on_spawned, nil)
// pty flags {} = vte.PTY_DEFAULT; cwd nil = inherit; env nil = inherit; timeout -1; cancellable nil

on_spawned :: proc "c" (term: ^vte.Terminal, pid: glib.Pid, err: ^glib.Error, data: glib.pointer) {
	context = app_ctx
	if term == nil { return }                       // the terminal went before the child started
	if err != nil { _ = string(err.message); return }   // borrowed: VTE frees it after the call
}

vte.terminal_feed(term, cstring(raw_data(output)), glib.ssize(len(output)))     // to the screen, as if the child printed it
vte.terminal_feed_child(term, cstring(raw_data(typed)), glib.ssize(len(typed))) // to the child, as if typed

pty := vte.pty_new_sync({.NO_HELPER}, nil, &gerr)    // a pty with no terminal: you own it (gobject.object_unref)
glib.spawn_async(nil, &argv[0], env, {.SPAWN_SEARCH_PATH, .SPAWN_DO_NOT_REAP_CHILD},
	glib.SpawnChildSetupFunc(vte.pty_child_setup), glib.pointer(pty), &pid, &gerr)
fd := vte.pty_get_fd(pty)                            // the master side, for a program that speaks to the child itself
vte.terminal_set_pty(term, pty)                      // or attach it, then vte.terminal_watch_child(term, pid)
```

| remember | |
|---|---|
| `terminal_spawn_async` is fire-and-forget, so `data` may be freed before `on_spawned` runs | a nil `term` says the terminal is gone; return before touching `data` |
| Wait for the callback before feeding a queued command to the child | text fed earlier can be lost or echoed twice |
| `terminal_feed` and `terminal_feed_child` take a length | the string needs no terminator; `-1` means NUL-terminated |
| `child-exited` carries the raw wait status | the low 7 bits are the signal, bits 8-15 the exit code |

## vte:text — selection, search and links

```odin
import "glib:glib"
import "vte:vte"

if vte.terminal_get_has_selection(term) {
	sel := vte.terminal_get_text_selected(term, .TEXT)    // .TEXT or .HTML; the caller frees it
	defer glib.free(glib.pointer(rawptr(sel)))
}
vte.terminal_paste_clipboard(term)
vte.terminal_copy_clipboard_format(term, .HTML)

err: ^glib.Error
re := vte.regex_new_for_search("error:", -1, vte.PCRE2_MULTILINE | vte.PCRE2_CASELESS, &err)
if re != nil {
	vte.terminal_search_set_regex(term, re, 0)             // the terminal takes its own ref
	vte.regex_unref(re)
	vte.terminal_search_set_wrap_around(term, true)
	found := vte.terminal_search_find_next(term)           // .._find_previous; nil regex clears
}

link := vte.regex_new_for_match(`https?://\S+`, -1, vte.PCRE2_MULTILINE, &err)
tag := vte.terminal_match_add_regex(term, link, 0)         // a tag: negative on failure
vte.regex_unref(link)
vte.terminal_match_set_cursor_name(term, tag, "pointer")

col, row: i64
vte.terminal_get_cursor_position(term, &col, &row)
hit := vte.terminal_match_check(term, col, row, &tag)      // a cell, not a pixel; the caller frees it
w, h := vte.terminal_get_char_width(term), vte.terminal_get_char_height(term)   // pixels per cell
```

| remember | |
|---|---|
| Every PCRE2 flag is a `u32` constant joined with `\|`, and search and match need `vte.PCRE2_MULTILINE` | there is no bit_set here ([DECISIONS §6](DECISIONS.md#6-signal-helpers-and-pcre2-flags-are-hand-written)) |
| `terminal_get_text_selected`, `terminal_match_check` and `get_user_shell` return memory you free with `glib.free` | the `terminal_get_window_title` and `terminal_get_termprop_string` results are borrowed |
| Hit-testing takes a cell, so divide the pixel by `terminal_get_char_width` and `_height` | and subtract the widget's CSS padding first |
| `regex_new_for_*` returns nil with `err` set for a bad pattern | free the error; the pattern is the user's |

## vte:termprops — what the shell tells the terminal

```odin
import "glib:glib"
import "vte:vte"

// Before the first terminal exists: a name of the form "vte.ext.app.name", a type, and flags.
vte.install_termprop("vte.ext.myapp.notify", .PROPERTY_STRING, {.EPHEMERAL})   // fires every time, even for the same value
vte.install_termprop("vte.ext.myapp.version", .PROPERTY_INT, {})               // latched: the last value stays readable

handler := vte.connect_termprop_changed(term, on_termprop, nil)

on_termprop :: proc "c" (term: ^vte.Terminal, name: cstring, data: glib.pointer) {
	context = app_ctx
	// Read here, act later: the handler may only call the terminal_get_termprop_* procedures.
	switch string(name) {
	case "vte.progress.hint":
		hint: i64
		if !bool(vte.terminal_get_termprop_int(term, "vte.progress.hint", &hint)) { hint = i64(vte.ProgressHint.INACTIVE) }
	case "vte.ext.myapp.notify":
		text := vte.terminal_get_termprop_string(term, name, nil)   // borrowed; nil when unset
	}
}

n: u64
ok := vte.terminal_get_termprop_uint(term, "vte.progress.value", &n)
uri := vte.terminal_get_current_directory_uri(term)                // OSC 7; borrowed
```

| remember | |
|---|---|
| `install_termprop` runs before the first terminal is created | a terminal made earlier does not know the property |
| The built-in names are `vte.container.name`, `vte.progress.hint`, `vte.progress.value`, `vte.shell.precmd` and the rest of VTE's list | yours go under the `ext` namespace, as `vte.ext.myapp.name` |
| Termprops need VTE 0.78 or newer | on the distro's 0.76 a program that calls them does not link ([DECISIONS §3](DECISIONS.md#3-the-version-test-and-the-loaded-library)) |
| An ephemeral property is readable only inside the `termprop-changed` emission | copy the value there |
