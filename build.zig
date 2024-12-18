const std = @import("std");
const builtin = @import("builtin");


pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .Debug
    });

    // Exposing as a dependency for other projects
    const pkg = b.addModule("wgl", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize
    });

    pkg.addIncludePath(b.path("libs/include"));

    // Making executable for this project
    const exe = b.addExecutable(.{
        .name = "wgl",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.addIncludePath(b.path("libs/include"));

    // Adding cross-platform dependency
    switch (target.query.os_tag orelse builtin.os.tag) {
        .windows => {
            // exe.linkLibC();

            switch (target.query.cpu_arch orelse builtin.cpu.arch) {
                .x86_64 => {
                    pkg.addObjectFile(b.path("libs/windows/libglfw3.a"));

                    exe.addObjectFile(b.path("libs/windows/libglfw3.a"));
                },
                else => @panic("Unsupported architecture!")
            }
        },
        .macos => {
            switch (target.query.cpu_arch orelse builtin.cpu.arch) {
                .aarch64 => {
                    pkg.addObjectFile(b.path("libs/macOS/libglfw3.a"));
                    pkg.linkFramework("WebKit", .{});
                    pkg.linkFramework("IOKit", .{});
                    pkg.linkFramework("Cocoa", .{});

                    exe.addObjectFile(b.path("libs/macOS/libglfw3.a"));
                    exe.linkFramework("WebKit");
                    exe.linkFramework("IOKit");
                    exe.linkFramework("Cocoa");
                },
                else => @panic("Unsupported architecture!")
            }
        },
        else => @panic("Codebase is not tailored for this platform!")
    }


    // Adding External Dependency
    const lime = b.dependency("lime", .{});
    exe.root_module.addImport("lime", lime.module("lime"));

    pkg.addImport("lime", lime.module("lime"));

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&b.addRunArtifact(exe).step);
}
