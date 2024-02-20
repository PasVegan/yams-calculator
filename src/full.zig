const std = @import("std");
const d = @import("parseDice.zig");
const bc = @import("binomial_coefficient.zig");

pub const Full = struct {
    n1: u8 = 0,
    n2: u8 = 0,


    pub fn init(arg: []const u8) !Full {
        if (arg.len != 8) return error.MissingFullArg;

        const firstNbIndex: usize = ( std.mem.indexOf(u8, arg, "_") orelse return error.MissingFullArg) + 1;
        const SecondNbIndex: usize =  (std.mem.indexOf(u8, arg[firstNbIndex..], "_") orelse return error.MissingFullArg) + firstNbIndex + 1;

        const nb1: u8 = try d.parseDiceChar(arg[firstNbIndex]);
        const nb2: u8 = try d.parseDiceChar(arg[SecondNbIndex]);

        if (nb1 <= 0 or nb2 <= 0) return error.InvalidCombinationDice;
        if (nb1 == nb2) return error.ErrorSameFullDice;

        return .{
            .n1 = nb1,
            .n2 = nb2,
        };
    }

    pub fn compute(self: Full, dice_numbers: [5]u8) !void {
        const nb_of_wanted_number_a_in_hand: u8 = @intCast(std.mem.count(u8, &dice_numbers, @as(*const [1]u8, &.{ self.n1 })));
        const nb_of_wanted_number_b_in_hand: u8 = @intCast(std.mem.count(u8, &dice_numbers, @as(*const [1]u8, &.{ self.n2 })));

        var probability: f64 = 0.0;

        if (nb_of_wanted_number_a_in_hand >= 3 and nb_of_wanted_number_b_in_hand >= 2) {
            probability = 100.0;
        } else {
            var nb_number_a: u8 = nb_of_wanted_number_a_in_hand;
            var nb_number_b: u8 = nb_of_wanted_number_b_in_hand;
            if (nb_of_wanted_number_a_in_hand > 3) nb_number_a = 3;
            if (nb_of_wanted_number_b_in_hand > 2) nb_number_b = 2; // must reset because it can lead to k > n for the binomial coefficient
            probability = bc.nChooseK(f64, @floatFromInt(5 - nb_number_a - nb_number_b), @floatFromInt(3 - nb_number_a)) / std.math.pow(f64, 6, @floatFromInt(5 - nb_number_a - nb_number_b)) * 100.0;
        }

        try std.io.getStdOut().writer().print("Chances to get a {d} full of {d}: {d:.2}%\n", .{self.n1, self.n2, probability});
    }
};
