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

