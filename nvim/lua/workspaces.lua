Workspace = {}
Workspace.context = {}
vim.fn.mkdir(Consts.WORKSPACE_CONFIG_DIR, "p")

Workspace.get_workspace_files = function()
	local function readall(filename)
		local fh = assert(io.open(filename, "rb"))
		local contents = assert(fh:read(_VERSION <= "Lua 5.2" and "*a" or "a"))
		fh:close()
		return contents
	end

	local available_workspace = {}
	local workspace_path = Consts.WORKSPACES_FILE
	if (Helpers.file_exists(workspace_path)) then
		local data = readall(workspace_path)
		for line in data:gmatch "[^\n]+" do
			local val = string.find(line, "=")
			if (val ~= nil) then
				local project_name = string.sub(line, 0, val - 1):gsub("%s+", "")
				local project_path = vim.fn.expand(string.sub(line, val + 1):gsub("%s+", ""))
				available_workspace[project_name] = project_path
			end
		end
	end
	return available_workspace
end

Workspace.setup = function (opts)
	if opts ~= nil then
		Workspace.context.opts = opts
	end
end

Workspace.open = function (workspace_dir, workspace_name)
	if (workspace_dir == nil or workspace_name == nil) then
		print("workspace directory/name required")
		return
	end

	vim.cmd("cd " .. workspace_dir)
	vim.cmd("Ex " .. workspace_dir)

	Workspace.context = {}
	Workspace.context["_workspace_dir"] = workspace_dir
	Workspace.context["_workspace_name"] = workspace_name

	-- check for existence of workspace.lua file in the workspace dir
	local local_workspace_config_file = workspace_dir .. "/workspace.lua"
	local workspace_config_file = Consts.WORKSPACE_CONFIG_DIR .. "/" .. workspace_name .. ".lua"

	local function load_config_file(path)
		Workspace.context["_workspace_config"] = path
		vim.cmd("so " .. path)
	end

	if Helpers.file_exists(local_workspace_config_file) then -- config file in workspace
		load_config_file(local_workspace_config_file)
	elseif Helpers.file_exists(workspace_config_file) then -- config file in nvim data directory
		load_config_file(workspace_config_file)
	else -- no config file, copy template over and load it
		print("copying " .. Consts.WORKSPACE_CONFIG_TEMPLATE_FILE .. " to " .. workspace_config_file)
		local result = vim.fn.system({"cp", Consts.WORKSPACE_CONFIG_TEMPLATE_FILE, workspace_config_file})
		print("result? " .. result)
		load_config_file(workspace_config_file)
	end

	vim.opt.title = true
	local indicator = Consts.WORKSPACE_INDICATORS[Helpers.random_num(#Consts.WORKSPACE_INDICATORS)]
	vim.opt.titlestring = indicator .. " wksp: " .. workspace_name
end

-- command to open workspace
vim.api.nvim_create_user_command("Workspace",
	function(opt)
		local target_workspace = Workspace.get_workspace_files()[opt.args]
		Workspace.open(target_workspace, opt.args)
	end,
	{
		nargs = 1,
		complete = function(lead, _, _)
			local res = {}
			local lead_lower = string.lower(lead)
			-- autocomplete results for workspace name
			for k, _ in pairs(Workspace.get_workspace_files()) do
				local workspace_name = string.lower(k)
				if Helpers.string_starts_with(workspace_name, lead_lower) then
					res[#res + 1] = k
				end
			end
			return res
		end,
	}
)

-- command to open file with all workspaces listed
vim.api.nvim_create_user_command("WorkspacePaths",
	function()
		vim.cmd("e " .. Consts.WORKSPACES_FILE)
	end,
	{ nargs = 0, }
)

-- command to open file for current workspace config
vim.api.nvim_create_user_command("WorkspaceConfig",
	function()
		if Workspace.context["_workspace_name"] == nil then
			print("no workspace currently selected")
			return
		end

		vim.cmd("e " .. Workspace.context["_workspace_config"])
	end,
	{ nargs = 0, }
)

-- command to run a workspace command alias
vim.api.nvim_create_user_command("WorkspaceCmd",
	function(opt)
		if Workspace.context["_workspace_name"] == nil then
			print("no workspace currently selected")
			return
		end

		local cmd_alias = opt.args
		if Workspace.context.opts.cmds[cmd_alias] ~= nil then
			local cmd = Workspace.context.opts.cmds[cmd_alias]
			vim.cmd("Dispatch " .. cmd)
		else
			print("command \"" .. cmd_alias .. "\" not defined")
		end
	end,
	{
		nargs = 1,
		complete = function(lead, _, _)
			local res = {}

			local lead_lower = string.lower(lead)
			for k, _ in pairs(Workspace.context.opts.cmds) do
				local cmd_alias_lower = string.lower(k)
				if Helpers.string_starts_with(cmd_alias_lower, lead_lower) then
					res[#res + 1] = k
				end
			end

			return res
		end,
	}
)

