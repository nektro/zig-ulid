const std = @import("std");
const deps = @import("./deps.zig");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.option(std.builtin.Mode, "mode", "") orelse .Debug;

    const exe = b.addExecutable(.{
        .name = "zig-ulid",
        .root_source_file = .{ .path = "main.zig" },
        .target = target,
        .optimize = mode,
    });
    deps.addAllTo(exe);
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const tests = b.addTest(.{
        .root_source_file = b.path("./test.zig"),
        .target = target,
        .optimize = mode,
    });
    deps.addAllTo(tests);

    const tests_run = b.addRunArtifact(tests);

    const test_step = b.step("test", "dummy test step to pass CI checks");
    test_step.dependOn(&tests_run.step);
}
