const Thread = @import("std").Thread;
const Mutex = @import("std").Thread.Mutex;
const spawn = @import("std").Thread.spawn;
const SpawnConfig = @import("std").Thread.SpawnConfig;
const Condition = @import("std").Thread.Condition;
const Handle = @import("std").Thread.Handle;

pub const Worker = struct {
    thread: ?Handle,
    mutex: Mutex,
    cond: Condition,
    ready: bool,
    config: SpawnConfig,

    const Self = @This();

    pub fn create(conf: SpawnConfig, func: anytype, args: anytype) Self {
        var w = Worker{
            .thread = null,
            .mutex = Mutex{},
            .cond = Condition{},
            .ready = false,
            .config = conf,
        };

        w.thread = spawn(conf, worker, .{ func, args }) catch unreachable;
        return w;
    }

    fn worker(self: *Self, func: anytype, args: anytype) void {
        self.mutex.lock();
        defer self.mutex.unlock();

        while (!self.ready) {
            self.cond.wait(&self.mutex);
        }
        
        func(args);
    }

    pub fn signal(self: *Self) void {
        self.mutex.lock();
        defer self.mutex.unlock();

        self.ready = true;
        self.cond.signal();
    }

    pub fn join(self: *Self) !void {
        try self.thread.join();
    }
};
