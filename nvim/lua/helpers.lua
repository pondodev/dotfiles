Helpers = {}

Helpers.file_exists = function(path)
	local file = io.open(path, "rb")
	if file then file:close() end
	return file ~= nil
end

