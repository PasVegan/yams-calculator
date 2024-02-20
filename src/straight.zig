const std = @import("std");
const d = @import("parseDice.zig");
const bc = @import("binomial_coefficient.zig");

pub const Straight = struct {
    n: u8 = 0,

    pub fn init(arg: []const u8) !Straight {
        if (arg.len != 10) return error.MissingPairArg;

        const firstNbIndex: usize = ( std.mem.indexOf(u8, arg, "_") orelse return error.MissingFullArg) + 1;

        const nb1: u8 = try d.parseDiceChar(arg[firstNbIndex]);

        if (nb1 != 5 and nb1 != 6) return error.StraightNot5or6;

        return .{ .n = nb1 };
    }

    pub fn compute(self: Straight, dice_numbers: [5]u8) !void {
        var probability: f64 = 0.0;

        // @as(*const [1]u8, &.{ nb }) is a workaround for transmuting a u8 to a []u8
        const nb_6: bool = std.mem.containsAtLeast(u8, &dice_numbers, 1,@as(*const [1]u8, &.{ 6 }));
        const nb_5: bool = std.mem.containsAtLeast(u8, &dice_numbers, 1,@as(*const [1]u8, &.{ 5 }));
        const nb_4: bool = std.mem.containsAtLeast(u8, &dice_numbers, 1,@as(*const [1]u8, &.{ 4 }));
        const nb_3: bool = std.mem.containsAtLeast(u8, &dice_numbers, 1,@as(*const [1]u8, &.{ 3 }));
        const nb_2: bool = std.mem.containsAtLeast(u8, &dice_numbers, 1,@as(*const [1]u8, &.{ 2 }));
        const nb_1: bool = std.mem.containsAtLeast(u8, &dice_numbers, 1,@as(*const [1]u8, &.{ 1 }));

        if (self.n == 5 and nb_5 and nb_4 and nb_3 and nb_2 and nb_1) {
            probability = 100.0;
        } else if (self.n == 6 and nb_6 and nb_5 and nb_4 and nb_3 and nb_2) {
            probability = 100.0;
        } else {
            var nb_to_relaunch: u8 = 0;

            if (self.n == 5) {
                nb_to_relaunch = @as(u8,@intFromBool(!nb_5)) + @as(u8,@intFromBool(!nb_4)) + @as(u8,@intFromBool(!nb_3)) + @as(u8,@intFromBool(!nb_2)) + @as(u8,@intFromBool(!nb_1));
            } else {
                nb_to_relaunch = @as(u8,@intFromBool(!nb_6)) + @as(u8,@intFromBool(!nb_5)) + @as(u8,@intFromBool(!nb_4)) + @as(u8,@intFromBool(!nb_3)) + @as(u8,@intFromBool(!nb_2));
            }

            probability = bc.Factorial(f64, @floatFromInt(nb_to_relaunch)) / std.math.pow(f64, 6, @floatFromInt(nb_to_relaunch)) * 100.0;
        }

        try std.io.getStdOut().writer().print("Chances to get a {d} straight: {d:.2}%\n", .{self.n, probability});
    }
};
