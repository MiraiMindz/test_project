pub const CommandType = enum {
    AddEntry,
    EditEntry,
    RemoveEntry,
    SearchEntry,
    ViewEntries,
    Exit,
};

pub const Command = struct {
    cmd_type: CommandType,
    payload: ?[]const usize,
};
