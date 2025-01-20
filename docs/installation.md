# How to Install

## Prerequisite

As of now, Wgl supports Windows (x64) and MacOS (Apple silicon).

Make sure you have **Zig v0.14.0 / nightly** installed on your platform.

## Installation

Navigate to your project directory. e.g., `cd my_awesome_project`

### Install the Alpha Version

Fetch wgl as zig package dependency by running:

```sh
zig fetch --save \
https://github.com/bitlaab-bolt/wgl/archive/refs/heads/main.zip
```

### Install a Release Version

Fetch wgl as zig package dependency by running:

```sh
zig fetch --save \
https://github.com/bitlaab-bolt/wgl/archive/refs/tags/"your-version".zip
```

Add wgl as dependency to your project by coping following code on your project.

```zig title="build.zig"
const wgl = b.dependency("wgl", .{});
exe.root_module.addImport("wgl", wgl.module("wgl"));
lib.root_module.addImport("wgl", wgl.module("wgl"));
```

### Shared Library Dependency

When your targeting windows platform:

For alpha version download [glfw3.dll](https://github.com/bitlaab-bolt/wgl/blob/main/libs/windows/glfw3.dll) and put this to your final executables installation directory.

For release version download `glfw.dll` from the attachment section of the Release Tag.