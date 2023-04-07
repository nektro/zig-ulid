//! https://github.com/ulid/spec

const std = @import("std");
const string = []const u8;
const base32 = @import("./base32.zig");
const extras = @import("extras");

pub const Factory = struct {
    epoch: i64,
    rand: std.rand.Random,

    pub fn init(epoch: i64, rand: std.rand.Random) Factory {
        return Factory{
            .epoch = epoch,
            .rand = rand,
        };
    }

    pub fn newULID(self: Factory) ULID {
        const now = std.time.milliTimestamp();
        return ULID{
            .timestamp = std.math.cast(u48, now - self.epoch) orelse @panic("time.milliTimestamp() is higher than 281474976710655"),
            .randomnes = self.rand.int(u80),
        };
    }
};

///  01AN4Z07BY   79KA1307SR9X4MV3
///
/// |----------| |----------------|
///  Timestamp       Randomness
///    48bits          80bits
pub const ULID = struct {
    timestamp: u48,
    randomnes: u80,

    pub const BaseType = string;

    usingnamespace extras.StringerJsonStringifyMixin(@This());

    pub fn parse(value: BaseType) !ULID {
        if (value.len != 26) return error.Ulid;

        const decoded_timestamp = base32.decode(10, value[0..10]);
        const decoded_randomnes = base32.decode(16, value[10..26]);

        return ULID{
            .timestamp = std.math.cast(u48, try extras.sliceToInt(u50, u5, &decoded_timestamp)) orelse return error.Ulid,
            .randomnes = try extras.sliceToInt(u80, u5, &decoded_randomnes),
        };
    }

    pub fn toString(self: ULID, alloc: std.mem.Allocator) !BaseType {
        var res = try std.ArrayList(u8).initCapacity(alloc, 26);
        defer res.deinit();
        try res.writer().print("{}", .{self});
        return res.toOwnedSlice();
    }

    pub const readField = parse;
    pub const bindField = toString;

    pub fn bytes(self: ULID) [26]u8 {
        var buf: [26]u8 = undefined;
        base32.formatInt(u48, self.timestamp, buf[0..10]);
        base32.formatInt(u80, self.randomnes, buf[10..26]);
        return buf;
    }

    pub fn format(self: ULID, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        _ = fmt;
        _ = options;
        try writer.writeAll(&self.bytes());
    }
};
