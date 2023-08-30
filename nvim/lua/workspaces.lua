-- workspaces config --
--
-- probably the key part of my neovim config that i use day to day at work. it's just a dumb,
-- easily extensible way to set up your neovim instance to have per-project configs.
--
-- requirements --
-- you will need to have the following plugins installed for workspaces to work:
-- - preservim/nerdtree
-- - tpope/vim-dispatch
-- - nvim-lua/plenary.nvim
--
-- api --
-- there is a global `Workspace` table that contains all the related functions and context
-- for workspace management among other things.
--
-- `Workspace.get_workspace_files()`
-- returns a table containing a parsed list of available workspaces. key is the workspace name,
-- value is the workspace path.
--
-- `Workspace.set_target(target_name)`
-- sets the current target for the workspace and caches the commands for that target
--
-- `Workspace.setup(opts)`
-- called by the workspace config. loads opts into the current workspace context and sets
-- a default target for the workspace (if available).
--
-- `Workspace.open(workspace_dir, workspace_name)`
-- cds into the provided workspace's directory and initialises your setup.
--
-- `Workspace.get_command_list()`
-- get a table of commands currently available to run. key is command alias, value is command
-- to execute
--
-- `Workspace.run_command(cmd_alias)`
-- runs the given command alias for the current workspace
--
-- `Workspace.run_last_command()`
-- runs the last command that was called with `Worksapce.run_command()`
--
-- `Workspace.open_commands_popup()`
-- opens a floating popup with the current workspace's commands. press enter on a command
-- to run it.
--
-- `Workspace.open_targets_popup()`
-- opens a floating popup with the current workspace's targets. press enter on a target
-- to set it.
--
-- `Workspace.close_popup()`
-- closes any active popup.
--
-- `Workspace.context`
-- table that contains all the necessary context for the current open workspace.
--
-- `Workspace.context.target_cmds`
-- the current available commands for a target (if a target is set)
--
-- `Workspace.context.opts`
-- table that contains the opts passed through to `Workspace.setup()`.
--
-- `Workspace.context["_workspace_dir"]`
-- the current workspace directory
--
-- `Workspace.context["_workspace_name"]`
-- the current workspace name
--
-- `Workspace.context["_workspace_config"]`
-- path to the current workspace's config
--
-- `Workspace.context["_current_target"]`
-- the current target for the workspace (if there is one). read the comments in the
-- workspace config template for more info on targets.
--
-- commands --
-- `:Workspace <workspace_name>`
-- open a defined workspace, stored in `Consts.WORKSPACES_FILE`
--
-- `:WorkspacePaths`
-- open the file at `Consts.WORKSPACES_FILE`
--
-- `:WorkspaceConfig`
-- open the config file for a given workspace
--
-- `:WorkspaceCmd <command_alias>`
-- execute a workspace command, as defined in the workspace's config file
--
-- config --
-- running `:WorkspacePaths` will open `Consts.WORKSPACES_FILE`, allowing you to define the paths
-- to workspaces. workspaces are defined on a new line with the string `<workspace_name>=<path_to_workspace>`.
--
-- for each workspace there will be a config which is a simple lua file. it will either be located
-- at the root of the workspace as `workspace.lua`, or in `Consts.WORKSPACE_CONFIG_DIR`
-- as `<workspace_name>.lua`. this config should be based off the template config
-- `workspace_config_template.lua`. read the comments in that file to understand how to configure
-- your workspace.
--
-- if you have no config for your workspace currently, then a new config will be created by
-- copying the template over to `Consts.WORKSPACE_CONFIG_DIR` before being loaded.

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

Workspace.set_target = function(target_name)
    if Workspace.context.opts == nil then
        print("no active workspace")
        return
    elseif Workspace.context.opts.targets == nil then
        print("no targets configured for workspace '" .. Worksapce.context["_workspace_name"] .. "'")
        return
    end

    local has_target = false
    for _, value in ipairs(Workspace.context.opts.targets) do
        if value == target_name then
            has_target = true
            break
        end
    end

    if not has_target then
        print("no target '" .. target_name .. "' in workspace '" .. Worksapce.context["_workspace_name"] .. "'")
        return
    end

    Workspace.context["_current_target"] = target_name

    -- cache all available commands, interpolating the target name into the command string
    Workspace.context.target_cmds = {}
    for key, value in pairs(Workspace.context.opts.cmds) do
        local target_command = Helpers.string_replace(value, "<TARGET>", target_name)
        Workspace.context.target_cmds[key] = target_command
    end
end

Workspace.setup = function (opts)
    if opts == nil then
        return
    end

    Workspace.context.opts = opts
    -- optionally set default target
    if Workspace.context.opts.targets ~= nil and #Workspace.context.opts.targets > 0 then
        Workspace.set_target(Workspace.context.opts.targets[1])
    end
end

Workspace.open = function (workspace_dir, workspace_name)
    if (workspace_dir == nil or workspace_name == nil) then
        print("workspace directory/name required")
        return
    end

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

    -- final setup, cd to the workspace and configure the layout
    vim.cmd("cd " .. workspace_dir)
    vim.cmd("NERDTree")
    vim.cmd("wincmd p")
    vim.cmd("enew")
end

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

vim.api.nvim_create_user_command("WorkspacePaths",
    function()
        vim.cmd("e " .. Consts.WORKSPACES_FILE)
    end,
    { nargs = 0, }
)

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

Workspace.get_command_list = function()
    if Workspace.context.target_cmds ~= nil then
        return Workspace.context.target_cmds
    else
        return Workspace.context.opts.cmds
    end
end

Workspace.run_command = function(cmd_alias)
    local available_cmds = Workspace.get_command_list()
    if available_cmds[cmd_alias] ~= nil then
        Workspace.context["_last_executed_command"] = cmd_alias
        local cmd = available_cmds[cmd_alias]
        vim.cmd("Dispatch " .. cmd)
    else
        print("could not find command \"" .. cmd_alias .. "\" in current available commands")
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
            local available_cmds = Workspace.get_command_list()
            for k, _ in pairs(available_cmds) do
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

vim.api.nvim_create_user_command("WorkspaceTarget",
    function(opt)
        Workspace.set_target(opt.args)
    end,
    {
        nargs = 1,
        complete = function(lead, _, _)
            local res = {}

            if Workspace.context.opts == nil then
                return res
            end

            local lead_lower = string.lower(lead)
            local available_targets = Workspace.context.opts.targets
            for _, value in ipairs(available_targets) do
                local target_name_lower = string.lower(value)
                if Helpers.string_starts_with(target_name_lower, lead_lower) then
                    res[#res + 1] = value
                end
            end

            table.sort(res)
            return res
        end
    }
)

local popup = require("plenary.popup")
local popup_id = nil
Workspace.open_commands_popup = function()
    if Workspace.context["_workspace_name"] == nil then
        print("no workspace currently selected")
        return
    end

    -- get list of commands
    local commands = {}
    local available_cmds = Workspace.get_command_list()
    for k, _ in pairs(available_cmds) do
        commands[#commands + 1] = k
    end
    table.sort(commands)

    -- function to be called on selection of an option
    local callback = function(_, selection)
        -- at this point the popup will already be closed
        Workspace.run_command(selection)
        popup_id = nil
    end

    local width = 50
    local height = 20
    local title = Workspace.context["_workspace_name"] .. " commands"
    if Workspace.context["_current_target"] ~= nil then
        title = title .. " (target '" .. Workspace.context["_current_target"] .. "')"
    end

    local opts = {
        title       = title,
        line        = math.floor(((vim.o.lines - height) / 2) - 1),
        col         = math.floor((vim.o.columns - width) / 2),
        minwidth    = width,
        minheight   = height,
        callback    = callback,
        border      = {},
    }
    -- open the popup
    popup_id = popup.create(commands, opts)

    -- some extra config for the popup
    local buf = vim.api.nvim_win_get_buf(popup_id)
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>lua Workspace.close_popup()<cr>", { silent = false })
    vim.opt_local.modifiable = false
end

Workspace.open_targets_popup = function()
    if Workspace.context["_workspace_name"] == nil then
        print("no workspace currently selected")
        return
    end

    -- get list of targets
    local targets = Workspace.context.opts.targets;
    table.sort(targets)

    -- function to be called on selection of an option
    local callback = function(_, selection)
        -- at this point the popup will already be closed
        Workspace.set_target(selection)
        popup_id = nil
    end

    local width = 50
    local height = 20
    local title = Workspace.context["_workspace_name"] .. " targets"

    local opts = {
        title       = title,
        line        = math.floor(((vim.o.lines - height) / 2) - 1),
        col         = math.floor((vim.o.columns - width) / 2),
        minwidth    = width,
        minheight   = height,
        callback    = callback,
        border      = {},
    }
    -- open the popup
    popup_id = popup.create(targets, opts)

    -- some extra config for the popup
    local buf = vim.api.nvim_win_get_buf(popup_id)
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>lua Workspace.close_popup()<cr>", { silent = false })
    vim.opt_local.modifiable = false
end

Workspace.close_popup = function()
    vim.api.nvim_win_close(popup_id, true)
    popup_id = nil
end

