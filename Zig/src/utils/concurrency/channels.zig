const std = @import("std");
const Thread = std.Thread;
const Mutex = Thread.Mutex;
const Condition = Thread.Condition;

pub fn Channel(comptime T: type) type {
    return struct {
        mutex: Mutex,
        not_empty: Condition,
        not_full: Condition,
        buffer: []T,
        start: usize,
        end: usize,
        count: usize,
        closed: bool,

        const Self = @This();

        pub fn init(self: *Self, buffer: []T) void {
            self.* = Self{
                .mutex = Mutex{},
                .not_empty = Condition{},
                .not_full = Condition{},
                .buffer = buffer,
                .start = 0,
                .end = 0,
                .count = 0,
                .closed = false,
            };
        }

        pub fn deinit(self: *Self) void {
            self.mutex.lock();
            defer self.mutex.unlock();

            self.not_empty.broadcast();
            self.not_full.broadcast();
            self.closed = true;
            self.buffer = undefined;
        }

        pub fn send(self: *Self, item: T) void {
            self.mutex.lock();
            defer self.mutex.unlock();

            while (self.count == self.buffer.len) {
                self.not_full.wait(&self.mutex);
            }

            self.buffer[self.end] = item;
            self.end = (self.end + 1) % self.buffer.len;
            self.count += 1;
            self.not_empty.signal();
        }

        pub fn recv(self: *Self) T {
            self.mutex.lock();
            defer self.mutex.unlock();

            while (self.count == 0) {
                self.not_empty.wait(&self.mutex);
            }

            const item = self.buffer[self.start];
            self.start = (self.start + 1) % self.buffer.len;
            self.count -= 1;
            self.not_full.signal();

            return item;
        }

        pub fn trySend(self: *Self, item: T) bool {
            self.mutex.lock();
            defer self.mutex.unlock();

            if (self.count == self.buffer.len) {
                return false;
            }

            self.buffer[self.end] = item;
            self.end = (self.end + 1) % self.buffer.len;
            self.count += 1;
            self.not_empty.signal();

            return true;
        }

        pub fn tryRecv(self: *Self) ?T {
            self.mutex.lock();
            defer self.mutex.unlock();

            if (self.count == 0) {
                return null;
            }

            const item = self.buffer[self.start];
            self.start = (self.start + 1) % self.buffer.len;
            self.count -= 1;
            self.not_full.signal();

            return item;
        }

        /// Check if the channel is closed.
        pub fn isClosed(self: *Self) bool {
            self.mutex.lock();
            defer self.mutex.unlock();

            return self.closed;
        }
    };
}

// Example Usage:
//
// const std = @import("std");
// const Channel = @import("channel").Channel;
// 
// fn producer(ch: anytype) void {
//     for (0..10) |i| {
//         std.debug.print("Producer: sending {}\n", .{i});
//         ch.send(i);
//     }
//     std.debug.print("Producer: finished\n", .{});
// }
// 
// fn consumer(ch: anytype) void {
//     for (0..10) |_| {
//         const value = ch.recv();
//         std.debug.print("Consumer: received {}\n", .{value});
//     }
//     std.debug.print("Consumer: finished\n", .{});
// }
// 
// pub fn main() !void {
//     // Create a buffer for the channel.
//     var buffer: [10]u32 = undefined;
//     var channel: Channel(u32) = undefined;
// 
//     // Initialize the channel with the buffer.
//     channel.init(buffer[0..]);
//     defer channel.deinit();
// 
//     // Start producer and consumer threads.
//     const producerThread = try std.Thread.spawn(.{}, producer, .{&channel});
//     const consumerThread = try std.Thread.spawn(.{}, consumer, .{&channel});
// 
//     // Wait for threads to finish.
//     try producerThread.join();
//     try consumerThread.join();
// 
//     std.debug.print("Main: done\n", .{});
// }
//
