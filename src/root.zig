//! # GLFW3 Library Binding
//! - See documentation at - https://bitlaab.com/api-doc?pkg=wgl

pub const Wgl = @import("./core/wgl.zig");

/// # API Bindings for Underlying Libraries
pub const Api = struct {
    pub const glfw = @import("./binding/glfw.zig");
};
