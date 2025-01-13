const std = @import("std");
const builtin = @import("builtin");

const wevi = @import("wevi").Wevi;

const wgl = @import("./core/wgl.zig");


pub fn main() !void {
    var gpa_mem = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa_mem.deinit() == .ok);
    const heap = gpa_mem.allocator();

    try wgl.init();
    defer wgl.deinit();

    var win = try wgl.createWindow(.{.width = 720, .height = 460});
    defer win.destroy();

    win.setSizeLimits(.{.min_width = 720, .min_height = 360});
    try win.setWindowIcon(heap, "./tests/icon.png");

    // Native window handler
    const native_win: *anyopaque = switch (builtin.os.tag) {
        .windows => @ptrCast(wgl.windows.getNativeWindow(win.instance)),
        .macos => @ptrCast(wgl.macOS.getNativeWindow(win.instance)),
        else => unreachable
    };

    var view = try wevi.create(.On, native_win);
    try view.setHtml("<h1>Hello, world!</h1>");


    // std.debug.print("{any}\n", .{wgl.windows.getNativeWindow(win.instance)});

    while (!win.shouldClose()) {
        // Render here

        win.swapBuffers();
        wgl.pullEvents();
    }
}
