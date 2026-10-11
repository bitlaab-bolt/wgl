const std = @import("std");
const builtin = @import("builtin");

pub const glfw = @import("glfw");


const Error = error { InitializationFailed };

pub const ErrorCallBack = glfw.GLFWerrorfun;

pub const Window = opaque {};
pub const Monitor = opaque {};

pub fn init() Error!void {
    const rv = glfw.glfwInit();
    if (rv != 1) return Error.InitializationFailed;
}

pub fn terminate() void { glfw.glfwTerminate(); }

pub const WindowOptions = struct {
    width: i32,
    height: i32,
    title: [:0]const u8 = "",
    monitor: ?*Monitor = null,
    share: ?*Window = null
};

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
    min_width: i32 = -1,
    min_height: i32 = -1,
    max_width: i32 = -1,
    max_height: i32 = -1
};

pub fn setWindowSizeLimits(win: ?*Window, limits: WindowLimits) void {
    glfw.glfwSetWindowSizeLimits(
        @ptrCast(win),
        limits.min_width,
        limits.min_height,
        limits.max_width,
        limits.max_height
    );
}

pub fn maximizeWindow(win: ?*Window) void {
    glfw.glfwMaximizeWindow(@ptrCast(win));
}

pub fn windowShouldClose(win: ?*Window) bool {
    const rv = glfw.glfwWindowShouldClose(@ptrCast(win));
    return if (rv == 1) true else false;
}

pub fn destroyWindow(win: ?*Window) void {
    glfw.glfwDestroyWindow(@ptrCast(win));
}

pub fn makeContextCurrent(win: ?*Window) void {
    glfw.glfwMakeContextCurrent(@ptrCast(win));
}

pub fn swapBuffers(win: ?*Window) void { glfw.glfwSwapBuffers(@ptrCast(win)); }

pub fn pollEvents() void { glfw.glfwPollEvents(); }

pub fn getPrimaryMonitor() ?*Monitor {
    return @ptrCast(glfw.glfwGetPrimaryMonitor());
}

pub fn swapInterval(count: i32) void { glfw.glfwSwapInterval(count); }

pub fn errorCallback(@"fn": ErrorCallBack) ErrorCallBack {
    return glfw.glfwSetErrorCallback(@"fn");
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

pub const struct_HWND__ = extern struct {
    unused: c_int = @import("std").mem.zeroes(c_int),
};
pub const HWND = [*c]struct_HWND__;

/// # Gets `HWND` of the Specified Window
pub fn getWin32Window(win: ?*Window) HWND {
    const id = glfw.glfwGetWin32Window(@ptrCast(win));
    return @ptrCast(id);
}
