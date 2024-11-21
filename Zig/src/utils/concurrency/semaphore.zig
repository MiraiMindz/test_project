const Mutex = @import("std").Thread.Mutex;
const spawn = @import("std").Thread.spawn;
const SpawnConfig = @import("std").Thread.SpawnConfig;
const StdSemaphore = @import("std").Thread.Semaphore;
const Condition = @import("std").Thread.Condition;

pub fn Semaphore(conf: SpawnConfig, condition: Condition, mutex: Mutex, perms: usize) type {
    return struct {
        semaphore: StdSemaphore = .{
            .cond = condition,
            .mutex = mutex,
            .permits = perms,
        },

        config: SpawnConfig = conf,

        const Self = @This();

        pub fn run(self: *Self, function: anytype, params: anytype) !void {
            const thread = try spawn(self.config, Self.thread_func, .{self, function, params});
            thread.join();
        }

        fn thread_func(self: *Self, function: anytype, parameters: anytype) !void {
            self.semaphore.wait();
            defer self.semaphore.post();
            
            function(parameters);
        }

    };
}

