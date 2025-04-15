# How to use

First, import Wgl into your Zig source file.

```zig
const wgl = @import("wgl");
const Wgl = wgl.Wgl;
```

## Window Creation

### Creates a Windows Context

```zig
try Wgl.init();
defer Wgl.deinit();

Wgl.swapInterval(10);
Wgl.errorCallback(printErrorInfo);

var win = try Wgl.createWindow(.{.width = 980, .height = 560});
defer win.destroy();

win.makeContextCurrent();
win.setSizeLimits(.{.min_width = 720, .min_height = 360});

while (!win.shouldClose()) {
    // Game loop code here...

    win.swapBuffers();
    Wgl.pullEvents();
}
```

### Error Info Callback

```zig
fn printErrorInfo(code: c_int, message: [*c]const u8) callconv(.c) void {
    std.debug.print("Error code: {d}\n", .{code});
    std.debug.print("Error Message: {s}\n", .{message});
}
```
