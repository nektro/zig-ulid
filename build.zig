const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const extras_dep = b.dependency("extras", .{});
    const extras = extras_dep.module("extras");

    const exe = b.addExecutable(.{
        .name = "zig-ulid",
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const mod = b.addModule(
        "zig-ulid",
        .{ .root_source_file = b.path("ulid.zig") },
    );

    mod.addImport("extras", extras);
    exe.root_module.addImport("extras", extras);

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
