const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;

const glfw = @import("../binding/glfw.zig");


instance: ?*glfw.Window,

const Self = @This();

/// # Initializes the GLFW library
pub fn init() !void { try glfw.init(); }

/// # Destroys GLFW library
pub fn deinit() void { glfw.terminate(); }

/// # Processes All Pending Events in the Event Queue
pub fn pullEvents() void { glfw.pollEvents(); }

/// # Creates Cross-Platform Window Instance
/// - Returns `error.WindowCreationFailed` if the underlying GLFW call fails
pub fn createWindow(option: glfw.WindowOptions) !Self {
    const win = glfw.createWindow(option) orelse return error.WindowCreationFailed;
    return .{ .instance = win };
}

/// # Sets the Content Area Limits of a Window
/// - Use `-1` if you don't care about a `min` and / or `max` limit
pub fn setSizeLimits(self: *Self, limits: glfw.WindowLimits) void {
    glfw.setWindowSizeLimits(self.instance, limits);
}

/// # Maximizes the Specified Window
pub fn maximizeWindow(self: *Self) void {
    glfw.maximizeWindow(self.instance);
}

/// # Checks the Close Flag of the Specified Window
pub fn shouldClose(self: *Self) bool {
    return glfw.windowShouldClose(self.instance);
}

/// # Destroys the Specified Window and Its Context
/// - Safe to call multiple times; the instance pointer is cleared after destroy
pub fn destroy(self: *Self) void {
    if (self.instance) |win| glfw.destroyWindow(win);
    self.instance = null;
}

/// # Makes Window Context Current on the Calling Thread
pub fn makeContextCurrent(self: *Self) void {
    glfw.makeContextCurrent(self.instance);
}

/// # Swaps the Front and Back Buffers of the Specified Window
pub fn swapBuffers(self: *Self) void {
    glfw.swapBuffers(self.instance);
}

/// # Sets Swap Interval for the Current OpenGL Context
/// **A.K.A** - vertical retrace synchronization or vsync.
pub fn swapInterval(count: i32) void { glfw.swapInterval(count); }

/// # Sets the Error Callback Function
/// Shows error code and a human-readable description when error occurs
/// - Returns the previously set callback, or `null` if no callback was set
/// - Should be called before `init()` to catch initialization errors
pub fn errorCallback(@"fn": glfw.ErrorCallBack) glfw.ErrorCallBack {
    return glfw.errorCallback(@"fn");
}

// # Platform Specific Functionality
pub const macOS = if (builtin.os.tag == .macos) struct {
    /// # Gets `NSWindow` of the Specified Window
    pub fn getNativeWindow(win: ?*glfw.Window) glfw.NSWindow {
        return glfw.getCocoaWindow(win);
    }
} else struct {};

// # Platform Specific Functionality
pub const windows = if (builtin.os.tag == .windows) struct {
    /// # Gets `HWND` of the Specified Window
    pub fn getNativeWindow(win: ?*glfw.Window) glfw.HWND {
        return glfw.getWin32Window(win);
    }
} else struct {};
