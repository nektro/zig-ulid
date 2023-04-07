//! https://www.crockford.com/base32.html

const std = @import("std");
const string = []const u8;
const range = @import("range").range;

const alphabet = "0123456789ABCDEFGHJKMNPQRSTVWXYZ";

pub fn decode(comptime amount: usize, input: []const u8) [amount]u5 {
    var list: [amount]u5 = undefined;

    var index: usize = 0;

    for (input) |c| {
        for (alphabet, 0..) |d, i| {
            if (c == d) {
                list[index] = @intCast(u5, i);
                index += 1;
            }
        }
    }

    return list;
}

pub fn formatInt(comptime T: type, n: T, buf: []u8) void {
    const l = @intCast(T, alphabet.len);
    var x = n;
    var i = buf.len;
    for (range(i), 0..) |_, j| {
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
