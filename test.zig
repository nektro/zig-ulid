const std = @import("std");
const string = []const u8;
const ulid = @import("ulid");

// zig fmt: off
test { try ensureFromTo("001HX7QW7K2PP61CS28B4YF00X"); }
test { try ensureFromTo("0015KMZ1NDDFP4WRWSVA31N0CD"); }
test { try ensureFromTo("0015MFYM13K180VCNCACTFRJAB"); }
test { try ensureFromTo("0015RMHR0WVSCBE4CJWKPCC4GJ"); }
test { try ensureFromTo("0017NSY29QD0YYPB0H0W5GQJQX"); }
test { try ensureFromTo("0017TZRGVZYHK9C26FK5AP3HTG"); }
test { try ensureFromTo("0017Y302CVXHJABSPHNNEBE0R7"); }
test { try ensureFromTo("00183KTME6PJZ773Q9A1BWFJ3X"); }
test { try ensureFromTo("0018ZPQ92P0NDDKNVB3PBW7D18"); }
test { try ensureFromTo("00193A6YMTQR01XTY757XRRJKE"); }
test { try ensureFromTo("0019ABB5M0YK71B4ATA90A8F81"); }
test { try ensureFromTo("0019GFR7YK5HNTFPS2BAQNG0PX"); }
test { try ensureFromTo("001A2YPKW942R97BXRAJG2BD7S"); }
test { try ensureFromTo("001C38D808VW1EG3JS6XJHT4EQ"); }
test { try ensureFromTo("001C9DSQ8SC6SVEVHFK09XBFTC"); }
test { try ensureFromTo("001DEJXKVPDV7BZT1Q80ZEN2PF"); }
test { try ensureFromTo("001F1Z79BCKADWYPDCMZ8B8G0G"); }
// zig fmt: on

fn ensureFromTo(before: string) !void {
    const alloc = std.heap.page_allocator;
    const ul = try ulid.ULID.parse(alloc, before);
    const after = try ul.toString(alloc);
    try std.testing.expectEqualStrings(before, after);
}
