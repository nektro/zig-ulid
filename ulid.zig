//! https://github.com/ulid/spec

const std = @import("std");
const string = []const u8;
const base32 = @import("./base32.zig");
const extras = @import("extras");

pub const Factory = struct {
    epoch: i64,
    rand: *std.rand.Random,

    pub fn init(epoch: i64, rand: *std.rand.Random) Factory {
        return Factory{
            .epoch = epoch,
            .rand = rand,
        };
    }

    pub fn newULID(self: Factory) ULID {
        const now = std.time.milliTimestamp();
        return ULID{
            .timestamp = std.math.cast(u48, now - self.epoch) catch @panic("time.milliTimestamp() is higher than 281474976710655"),
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

    pub fn readField(alloc: *std.mem.Allocator, value: BaseType) !ULID {
        if (value.len != 26) return error.Ulid;
        return ULID{
            .timestamp = try std.math.cast(u48, try extras.sliceToInt(u50, u5, try base32.decode(alloc, value[0..10]))),
            .randomnes = try extras.sliceToInt(u80, u5, try base32.decode(alloc, value[10..26])),
        };
    }

    pub fn bindField(self: ULID, alloc: *std.mem.Allocator) !BaseType {
        var res = try alloc.alloc(u8, 26);
        base32.formatInt(u48, self.timestamp, res[0..10]);
        base32.formatInt(u80, self.randomnes, res[10..26]);
        return res;
    }

    pub const fromString = readField;
    pub const toString = bindField;

    pub fn format(self: ULID, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) @TypeOf(writer).Error!void {
        _ = fmt;
        _ = options;
        try writer.writeAll(self.toString());
    }
};
