Helpers = {}

Helpers.file_exists = function(path)
    local file = io.open(path, "rb")
    if file then file:close() end
    return file ~= nil
end

Helpers.string_starts_with = function(a, b)
    return string.sub(a, 1, #b) == b
end

Helpers.random_num = function(max)
    if max == nil then
        print("max cannot be nil")
        return nil
    end

    math.randomseed(os.time())
    return math.random(max)
end

Helpers.string_replace = function(str, to_replace, replacement)

    local working_str = str
    local start_index, end_index = nil, nil

    repeat
        start_index, end_index = string.find(working_str, to_replace)
        if start_index ~= nil then
            local start_str = string.sub(working_str, 1, start_index - 1)
            local end_str = string.sub(working_str, end_index + 1, -1)
            working_str = start_str .. replacement .. end_str
        end
    until start_index == nil

    return working_str
end

