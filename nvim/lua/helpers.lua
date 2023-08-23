Helpers = {}

Helpers.file_exists = function(path)
	local file = io.open(path, "rb")
	if file then file:close() end
	return file ~= nil
end

Helpers.string_starts_with = function(a, b)
	return string.sub(a, 1, #b) == b
end

