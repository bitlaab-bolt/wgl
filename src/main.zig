const std = @import("std");

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

    std.debug.print("{any}\n", .{wgl.windows.getNativeWindow(win.instance)});

    while (!win.shouldClose()) {
        // Render here

        win.swapBuffers();
        wgl.pullEvents();
    }
}
