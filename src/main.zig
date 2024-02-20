const std = @import("std");
const bc = @import("binomial_coefficient.zig");
const fu = @import("full.zig");
const pa = @import("pair.zig");
const th = @import("three.zig");
const fo = @import("four.zig");
const st = @import("straight.zig");
const ya = @import("yams.zig");
const d = @import("parseDice.zig");


// Tagged union
const Combination = union(enum) {
    full: fu.Full,
    pair: pa.Pair,
    three: th.Three,
    four: fo.Four,
    yams: ya.Yams,
    straight: st.Straight,

    // This function dispatches to the variants.
    fn parse(args: []const []const u8) !Combination {
        const combinationEndIndex: usize =  std.mem.indexOf(u8, args[0], "_") orelse args[0].len;
        // We use the comptime string map to look up the combination.
        if (combinations.get(args[0][0..combinationEndIndex])) |v| {
            // We switch on the tagged union.
            return switch (v) {
                .full => .{ .full = try fu.Full.init(args[0]) },
                .pair => .{ .pair = try pa.Pair.init(args[0]) },
                .three => .{ .three = try th.Three.init(args[0]) },
                .four => .{ .four = try fo.Four.init(args[0]) },
                .yams => .{ .yams = try ya.Yams.init(args[0]) },
                .straight => .{ .straight = try st.Straight.init(args[0]) },
            };
        }

        return error.InvalidCombination;
    }

    //This function computes the probability of the combination.
    fn compute(self: Combination, dice_numbers: [5]u8) !void {
        switch (self) {
            Combination.full => try self.full.compute(dice_numbers),
            Combination.pair => try self.pair.compute(dice_numbers),
            Combination.three => try self.three.compute(dice_numbers),
            Combination.four => try self.four.compute(dice_numbers),
            Combination.yams => try self.yams.compute(dice_numbers),
            Combination.straight => try self.straight.compute(dice_numbers),
        }
    }
};


// Like a hash map, but where all keys and values have
// to be known at compile time.
// Here the values are just placeholders so we can switch
// on their tagged union variant type.
const combinations = std.ComptimeStringMap(Combination, .{
    .{ "full", .{ .full = .{} } },
    .{ "pair", .{ .pair = .{} } },
    .{ "three", .{ .three = .{} } },
    .{ "four", .{ .four = .{} } },
    .{ "yams", .{ .yams = .{} } },
    .{ "straight", .{ .straight = .{} } },
});


pub fn main() u8 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = std.process.argsAlloc(allocator) catch {
        std.debug.print("failed to allocate args\n", .{});
        return 84;
    };
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        return 84;
    }

    if (std.mem.eql(u8, args[1], "-h")) {
        const help =
            \\USAGE
            \\    ./yams d1 d2 d3 d4 d5 c cd1 [cd2]
            \\
            \\DESCRIPTION
            \\    d1    value of the first die (0 if not thrown)
            \\    d2    value of the second die (0 if not thrown)
            \\    d3    value of the third die (0 if not thrown)
            \\    d4    value of the fourth die (0 if not thrown)
            \\    d5    value of the fifth die (0 if not thrown)
            \\    c     combination to be obtained
            \\    cd1   first dice in combination
            \\    [cd2] second dice in combination (if applicable)
            \\
        ;

        std.io.getStdOut().writeAll(help) catch {
            std.debug.print("failed to write to stdout\n", .{});
        };

        return 0;
    }

    if ((args.len != 7))
        return 84;

    var dice_numbers: [5]u8 = undefined;

    for (args[1..6], 0..) |arg, i| dice_numbers[i] = d.parseDice(arg) catch {
        std.debug.print("Dice parsing error\n", .{});
        return 84;
    };

    const combination = Combination.parse(args[6..]) catch {
        std.debug.print("Combination parsing error\n", .{});
        return 84;
    };

    combination.compute(dice_numbers) catch {
        std.debug.print("Probability computation error\n", .{});
        return 84;
    };

    return 0;
}
