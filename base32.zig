//! https://www.crockford.com/base32.html

const std = @import("std");
const string = []const u8;
const range = @import("range").range;

const alphabet = "0123456789ABCDEFGHJKMNPQRSTVWXYZ";

pub fn decode(alloc: *std.mem.Allocator, input: string) ![]const u5 {
    const list = &std.ArrayList(u5).init(alloc);
    defer list.deinit();

    for (input) |c| {
        for (alphabet) |d, i| {
            if (c == d) {
                try list.append(@intCast(u5, i));
            }
        }
    }
    return list.toOwnedSlice();
}

pub fn formatInt(comptime T: type, n: T, buf: []u8) void {
    const l = @intCast(T, alphabet.len);
    var x = n;
    var i = buf.len;
    for (range(i)) |_, j| {
        buf[j] = alphabet[0];
    }
    while (true) {
        const a = @intCast(usize, x % l);
        x = x / l;
        buf[i - 1] = alphabet[a];
        i -= 1;
        if (x == 0) break;
    }
}
