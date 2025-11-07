local Tags = {}

local function kebabToCamelCase(str)
	return str:gsub("%-(%w)", function(match)
		return match:upper()
	end)
end

function Tags.create(tags)
	local tagStr = ":"
	for _, tag in pairs(tags) do
		local tagText = pandoc.utils.stringify(tag)
		tagText = kebabToCamelCase(tagText)
		tagStr = tagStr .. tagText .. ":"
	end
	return pandoc.RawInline('org', "#+FILETAGS: " .. tagStr)
end

return Tags
