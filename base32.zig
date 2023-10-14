//! https://www.crockford.com/base32.html

const std = @import("std");
const string = []const u8;

const alphabet = "0123456789ABCDEFGHJKMNPQRSTVWXYZ";

pub fn decode(alloc: std.mem.Allocator, input: string) ![]const u5 {
    var list = std.ArrayList(u5).init(alloc);
    errdefer list.deinit();

    for (input) |c| {
        for (alphabet, 0..) |d, i| {
            if (c == d) {
                try list.append(@intCast(i));
            }
        }
    }
    return list.toOwnedSlice();
}

pub fn formatInt(comptime T: type, n: T, buf: []u8) void {
    const l: T = @intCast(alphabet.len);
    var x = n;
    var i = buf.len;
    for (0..i) |j| {
        buf[j] = alphabet[0];
    }
    while (true) {
        const a: usize = @intCast(x % l);
        x = x / l;
        buf[i - 1] = alphabet[a];
        i -= 1;
        if (x == 0) break;
    }
}
