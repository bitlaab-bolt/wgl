const std = @import("std");
const builtin = @import("builtin");

const glfw = @cImport({
    switch (builtin.target.os.tag) {
        .macos => @cDefine("GLFW_EXPOSE_NATIVE_COCOA", "1"),
        .windows => {
            @cDefine("GLFW_EXPOSE_NATIVE_WIN32", "1");
            @cDefine("struct_DECLSPEC_UUID", "struct");
        },
        else => @panic("Codebase is not tailored for this platform!")
    }

    @cDefine("GLFWAPI", "__attribute__((visibility(\"default\")))");
    @cInclude("glfw3.h");
    @cInclude("glfw3native.h");
});


const Error = error { InitializationFailed };

pub const ErrorCallBack = glfw.GLFWerrorfun;

pub const Window = opaque {};
const Monitor = opaque {};

pub fn init() Error!void {
    const rv = glfw.glfwInit();
    if (rv != 1) return Error.InitializationFailed;
}

pub fn terminate() void { glfw.glfwTerminate(); }

pub const WindowOptions = struct {
    width: i32,
    height: i32,
    title: []const u8 = "",
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
    min_width: i32,
    min_height: i32,
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

pub const Image = extern struct { width: i32, height: i32, pixels: [*]u8 };

pub fn setWindowIcon(win: ?*Window, count: i32, images: [*]const Image) void {
    glfw.glfwSetWindowIcon(@ptrCast(win), count, @ptrCast(images));
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

pub fn swapInterval(count: i32) void { glfw.glfwSwapInterval(@intCast(count)); }

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
