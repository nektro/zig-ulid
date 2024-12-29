const std = @import("std");
const deps = @import("./deps.zig");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.option(std.builtin.Mode, "mode", "") orelse .Debug;

    const tests = b.addTest(.{
        .root_source_file = b.path("./test.zig"),
        .target = target,
        .optimize = mode,
    });
    deps.addAllTo(tests);

    const tests_run = b.addRunArtifact(tests);
    tests_run.has_side_effects = true;

    const test_step = b.step("test", "dummy test step to pass CI checks");
    test_step.dependOn(&tests_run.step);
}
