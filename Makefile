# odin-vte: Odin bindings for VTE. Consumed via -collection:vte=/path/to/odin-vte
# What every runic binding does is in house/binding.mk, a copy of house-rules'
# scripts/binding/binding.mk: this repository is public, and its runner has no house-rules.
# project.toml names the kind, the packages, the siblings and the system packages.
include house/binding.mk

# The VTE the binding is generated from and tested against is the suite's, amber-vte (libvte
# 0.84.1, from amber-vte-dev), in its own folder off the linker's path, with amber-gtk4 for GTK:
# a test links both from there and runs them through the run path, as every program built on the
# binding does. The distro's 0.76.0 is the floor a program may load; the tests load the bundle,
# so the version test is exact (VTE_BUNDLE_EXPECTED) and the 0.78+ calls run (VTE_BUNDLE).
# generate reads the bundles' headers (VTE_INCLUDE, GTK_INCLUDE).
VTE_LIB = /usr/lib/amber-vte
GTK_LIB = /usr/lib/amber-gtk4
ODIN_TEST_FLAGS += -define:VTE_BUNDLE=true -extra-linker-flags:"-L$(VTE_LIB) -L$(GTK_LIB) -Wl,-rpath,$(VTE_LIB):$(GTK_LIB)"
test: export VTE_BUNDLE_EXPECTED = 1
generate: export VTE_INCLUDE = $(VTE_LIB)/include
generate: export GTK_INCLUDE = $(GTK_LIB)/include
