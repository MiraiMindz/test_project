const spawn = @import("std").Thread.spawn;
const SpawnConfig = @import("std").Thread.SpawnConfig;
const StdWaitGroup = @import("std").Thread.WaitGroup;

pub const WaitGroup = struct {
    wg: StdWaitGroup,
    config: SpawnConfig,

    const Self = @This();

    pub fn run(self: *Self, function: anytype, params: anytype) !void {
        self.wg.start();
        const thread = try spawn(self.config, Self.thread_func, .{self, function, params});
        thread.join();
    }

    fn thread_func(self: *Self, function: anytype, parameters: anytype) !void {
        function(parameters);
        self.wg.finish();
    }

    pub fn wait(self: *Self) void { self.wg.wait(); }
    pub fn reset(self: *Self) void { self.wg.reset(); }
};

