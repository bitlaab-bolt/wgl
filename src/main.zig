const std = @import("std");
const builtin = @import("builtin");

const wevi = @import("wevi").Wevi;

const wgl = @import("./core/wgl.zig");


pub fn main() !void {
    // var gpa_mem = std.heap.GeneralPurposeAllocator(.{}){};
    // defer std.debug.assert(gpa_mem.deinit() == .ok);
    // const heap = gpa_mem.allocator();

    try wgl.init();
    defer wgl.deinit();
    wgl.x();
    wgl.swapInterval(1);

    wgl.errorCallback(errorInfo);


    var win = try wgl.createWindow(.{.width = 720, .height = 460});
    defer win.destroy();

    // win.makeContextCurrent();

    win.setSizeLimits(.{.min_width = 720, .min_height = 360});
    // try win.setWindowIcon(heap, "./tests/icon.png");

   
    

    // Native window handler
    const native_win: *anyopaque = switch (builtin.os.tag) {
        .windows => @ptrCast(wgl.windows.getNativeWindow(win.instance)),
        .macos => @ptrCast(wgl.macOS.getNativeWindow(win.instance)),
        else => unreachable
    };




    var view = try wevi.create(.Off, native_win);
    // try view.setHtml("<h1 style=\"color: red;\">Hello, world!</h1>");
    // try view.title("fool");
    try view.navigate("https://example.com");
    // try view.run();
    // try view.destroy();

    std.debug.print("{any}\n", .{native_win});

    while (!win.shouldClose()) {
        // Render here
        // win.swapBuffers();
        wgl.pullEvents();
    }
}

fn errorInfo(code: c_int, message: [*c]const u8) callconv(.c) void {
    std.debug.print("Error code: {d}\n", .{code});
    std.debug.print("Error Message: {s}\n", .{message});
}
