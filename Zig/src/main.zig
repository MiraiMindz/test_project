const stdout_writer = @import("std").io.getStdOut().writer();
const stdin_reader = @import("std").io.getStdIn().reader();
const pageAllocator = @import("std").heap.page_allocator;
const ArrayList = @import("std").ArrayList;
const current_os = @import("builtin").os.tag;
const Child = @import("std").process.Child;
const arena = @import("std").heap.ArenaAllocator;
const expectEqual = @import("std").testing.expectEqual;
const expectEqualStrings = @import("std").testing.expectEqualStrings;
const parseInt = @import("std").fmt.parseInt;

const alignment_t = enum {
    left,
    center,
    right,
};

const aligned_string = struct {
    content: []const u8,
    alignment: alignment_t,
};

fn invalid_choice() !void {
    try clear_screen();
    try stdout_writer.print("Invalid choice, please try again.\n", .{});
}

fn choice_add() !void {
    try clear_screen();
    try stdout_writer.print("Adding Film\n", .{});
}

fn choice_edit() !void {
    try clear_screen();
    try stdout_writer.print("Editing Film\n", .{});
}

fn choice_remove() !void {
    try clear_screen();
    try stdout_writer.print("Removing Film\n", .{});
}

fn choice_search() !void {
    try clear_screen();
    try stdout_writer.print("Searching for a Film\n", .{});
}

fn choice_view() !void {
    try clear_screen();
    try stdout_writer.print("Viewing Films\n", .{});
}

fn choice_help() !void {
    try clear_screen();
    try stdout_writer.print("Help Menu\n", .{});
}

fn choice_exit() !void {
    try clear_screen();
    try stdout_writer.print("Exiting\n", .{});
}

fn handle_choice(choice: u32) !void {
    try switch (choice) {
        1 => try choice_add(),
        2 => try choice_edit(),
        3 => try choice_remove(),
        4 => try choice_search(),
        5 => try choice_view(),
        9 => try choice_help(),
        0 => try choice_exit(),
        else => try invalid_choice(),
    };
}

fn run_cmd(command: []const u8) ![]u8 {
    var arena_alloc = arena.init(pageAllocator);
    defer arena_alloc.deinit();

    const alloc = arena_alloc.allocator();
    var child = Child.init(command, alloc);
    child.stdout_behavior = .Pipe;
    child.stderr_behavior = .Pipe;

    var stdout_arr = ArrayList(u8).init(alloc);
    var stderr_arr = ArrayList(u8).init(alloc);
    defer {
        stdout_arr.deinit();
        stderr_arr.deinit();
    }

    try child.spawn();
    try child.collectOutput(&stdout_arr, &stderr_arr, 1024);
    const term = try child.wait();
    try expectEqual(term.Exited, 0);
    try expectEqualStrings("", stderr_arr.items);

    return stdout_arr.items;
}

fn clear_screen() !void {
    switch (current_os) {
        .windows => try run_cmd("cls"),
        else => try stdout_writer.print("\x1b[2J\x1b[H", .{}),
    }
}

fn split_string_at_len(input: []const u8, max_len: usize) ![]const []const u8 {
    var start: usize = 0;

    var parts = ArrayList([]const u8).init(pageAllocator);
    defer parts.deinit();

    while (start < input.len) {
        const end = @min(start + max_len, input.len);
        try parts.append(input[start..end]);
        start = end;
    }

    return parts.toOwnedSlice();
}

fn print_box(lines: []const aligned_string) !void {
    const max_width = 76;

    try stdout_writer.print("/------------------------------------------------------------------------------\\\n", .{});

    for (lines) |line| {
        for (try split_string_at_len(line.content, max_width)) |part| {
            switch (line.alignment) {
                alignment_t.left => try stdout_writer.print("| {s: <76} |\n", .{part}),
                alignment_t.center => try stdout_writer.print("|{s: ^78}|\n", .{part}),
                alignment_t.right => try stdout_writer.print("| {s: >76} |\n", .{part}),
            }
        }
    }

    try stdout_writer.print("\\------------------------------------------------------------------------------/\n", .{});
}

fn prompt(prompt_string: []const u8) ![]const u8 {
    var buffer = ArrayList(u8).init(pageAllocator);
    buffer.deinit();

    try stdout_writer.print("{s}", .{prompt_string});
    try stdin_reader.streamUntilDelimiter(buffer.writer(), '\n', null);
    return buffer.items;
}

fn can_parse_input(input: []const u8) !bool {
    const result = try parseInt(u4, input, 10);
    if (@TypeOf(result) == u4) {
        return true;
    }

    return false;
}

fn parse_input_as_u4(input: []const u8) !u4 {
    const parsed_value = try parseInt(u4, input, 0);

    if (parsed_value > 15) {
        return error.InvalidInput;
    }

    return parsed_value;
}

fn print_menu() !void {
    const lines = [_]aligned_string{
        aligned_string{ .content = "", .alignment = alignment_t.center },
        aligned_string{ .content = "Film library", .alignment = alignment_t.center },
        aligned_string{ .content = " ", .alignment = alignment_t.center },
        aligned_string{ .content = "This program was written in Zig", .alignment = alignment_t.center },
        aligned_string{ .content = "to help me test and learn the basics of the language", .alignment = alignment_t.center },
        aligned_string{ .content = " ", .alignment = alignment_t.center },
        aligned_string{ .content = "List of options:", .alignment = alignment_t.left },
        aligned_string{ .content = "    [1] - ADD FILM", .alignment = alignment_t.left },
        aligned_string{ .content = "    [2] - EDIT FILM", .alignment = alignment_t.left },
        aligned_string{ .content = "    [3] - REMOVE FILM", .alignment = alignment_t.left },
        aligned_string{ .content = "    [4] - SEARCH FILMS", .alignment = alignment_t.left },
        aligned_string{ .content = "    [5] - VIEW FILMS", .alignment = alignment_t.left },
        aligned_string{ .content = "    [9] - HELP", .alignment = alignment_t.left },
        aligned_string{ .content = "    [0] - EXIT", .alignment = alignment_t.left },
        aligned_string{ .content = " ", .alignment = alignment_t.center },
        aligned_string{ .content = "", .alignment = alignment_t.center },
    };

    try print_box(&lines);
    try stdout_writer.print("\n", .{});
}

fn menu() !void {
    var done = false;
    var parsed_input: u4 = undefined;

    try clear_screen();
    try print_menu();
    while (!done) {
        const input: []const u8 = try prompt("> ");
        if (try can_parse_input(input)) {
            parsed_input = try parse_input_as_u4(input);
            if (parsed_input == 0) {
                done = true;
            }
            try handle_choice(parsed_input);
        }

        if (parsed_input != 0) {
            try print_menu();
        }
    }
}

pub fn main() !void {
    try menu();
}
