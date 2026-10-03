#+test
package vte

import "core:os"
import "core:strings"
import "core:sync"
import "core:testing"

import glib "glib:glib"

// Version recorded in README.md: "**Bound version:** X.Y.Z".
README :: #load("../README.md", string)

// The distro libvte the suite still builds against (Mint 22: 0.76.0).
FLOOR_MINOR :: 76

// `make test` sets VTE_BUNDLE when amber-vte's build is staged: the library is then linked from
// it and the termprop API (0.78+) can be called.
VTE_BUNDLE :: #config(VTE_BUNDLE, false)

bound_version :: proc() -> (major, minor, micro: int, ok: bool) {
    marker :: "**Bound version:** "
    readme := README
    i := strings.index(readme, marker)
    if i < 0 do return
    rest := readme[i + len(marker):]
    end := strings.index_any(rest, " \n")
    if end < 0 do return
    parts := strings.split(rest[:end], ".", context.temp_allocator)
    if len(parts) != 3 do return
    nums: [3]int
    for p, n in parts {
        v := 0
        if len(p) == 0 do return
        for c in p {
            if c < '0' || c > '9' do return
            v = v * 10 + int(c - '0')
        }
        nums[n] = v
    }
    return nums[0], nums[1], nums[2], true
}

@(test)
test_readme_version_matches_header_macros :: proc(t: ^testing.T) {
    major, minor, micro, ok := bound_version()
    testing.expect(t, ok, "README.md has no '**Bound version:** X.Y.Z'")
    testing.expect_value(t, major, MAJOR_VERSION)
    testing.expect_value(t, minor, MINOR_VERSION)
    testing.expect_value(t, micro, MICRO_VERSION)
}

@(test)
test_loaded_library_version :: proc(t: ^testing.T) {
    major, minor, micro, _ := bound_version()
    loaded_major := int(get_major_version())
    loaded_minor := int(get_minor_version())
    loaded_micro := int(get_micro_version())
    testing.expect_value(t, loaded_major, major)
    testing.expect(t, loaded_minor >= FLOOR_MINOR, "loaded libvte is older than the 0.76 floor")
    // With the bundle built, the loaded library must be the bound version exactly, and a
    // wrong path fails here instead of falling back to the distro's.
    if os.get_env("VTE_BUNDLE_EXPECTED", context.temp_allocator) != "" {
        testing.expect_value(t, loaded_minor, minor)
        testing.expect_value(t, loaded_micro, micro)
    }
}

@(test)
test_user_shell :: proc(t: ^testing.T) {
    shell := get_user_shell()
    testing.expect(t, shell != nil && len(string(shell)) > 0, "vte_get_user_shell returned nothing")
    glib.free(rawptr(shell))
}

@(test)
test_uuid_round_trip :: proc(t: ^testing.T) {
    u := uuid_new_v4()
    testing.expect(t, u != nil)
    defer uuid_free(u)
    s := uuid_to_string(u, {.SIMPLE}, nil)
    defer glib.free(rawptr(s))
    testing.expect_value(t, len(string(s)), 36) // SIMPLE is the dashed 8-4-4-4-12 form
    back := uuid_new_from_string(s, -1, UUID_FORMAT_ANY)
    testing.expect(t, back != nil, "a printed UUID did not parse")
    defer uuid_free(back)
    testing.expect(t, bool(uuid_equal(u, back)))
}

@(test)
test_types_register_without_a_display :: proc(t: ^testing.T) {
    sync.guard(&type_lock)
    testing.expect(t, terminal_get_type() != 0)
    testing.expect(t, pty_get_type() != terminal_get_type())
    testing.expect(t, TYPE_TERMINAL() == terminal_get_type())
}

when VTE_BUNDLE {
    @(test)
    test_termprops_are_listed :: proc(t: ^testing.T) {
        n: glib.size
        props := get_termprops(&n)
        testing.expect(t, props != nil && n > 0, "vte_get_termprops lists nothing")
        id: i32
        type: PropertyType
        flags: PropertyFlags
        ok := query_termprop(TERMPROP_XTERM_TITLE, nil, &id, &type, &flags)
        testing.expect(t, bool(ok), "xterm.title is not a termprop")
        testing.expect_value(t, type, PropertyType.PROPERTY_STRING)
        testing.expect_value(t, PropertyId(id), PropertyId.XTERM_TITLE)
    }
}
