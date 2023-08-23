Consts = {}

Consts.CONFIG_PATH = vim.fn.stdpath("config")
Consts.DATA_PATH = vim.fn.stdpath("data")
Consts.WORK_CONFIG_FILE = Consts.CONFIG_PATH .. "/lua/work_config.lua"
Consts.WORKSPACES_FILE = Consts.DATA_PATH .. "/workspaces.txt"
Consts.WORKSPACE_CONFIG_DIR = Consts.DATA_PATH .. "/workspace_config"
Consts.WORKSPACE_CONFIG_TEMPLATE_FILE = Consts.CONFIG_PATH .. "/lua/workspace_config_template.lua"
Consts.WORKSPACE_INDICATORS = { "👽", "🤠", "🐸", "🦈", "🔥", "🌈", "🍑", "🍆", "🔮", "💖", "‼️", "⁉️", "🏳️‍🌈", "🏳️‍⚧️" }

