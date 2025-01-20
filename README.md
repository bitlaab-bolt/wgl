# wgl

**Window graphics library bindings for Zig.**

Wgl is intended to be a high-level abstraction for cross-platform window creation and management. Along with abstraction, Wgl exposes underlying API bindings for more custom-tailored functionality.

## Platform Support

As of now, Wgl supports **Windows** (x64) and **MacOS** (Apple silicon). Please create an issue if you need other platform support for your use case.

## Dependency

All of Wgl's dependencies are linked as static libraries. No additional steps are required!

On Windows, `glfw3.dll` is required on the final executable. You will find the necessary steps in the Installation section in the documentation.

## Documentation

For most up-to-date documentation see - [**Wgl Documentation**](https://bitlaabwgl.web.app/).