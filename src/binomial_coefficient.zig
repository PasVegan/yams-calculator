const std = @import("std");

const dice_probability: f64 = 1.0 / 6.0;


pub fn Factorial(comptime I: type, n: I) I {
    if (n < 0) {
        @panic("Cannot take the log factorial of a negative number.");
    }
    if (n <= 1)
        return 1;
    var sum: I = 1;
    var i: I = 2;
    while (i <= n) : (i += 1) {
        sum *= i;
    }
    return sum;
}

fn check_n_k(comptime I: type, n: I, k: I) void {
    if (n < k) {
        @panic("Parameter `n` cannot be less than parameter `k`.");
    }
    if (n < 0) {
        @panic("Parameter `n` cannot be less than 0.");
    }
    if (k < 0) {
        @panic("Parameter `k` cannot be less than 0.");
    }
}

/// Binomial coefficient for n and k.
pub fn nChooseK(comptime I: type, n: I, k: I) I {
    check_n_k(I, n, k);
    if (n == 0 or k == 0 or n == k) return 1;
    const res = Factorial(I, n) / (Factorial(I, k) * Factorial(I, n - k));
    return res;
}

/// Binomial formula
pub fn binomial(n: u8, k: u8) f64 {
     return nChooseK(f64, @floatFromInt(n), @floatFromInt(k)) * std.math.pow(f64, dice_probability, @floatFromInt(k)) * std.math.pow(f64, 1.0 - dice_probability, @floatFromInt(n - k)) * 100.0;
}