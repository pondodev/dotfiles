-- workspace config --
-- read the below comments to get a better idea of how to configure the specifics
-- of your workspace. this is of course also just a regular lua file, so
-- you can add extra binds and such as needed here. simply run `:so` from this
-- file to reload your config.

local workspace_dir = Workspace.context["_workspace_dir"]

local opts = {}

-- workspace commands, run in the set shell with :Dispatch
opts.cmds = {
    echo = "echo \"hello world!\"",
}

-- workspace targets. will interpolate the target name into the command,
-- replacing any instances of `<TARGET>`. will use first target by default
-- (if available)
opts.targets = {
    "default",
}

Workspace.setup(opts)
