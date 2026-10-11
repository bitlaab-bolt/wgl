# Change Log

All notable changes to this project will be documented in this file.
This project adheres to the [Semantic Version](https://semver.org/) guideline.

## [v1.0.0] - 2026-10-11

Initial stable release. Cross-platform (Windows x64, macOS Apple Silicon) window creation and management built on GLFW 3.

### Added
- `Wgl.destroy` is now safe to call multiple times; the window instance is cleared after destruction
- `errorCallback` now returns the previously set callback so it can be restored or chained
- `glfw.getPrimaryMonitor` binding for fullscreen window creation

### Changed
- `WindowOptions.title` is now `[:0]const u8` (sentinel-terminated slice) — string literals work as-is, but code that previously built a `[]const u8` title must now guarantee a `0` sentinel
- `WindowLimits.min_width` and `min_height` now default to `-1` (GLFW_DONT_CARE), consistent with the max fields
- Per-frame wrappers (`pullEvents`, `swapBuffers`, `shouldClose`, `swapInterval`) and their binding counterparts are now `inline fn` for zero call overhead in Debug builds
- Platform-specific native window accessors (`macOS`, `windows`) are compile-time gated by target OS

### Fixed
- `createWindow` now returns `error.WindowCreationFailed` instead of silently returning a null window instance on failure
- Window title passed to GLFW as a NUL-terminated C string, preventing an out-of-bounds read when a non-terminated slice was supplied
- Use-after-free / double-destroy when calling window functions after `destroy`

## [v0.5.0] - 2025-04-15

Provides bare minimum window creation and management capabilities for Windows (x64) and MacOS (Apple Silicon).
