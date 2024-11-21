const arena = @import("std").heap.ArenaAllocator;
const pageAllocator = @import("std").heap.page_allocator;
const Child = @import("std").process.Child;
const ArrayList = @import("std").ArrayList;
const expectEqual = @import("std").testing.expectEqual;
const expectEqualStrings = @import("std").testing.expectEqualStrings;

pub fn run_cmd(command: []const u8) ![]u8 {
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
