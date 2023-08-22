function get_workspace_files()
	function readall(filename)
		local fh = assert(io.open(filename, "rb"))
		local contents = assert(fh:read(_VERSION <= "Lua 5.2" and "*a" or "a"))
		fh:close()
		return contents
	end

	local available_workspace = {}
	local workspace_path = Consts.WORKSPACE_FILE
	if (Helpers.file_exists(workspace_path)) then
		local data = readall(workspace_path)
		for line in data:gmatch "[^\n]+" do
			local val = string.find(line, "=")
			if (val ~= nil) then
				project_name = string.sub(line, 0, val - 1):gsub("%s+", "")
				project_path = vim.fn.expand(string.sub(line, val + 1):gsub("%s+", ""))
				available_workspace[project_name] = project_path
			end
		end
	end
	return available_workspace
end

workspace_context = {}
function workspace_setup(opts)
	if opts ~= nil then
		workspace_context = opts
	end
end

function open_workspace(target_workspace)
	if (target_workspace == nil) then
		print("Workspace name required")
		return
	end

	vim.cmd("cd " .. target_workspace)
	vim.cmd("Ex " .. target_workspace)

	local workspace_lua = target_workspace .. "/workspace.lua"

	workspace_context = {}
	if Helpers.file_exists(workspace_lua) then
		vim.cmd("so " .. workspace_lua)
	end
	workspace_context["_workspace_dir"] = target_workspace
end

-- command to open workspace
vim.api.nvim_create_user_command("Workspace",
	function(opt)
		target_workspace = get_workspace_files()[opt.args]
		open_workspace(target_workspace)
	end,
	{
		nargs = 1,
		complete = function(_, _, _)
			local res = {}
			for k, _ in pairs(get_workspace_files()) do
				res[#res + 1] = k
			end
			return res
		end,
	}
)

-- command to open file with all workspaces listed
vim.api.nvim_create_user_command("WorkspacePaths",
	function(opt)
		vim.cmd("e " .. Consts.WORKSPACE_FILE)
	end,
	{ nargs = 0, }
)
