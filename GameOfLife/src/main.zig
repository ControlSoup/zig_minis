// raylib-zig (c) Nikolas Wipper 2023

const std = @import("std");
const rl = @import("raylib");

const errors = error{IndexOutOfRange};

const Board = struct {
    const Self = @This();
    board: []bool,
    width: usize,
    height: usize,

    pub fn getValue(self: *Self, x: i32, y: i32) ?bool {
        if (x >= self.width or y >= self.height) return null;
        if (x < 0 or y < 0) return null;
        return self.board[self.__usizeGetIndex(@intCast(x), @intCast(y))];
    }

    pub fn update(self: *Self) void {
        rl.clearBackground(rl.Color.black);

        for (0..@intCast(self.width)) |x| {
            for (0..@intCast(self.height)) |y| {
                const i = self.__usizeGetIndex(x, y);
                const neightbor_count: u4 = self.__neightbor_count(x, y);

                if (self.board[i]) {
                    rl.drawPixel(@intCast(x), @intCast(y), rl.Color.white);
                }

                if (self.board[i]) {
                    if (neightbor_count < 2) {
                        // Rule 1
                        self.board[i] = false;
                    } else if (neightbor_count > 3) {
                        // Rule 3
                        self.board[i] = false;
                    }
                    // Rule 2 is implicit

                } else if (!self.board[i] and neightbor_count == 3) {
                    // Rule 4
                    self.board[i] = true;
                }
            }
        }
    }

    pub fn __usizeGetIndex(self: *Self, x: usize, y: usize) usize {
        return self.width * x + y;
    }

    fn __neightbor_count(self: *Self, cur_x: usize, cur_y: usize) u4 {
        var neightbor_count: u4 = 0;

        const int_x: i32 = @intCast(cur_x);
        const int_y: i32 = @intCast(cur_y);

        if (self.getValue(int_x + 1, int_y)) |_| neightbor_count += 1;
        if (self.getValue(int_x - 1, int_y)) |_| neightbor_count += 1;
        if (self.getValue(int_x + 1, int_y)) |_| neightbor_count += 1;
        if (self.getValue(int_x + 1, int_y)) |_| neightbor_count += 1;
        if (self.getValue(int_x, int_y)) |_| neightbor_count += 1;
        if (self.getValue(int_x, int_y)) |_| neightbor_count += 1;
        if (self.getValue(int_x - 1, int_y)) |_| neightbor_count += 1;
        if (self.getValue(int_x - 1, int_y)) |_| neightbor_count += 1;

        return neightbor_count;
    }
};

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 24;
    const screenHeight = 24;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(1);
    //--------------------------------------------------------------------------------------

    var board_contents = [1]bool{false} ** screenWidth ** screenHeight;
    board_contents[0] = true;
    board_contents[1] = true;
    board_contents[screenWidth + 1] = true;
    var new_board = Board{ .board = &board_contents, .height = screenHeight, .width = screenWidth };

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key

        rl.beginDrawing();
        defer rl.endDrawing();

        new_board.update();
    }
}
