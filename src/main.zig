const std = @import("std");
const builtin = @import("builtin");

const wgl = @import("./core/wgl.zig");


pub fn main() !void {
    // var gpa_mem = std.heap.GeneralPurposeAllocator(.{}){};
    // defer std.debug.assert(gpa_mem.deinit() == .ok);
    // const heap = gpa_mem.allocator();

    try wgl.init();
    defer wgl.deinit();

    wgl.swapInterval(10);
    wgl.errorCallback(printErrorInfo);

    var win = try wgl.createWindow(.{.width = 980, .height = 560});
    defer win.destroy();

    win.makeContextCurrent();
    win.setSizeLimits(.{.min_width = 720, .min_height = 360});

    // Native window handler
    const native_win: *anyopaque = switch (builtin.os.tag) {
        .windows => @ptrCast(wgl.windows.getNativeWindow(win.instance)),
        .macos => @ptrCast(wgl.macOS.getNativeWindow(win.instance)),
        else => unreachable
    };
    _ = native_win;


    while (!win.shouldClose()) {
        // Game loop code here...

        win.swapBuffers();
        wgl.pullEvents();
    }
}

fn printErrorInfo(code: c_int, message: [*c]const u8) callconv(.c) void {
    std.debug.print("Error code: {d}\n", .{code});
    std.debug.print("Error Message: {s}\n", .{message});
}
