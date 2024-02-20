const std = @import("std");

pub fn parseDice(arg: []const u8) !u8 {
    if (arg.len != 1) return error.InvalidDice;
    const n = try std.fmt.parseInt(u8, arg, 10);
    if (n > 6 or n < 0) return error.InvalidDice;
    return n;
}

pub fn parseDiceChar(arg: u8) !u8 {
    const n = try std.fmt.charToDigit(arg, 10);
    if (n > 6 or n < 0) return error.InvalidDice;
    return n;
}
