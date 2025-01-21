# How to use

First import Wgl on your zig file.

```zig
const wgl = @import("wgl").Wgl;
```

## Window Creation

### Creates a Windows Context

```zig
try wgl.init();
defer wgl.deinit();

wgl.swapInterval(10);
wgl.errorCallback(printErrorInfo);

var win = try wgl.createWindow(.{.width = 980, .height = 560});
defer win.destroy();

win.makeContextCurrent();
win.setSizeLimits(.{.min_width = 720, .min_height = 360});

while (!win.shouldClose()) {
    // Game loop code here...

    win.swapBuffers();
    wgl.pullEvents();
}
```

### Error Info Callback

```zig
fn printErrorInfo(code: c_int, message: [*c]const u8) callconv(.c) void {
    std.debug.print("Error code: {d}\n", .{code});
    std.debug.print("Error Message: {s}\n", .{message});
}
```
