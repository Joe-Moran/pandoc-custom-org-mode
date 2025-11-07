local PropertyDrawer = {}

local function snakify(str)
	local snake = "_"
	str = str:gsub("%s+", "_")
	str = str:gsub("[^%w%" .. snake .. "]", "")
	return str
end


local function formatMetadataValueToString(value)
	if type(value) == "table" then
		-- Handle pandoc MetaValue objects
		return pandoc.utils.stringify(value)
	else
		return tostring(value)
	end
end


function PropertyDrawer.create(frontmatter)
	local propertiesDrawer = ":PROPERTIES:\n"
	local skipNames = { tags = true, alias = true }

	for name, value in pairs(frontmatter) do
		if not skipNames[name] then
			propertiesDrawer = propertiesDrawer ..
				":" .. snakify(name:upper()) .. ": " .. formatMetadataValueToString(value) .. "\n"
		end
	end
	propertiesDrawer = propertiesDrawer .. ":END:"
	return pandoc.Str(propertiesDrawer)
end

return PropertyDrawer
