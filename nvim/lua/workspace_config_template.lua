local workspace_dir = Workspace.context["_workspace_dir"]

local opts = {}

-- workspace commands, run in the set shell with :Dispatch
opts.cmds = {
	echo = "echo \"hello world!\"",
}

Workspace.setup(opts)
