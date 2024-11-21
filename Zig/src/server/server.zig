const stdout_writer = @import("std").io.getStdOut().writer();
const CommandType = @import("../utils/rpc.zig").CommandType;


pub const Database = struct {
    path: []u8,
    pub fn query() !void {
        try stdout_writer.print("DB Query\n", .{});
    }
};

pub const Server = struct {
    database_path: Database,

    pub fn add_entry() !void {
        try stdout_writer.print("Adding Entry\n", .{});
    }

    pub fn edit_entry() !void {
        try stdout_writer.print("Adding Entry\n", .{});
    }

    pub fn remove_entry() !void {
        try stdout_writer.print("Adding Entry\n", .{});
    }

    pub fn search_entry() !void {
        try stdout_writer.print("Adding Entry\n", .{});
    }

    pub fn view_entries() !void {
        try stdout_writer.print("Adding Entry\n", .{});
    }
};

pub fn ServerThread(cmd_channel: anytype, resp_channel: anytype) !void {
    while (true) {
        const command = cmd_channel.recv();

        // Process the command
        switch (command.cmd_type) {
            CommandType.AddEntry => {
                try stdout_writer.print("Server: Adding entry...\n", .{});
                resp_channel.send("AddEntry completed!");
            },
            CommandType.EditEntry => {
                try stdout_writer.print("Server: Editing entry...\n", .{});
                resp_channel.send("EditEntry completed!");
            },
            CommandType.RemoveEntry => {
                try stdout_writer.print("Server: Removing entry...\n", .{});
                resp_channel.send("RemoveEntry completed!");
            },
            CommandType.SearchEntry => {
                try stdout_writer.print("Server: Searching entries...\n", .{});
                resp_channel.send("SearchEntry completed!");
            },
            CommandType.ViewEntries => {
                try stdout_writer.print("Server: Viewing entries...\n", .{});
                resp_channel.send("ViewEntries completed!");
            },
            CommandType.Exit => {
                try stdout_writer.print("Server: Exiting...\n", .{});
                break;
            },
        }
    }
}
