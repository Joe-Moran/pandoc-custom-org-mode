local Header = {}

local function kebabToCamelCase(str)
	return str:gsub("%-(%w)", function(match)
		return match:upper()
	end)
end

local function createTags(tags)
	local tagStr = ":"
	for _, tag in pairs(tags) do
		local tagText = pandoc.utils.stringify(tag)
		tagText = kebabToCamelCase(tagText)
		tagStr = tagStr .. tagText .. ":"
	end
	return tagStr
end

function Header.create(tags)
	local fileName = PANDOC_STATE.input_files[1]:match("([^/]+)%.md$")
	return pandoc.Header(1, pandoc.Str(fileName .. " " .. createTags(tags)))
end

return Header
