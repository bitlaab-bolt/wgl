# wgl

**Cross-Platform Window Library for Zig**

Wgl is a cross-platform window creation and management library. It provides a high-level API that unifies windowing across operating systems, along with direct access to the underlying API bindings for developers who need custom, lower-level control.

## Platform Support

Supports **Windows** (x64) and **MacOS** (Apple silicon). Please create an issue if you need other platform support for your use case.

## Dependency

### MacOS

All dependencies are linked as static libraries. No additional steps are required!

### Windows

The final executable requires `glfw3.dll`. The necessary steps are in the documentation's **Installation** section.

## Documentation

For most up-to-date documentation see - [**Wgl Documentation**](https://bitlaab.com/api-doc?pkg=wgl).
