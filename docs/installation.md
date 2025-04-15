# How to Install

Navigate to your project directory. e.g., `cd my_awesome_project`

## Install the Nightly Version

Fetch **wgl** as external package dependency by running:

```sh
zig fetch --save \
https://github.com/bitlaab-bolt/wgl/archive/refs/heads/main.zip
```

## Install the Release Version

Fetch **wgl** as external package dependency by running:

```sh
zig fetch --save \
https://github.com/bitlaab-bolt/wgl/archive/refs/tags/v0.0.0.zip
```
Make sure to edit `v0.0.0` with the latest release version.

## Import Module

Now, import **wgl** as external package module to your project by coping following code:

```zig title="build.zig"
const wgl = b.dependency("wgl", .{});
exe.root_module.addImport("wgl", wgl.module("wgl"));
lib.root_module.addImport("wgl", wgl.module("wgl"));
```

## Shared Library Dependency

When your targeting windows platform:

For nightly version download [glfw3.dll](https://github.com/bitlaab-bolt/wgl/blob/main/libs/windows/glfw3.dll) and put this to your final executables installation directory.

For release version download `glfw.dll` from the attachment section of the Release Tag.
