const Mutex = @import("std").Thread.Mutex;

pub fn SharedData(comptime T: type, mutex_value: Mutex) type {
    return struct {
        value: T,
        mutex: Mutex = mutex_value,

        const Self = @This();

        pub fn update_value(self: *Self, update_function: fn(T) T) void {
            self.mutex.lock();
            defer self.mutex.unlock();
            self.value = update_function(self.value);
        }

        pub fn try_update_value(self: *Self, update_function: fn(T) T) bool {
            if (!self.mutex.tryLock()) {
                return false;
            }

            defer self.mutex.unlock();
            self.value = update_function(self.value);

            return true;
        }
    };
}

