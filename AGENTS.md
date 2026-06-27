# AGENTS.md

## Build

```
make patch   # apply patch.diff to submodules (only needed once after a fresh clone)
make build   # rm -rf build/, configure with cmake, then make -j8
```

The `build` target does an out-of-source build into `build/`. Our bootstrap lives in `GNUmakefile` (which `make` prefers over `Makefile`), so an accidental in-source `cmake .` that writes a `Makefile` does **not** clobber our targets — but it still scatters CMake artifacts across the tree (including into submodules), so avoid it.

CMake flags used by `make build`:
- `-DCMAKE_POLICY_VERSION_MINIMUM=3.5` — required because vendored CMakeLists files declare `cmake_minimum_required` below CMake 3.5, which modern CMake refuses.
- `-DCMAKE_C_FLAGS=-DHAVE_UNISTD_H` — forces `<unistd.h>` to be included in `dependencies/OpenCOLLADA/.../LibXML/xmlIO.c`. Without it the LibXML build fails because the autotools-style `HAVE_UNISTD_H` define is never set.

## Patches

`patch.diff` (applied by `make patch`) adds missing standard-library includes that newer libstdc++ no longer transitively provides:
- `GLTF/dependencies/draco/src/draco/core/hash_utils.h` — `#include <cstddef>` (for `size_t`).
- `GLTF/dependencies/draco/src/draco/io/parser_utils.cc` — `#include <limits>` (for `std::numeric_limits`).

If you re-init the draco submodule, re-run `make patch`.

## Output

`build/COLLADA2GLTF-bin` is the converter executable.

## Cleaning

If the tree has been polluted by an in-source CMake run, clean with:

```
git clean -fdx -e .claude -e build
( cd GLTF/dependencies/draco && git clean -fdx )
( cd dependencies/ahoy && git clean -fdx )
```

Submodules have their own `.git` so a top-level `git clean` will not reach inside them.
