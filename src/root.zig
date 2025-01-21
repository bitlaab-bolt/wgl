//! # GLFW3 Library Binding
//! - See documentation at - https://bitlaabwgl.web.app/

pub const Wgl = @import("./core/wgl.zig");

/// # API Bindings for Underlying Libraries
pub const Api = struct {
    pub const glfw = @import("./binding/glfw.zig");
};
