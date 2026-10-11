const std = @import("std");
const builtin = @import("builtin");


pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Exposing as a dependency for other projects
    const pkg = b.addModule("wgl", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize
    });

    pkg.addIncludePath(b.path("libs/include"));

    const main = b.addModule("main", .{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    main.addIncludePath(b.path("libs/include"));

    const app = "wgl";
    const exe = b.addExecutable(.{.name = app, .root_module = main});

    // Adding cross-platform dependency
    switch (target.query.os_tag orelse builtin.os.tag) {
        .windows => {
            exe.root_module.link_libc = true;

            switch (target.query.cpu_arch orelse builtin.cpu.arch) {
                .x86_64 => {
                    pkg.addObjectFile(b.path("libs/windows/glfw3dll.lib"));
                    pkg.linkSystemLibrary("gdi32", .{});

                    exe.root_module.addObjectFile(
                        b.path("libs/windows/glfw3dll.lib")
                    );
                    exe.root_module.linkSystemLibrary("gdi32", .{});
                },
                else => @panic("Unsupported architecture!")
            }
        },
        .macos => {
            exe.root_module.link_libcpp = true;

            switch (target.query.cpu_arch orelse builtin.cpu.arch) {
                .aarch64 => {
                    pkg.addObjectFile(b.path("libs/macOS/libglfw3.a"));
                    pkg.linkFramework("IOKit", .{});
                    pkg.linkFramework("Cocoa", .{});

                    exe.root_module.addObjectFile(
                        b.path("libs/macOS/libglfw3.a")
                    );
                    exe.root_module.linkFramework("IOKit", .{});
                    exe.root_module.linkFramework("Cocoa", .{});
                },
                else => @panic("Unsupported architecture!")
            }
        },
        else => @panic("Codebase is not tailored for this platform!")
    }

    // Self importing package
    exe.root_module.addImport("wgl", pkg);

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
