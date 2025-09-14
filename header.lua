local Header = {}
local function createTags(tags)
	local tagStr = ":"
	for _, tag in pairs(tags) do
		tagStr = tagStr .. pandoc.utils.stringify(tag) .. ":"
	end
	return tagStr
end

function Header.create(tags)
	local fileName = PANDOC_STATE.input_files[1]:match("([^/]+)%.md$")
	return pandoc.Header(1, pandoc.Str(fileName .. " " .. createTags(tags)))
end

return Header
