const std = @import("std");
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
pub fn createWindow(option: glfw.WindowOptions) !Self {
    return .{.instance = glfw.createWindow(option)};
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
pub fn destroy(self: *Self) void {
    glfw.destroyWindow(self.instance);
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
pub fn errorCallback(@"fn": glfw.ErrorCallBack) void {
    _ = glfw.errorCallback(@"fn");
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
