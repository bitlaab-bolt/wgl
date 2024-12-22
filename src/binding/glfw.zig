const std = @import("std");
const builtin = @import("builtin");

const glfw = @cImport({
    switch (builtin.target.os.tag) {
        .macos => @cDefine("GLFW_EXPOSE_NATIVE_COCOA", "1"),
        .windows => @cDefine("GLFW_EXPOSE_NATIVE_WIN32", "1"),
        else => @panic("Codebase is not tailored for this platform!")
    }

    @cDefine("GLFW_EXPOSE_NATIVE_COCOA", "1")
    @cDefine("GLFWAPI", "__attribute__((visibility(\"default\")))");
    @cInclude("glfw3.h");
    @cInclude("glfw3native.h");
});


const Error = error { InitializationFailed };

pub const Window = opaque {};
const Monitor = opaque {};

/// # Initializes the GLFW library
pub fn init() Error!void {
    const rv = glfw.glfwInit();
    if (rv != 1) return Error.InitializationFailed;
}

/// # Destroys GLFW library
pub fn terminate() void {
    glfw.glfwTerminate();
}

pub const WindowOptions = struct {
    width: i32,
    height: i32,
    title: []const u8 = "",
    monitor: ?*Monitor = null,
    share: ?*Window = null
};

/// A Window and its OpenGL Context are Created
pub fn createWindow(option: WindowOptions) ?*Window {
    const win = glfw.glfwCreateWindow(
        option.width,
        option.height,
        option.title.ptr,
        @ptrCast(option.monitor),
        @ptrCast(option.share)
    );

    return @ptrCast(win);
}

pub const WindowLimits = struct {
    min_width: i32,
    min_height: i32,
    max_width: i32 = -1,
    max_height: i32 = -1
};

/// # Content Area Limits of a Windowed Mode
/// - Use `-1` if you don't care about a `min` and / or `max` limit
pub fn setWindowSizeLimits(win: ?*Window, limits: WindowLimits) void {
    glfw.glfwSetWindowSizeLimits(
        @ptrCast(win),
        limits.min_width,
        limits.min_height,
        limits.max_width,
        limits.max_height
    );
}

pub const Image = extern struct { width: i32, height: i32, pixels: [*]u8 };

pub fn setWindowIcon(win: ?*Window, count: i32, images: [*]const Image) void {
    glfw.glfwSetWindowIcon(@ptrCast(win), count, @ptrCast(images));
}

/// # Checks the Close Flag of the Specified Window
pub fn windowShouldClose(win: ?*Window) bool {
    const rv = glfw.glfwWindowShouldClose(@ptrCast(win));
    return if (rv == 1) true else false;
}

/// # Destroys the Specified Window and its Context
pub fn destroyWindow(win: ?*Window) void {
    glfw.glfwDestroyWindow(@ptrCast(win));
}

/// # Swaps the Front and Back Buffers of the Specified Window
pub fn swapBuffers(win: ?*Window) void {
    glfw.glfwSwapBuffers(@ptrCast(win));
}

/// # Processes All Pending Events in the Event Queue
pub fn pollEvents() void {
    glfw.glfwPollEvents();
}


const struct_objc_class = opaque {};
const Class = ?*struct_objc_class;
const struct_objc_object = extern struct {
    isa: Class = @import("std").mem.zeroes(Class),
};
pub const NSWindow = [*c]struct_objc_object;

/// # Gets `NSWindow` of the Specified Window
pub fn getCocoaWindow(win: ?*Window) NSWindow {
    const id = glfw.glfwGetCocoaWindow(@ptrCast(win));
    return @ptrCast(id);
}

/// # Gets `HWND` of the Specified Window
pub fn getWin32Window(win: ?*Window) void {
    const x = glfw.glfwGetWin32Window(@ptrCast(win));
}