const std = @import("std");
const Allocator = std.mem.Allocator;

const lime = @import("lime");
const glfw = @import("../binding/glfw.zig");


const Error = error { FailedToLoadImage };

instance: ?*glfw.Window,

const Self = @This();


pub fn init() !void {
    try glfw.init();
}

pub fn deinit() void {
    glfw.terminate();
}

/// # Processes All Pending Events in the Event Queue
pub fn pullEvents() void {
    glfw.pollEvents();
}

/// # Creates Cross-Platform Window Instance
pub fn createWindow(option: glfw.WindowOptions) !Self {
    return .{.instance = glfw.createWindow(option)};
}

pub fn setSizeLimits(self: *Self, limits: glfw.WindowLimits) void {
    glfw.setWindowSizeLimits(self.instance, limits);
}

pub const Image = glfw.Image;

/// Does not shows on macos
pub fn setWindowIcon(self: *Self, heap: Allocator, path: []const u8) !void {
    const image = try lime.Png.loadImage(heap, path);
    switch(image) {
        .err => |v| {
            std.log.err("Error: {s}\n", .{v});
            return Error.FailedToLoadImage;
        },
        .data => |v| {
            errdefer lime.Png.freeImage(heap, v);
            const ihdr = try lime.Png.loadImageHeader(path);
            switch (ihdr) {
                .err => |w| {
                    std.log.err("Error: {s}\n", .{w});
                    return Error.FailedToLoadImage;
                },
                .ihdr => |w| {
                    var img: [1]Image = undefined;
                    img[0] = Image {
                        .width = @intCast(w.width),
                        .height = @intCast(w.height),
                        .pixels = @constCast(v.ptr)
                    };

                    const count = v.len;
                    glfw.setWindowIcon(self.instance, @intCast(count), &img);
                },
                .data => unreachable
            }
        },
        .ihdr => unreachable
    }

    lime.Png.freeImage(heap, image.data);
}

/// # Checks the Close Flag of the Specified Window
pub fn shouldClose(self: *Self) bool {
    return glfw.windowShouldClose(self.instance);
}

pub fn destroy(self: *Self) void {
    glfw.destroyWindow(self.instance);
}

/// # Swaps the Front and Back Buffers of the Specified Window
pub fn swapBuffers(self: *Self) void {
    glfw.swapBuffers(self.instance);
}

/// # Platform Specific Functionality
pub const macOS = struct {
    /// # Gets `NSWindow` of the Specified Window
    pub fn getNativeWindow(win: ?*glfw.Window) glfw.NSWindow {
        return glfw.getCocoaWindow(win);
    }
};

// # Platform Specific Functionality
pub const windows = struct {
    /// # Gets `HWND` of the Specified Window
    pub fn getNativeWindow(win: ?*glfw.Window) glfw.HWND {
        return glfw.getWin32Window(win);
    }
};