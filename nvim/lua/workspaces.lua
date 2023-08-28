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
        vim.fn.system({"cp", Consts.WORKSPACE_CONFIG_TEMPLATE_FILE, workspace_config_file})
        load_config_file(workspace_config_file)
    end

    -- set a fun title :)
    vim.opt.title = true
    local indicator = Consts.WORKSPACE_INDICATORS[Helpers.random_num(#Consts.WORKSPACE_INDICATORS)]
    vim.opt.titlestring = indicator .. " wksp: " .. workspace_name

    -- setup the layout
    vim.cmd("NERDTree")
    vim.cmd("wincmd p")
    vim.cmd("enew")
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

            table.sort(res)
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

Workspace.run_command = function(cmd_alias)
    if Workspace.context.opts.cmds[cmd_alias] ~= nil then
        Workspace.context["_last_executed_command"] = cmd_alias
        local cmd = Workspace.context.opts.cmds[cmd_alias]
        vim.cmd("Dispatch " .. cmd)
    else
        print("command \"" .. cmd_alias .. "\" not defined")
    end
end

Workspace.run_last_command = function()
    local cmd_alias = Workspace.context["_last_executed_command"]
    if cmd_alias ~= nil then
        Workspace.run_command(cmd_alias)
    else
        print("no commands run recently")
    end
end

-- command to run a workspace command alias
vim.api.nvim_create_user_command("WorkspaceCmd",
    function(opt)
        if Workspace.context["_workspace_name"] == nil then
            print("no workspace currently selected")
            return
        end

        local cmd_alias = opt.args
        Workspace.run_command(cmd_alias)
    end,
    {
        nargs = 1,
        complete = function(lead, _, _)
            local res = {}

            if Workspace.context.opts == nil then
                return res
            end

            local lead_lower = string.lower(lead)
            for k, _ in pairs(Workspace.context.opts.cmds) do
                local cmd_alias_lower = string.lower(k)
                if Helpers.string_starts_with(cmd_alias_lower, lead_lower) then
                    res[#res + 1] = k
                end
            end

            table.sort(res)
            return res
        end,
    }
)

local popup = require("plenary.popup")
local commands_popup_id = nil
-- opens a popup with the current workspace's commands
Workspace.open_commands_popup = function()
    if Workspace.context["_workspace_name"] == nil then
        print("no workspace currently selected")
        return
    end

    -- get list of commands
    local commands = {}
    for k, _ in pairs(Workspace.context.opts.cmds) do
        commands[#commands + 1] = k
    end
    table.sort(commands)

    -- function to be called on selection of an option
    local callback = function(_, selection)
        -- at this point the popup will already be closed
        Workspace.run_command(selection)
        commands_popup_id = nil
    end

    local width = 50
    local height = 20
    local opts = {
        title       = Workspace.context["_workspace_name"] .. " commands",
        line        = math.floor(((vim.o.lines - height) / 2) - 1),
        col         = math.floor((vim.o.columns - width) / 2),
        minwidth    = width,
        minheight   = height,
        callback    = callback,
        border      = {},
    }
    -- open the popup
    commands_popup_id = popup.create(commands, opts)

    -- some extra config for the popup
    local buf = vim.api.nvim_win_get_buf(commands_popup_id)
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>lua Workspace.close_commands_popup()<cr>", { silent = false })
    vim.opt_local.modifiable = false
end

Workspace.close_commands_popup = function()
    vim.api.nvim_win_close(commands_popup_id, true)
    commands_popup_id = nil
end

