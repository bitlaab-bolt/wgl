const std = @import("std");
const builtin = @import("builtin");

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

    var win = try Wgl.createWindow(.{
        .title = "wgl demo",
        .width = 980,
        .height = 560,
    });
    defer win.destroy();

    win.makeContextCurrent();
    Wgl.swapInterval(1);

    win.setSizeLimits(.{
        .min_width = 720,
        .min_height = 360,
        .max_width = 1920,
        .max_height = 1080,
    });
    win.maximizeWindow();

    // Grab the native window handle on the current platform
    switch (builtin.os.tag) {
        .macos => {
            const ns_window = Wgl.macOS.getNativeWindow(win.instance);
            _ = ns_window;
        },
        .windows => {
            const hwnd = Wgl.windows.getNativeWindow(win.instance);
            _ = hwnd;
        },
        else => {},
    }

    while (!win.shouldClose()) {
        // Game loop code here...

        win.swapBuffers();
        Wgl.pullEvents();
    }
}
