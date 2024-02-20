const std = @import("std");
const d = @import("parseDice.zig");
const bc = @import("binomial_coefficient.zig");

pub const Pair = struct {
    n: u8 = 0,

    pub fn init(arg: []const u8) !Pair {
        if (arg.len != 6) return error.MissingPairArg;

        const firstNbIndex: usize = ( std.mem.indexOf(u8, arg, "_") orelse return error.MissingFullArg) + 1;

        const nb1: u8 = try d.parseDiceChar(arg[firstNbIndex]);

        if (nb1 <= 0) return error.InvalidCombinationDice;

        return .{ .n = nb1 };
    }

    pub fn compute(self: Pair, dice_numbers: [5]u8) !void {
        const nb_of_wanted_number_in_hand: u8 = @intCast(std.mem.count(u8, &dice_numbers, @as(*const [1]u8, &.{ self.n })));

        var probability: f64 = 0.0;
        if (nb_of_wanted_number_in_hand >= 2) {
            probability = 100.0;
        } else {
            probability = bc.binomial(5 - nb_of_wanted_number_in_hand, 2 - nb_of_wanted_number_in_hand);
            probability += bc.binomial(5 - nb_of_wanted_number_in_hand, 3 - nb_of_wanted_number_in_hand);
            probability += bc.binomial(5 - nb_of_wanted_number_in_hand, 4 - nb_of_wanted_number_in_hand);
            probability += bc.binomial(5 - nb_of_wanted_number_in_hand, 5 - nb_of_wanted_number_in_hand);
        }

        try std.io.getStdOut().writer().print("Chances to get a {d} pair: {d:.2}%\n", .{self.n, probability});
    }
};
