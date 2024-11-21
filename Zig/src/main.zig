const Channel = @import("./utils/concurrency/channels.zig").Channel;
const ServerThread = @import("./server/server.zig").ServerThread;
const TUIThread = @import("./sessions/tui.zig").TUIThread;
const Command = @import("./utils/rpc.zig").Command;
const Thread = @import("std").Thread;

pub fn main() !void {
    var cmd_buffer: [10]Command = undefined;
    var resp_buffer: [10][]const u8 = undefined;

    var cmd_channel: Channel(Command) = undefined;
    var resp_channel: Channel([]const u8) = undefined;

    cmd_channel.init(&cmd_buffer);
    resp_channel.init(&resp_buffer);

    defer cmd_channel.deinit();
    defer resp_channel.deinit();

    const server_thread = try Thread.spawn(.{}, ServerThread, .{&cmd_channel, &resp_channel});
    const tui_thread = try Thread.spawn(.{}, TUIThread, .{&cmd_channel, &resp_channel});

    tui_thread.join();
    server_thread.join();
}
