# How to use

First, import Wgl into your Zig source file.

```zig
const wgl = @import("wgl");
const Wgl = wgl.Wgl;
```

## Full Example

```zig
const std = @import("std");
const wgl = @import("wgl");
const Wgl = wgl.Wgl;

fn printErrorInfo(code: c_int, message: [*c]const u8) callconv(.c) void {
    std.debug.print("[GLFW {d}] {s}\n", .{ code, message });
}

pub fn main() !void {
    // Set the error callback before init() to catch initialization errors
    _ = Wgl.errorCallback(printErrorInfo);

    try Wgl.init();
    defer Wgl.deinit();

    // `title` is a sentinel-terminated string (`[:0]const u8`)
    // Fails with `error.WindowCreationFailed` if the window cannot be created
    var win = try Wgl.createWindow(.{
        .title = "wgl demo",
        .width = 980,
        .height = 560,
    });
    defer win.destroy();

    win.makeContextCurrent();
    Wgl.swapInterval(1); // 1 = vsync on, 0 = off

    win.setSizeLimits(.{
        .min_width = 720,
        .min_height = 360,
        .max_width = 1920,
        .max_height = 1080,
    });
    win.maximizeWindow();

    while (!win.shouldClose()) {
        // Game loop code here...

        win.swapBuffers();
        Wgl.pullEvents();
    }
}
```

## Window Creation

### Creates a Window Instance

```zig
try Wgl.init();
defer Wgl.deinit();

var win = try Wgl.createWindow(.{
    .title = "Hello",
    .width = 980,
    .height = 560,
});
defer win.destroy();
```

- `createWindow` returns `error.WindowCreationFailed` if window creation fails, so a
  `try` (or explicit `catch`) is all the error handling you need.
- `title` must be `[:0]const u8` (sentinel-terminated). String literals like `"Hello"`
  already satisfy this.
- Optional fields: `monitor` for fullscreen mode and `share` to share an OpenGL context
  with another window (both default to `null`).

### Error Info Callback

Set the error callback **before** calling `init()` so initialization errors are
reported too. It returns the previously set callback, so you can restore or chain
callbacks:

```zig
const previous = Wgl.errorCallback(printErrorInfo);
// ... later, restore the previous callback if needed:
_ = Wgl.errorCallback(previous);

fn printErrorInfo(code: c_int, message: [*c]const u8) callconv(.c) void {
    std.debug.print("Error code: {d}\n", .{code});
    std.debug.print("Error Message: {s}\n", .{message});
}
```

### Content Area Limits

Sets the minimum and / or maximum size limits of the window's content area.
Use `-1` to disable any limit — every field defaults to `-1`, so you only need
to set the ones you care about.

```zig
win.setSizeLimits(.{.min_width = 720, .min_height = 360});
```

### Window State

```zig
win.maximizeWindow(); // Maximizes the window

while (!win.shouldClose()) {
    // Game loop code here...

    win.swapBuffers(); // Swap front and back buffers
    Wgl.pullEvents();  // Process all pending events
}

win.destroy(); // Safe to call multiple times; the instance is cleared after destroy
```

`makeContextCurrent` and `Wgl.swapInterval` are usually called once after creating
the window, not every frame:

```zig
win.makeContextCurrent(); // Make window context current on the calling thread
Wgl.swapInterval(1);      // Set swap interval (vsync) for the current context
```

## Platform Specific Functionality

Get the native window handle for interop with platform APIs. Each accessor is
compile-time gated: on any other target the namespace is empty.

```zig
// macOS - NSWindow of the specified window
const ns_window = Wgl.macOS.getNativeWindow(win.instance);

// Windows - HWND of the specified window
const hwnd = Wgl.windows.getNativeWindow(win.instance);
```
