local PropertyDrawer = {}

local function kebabify(str)
	str = str:lower()
	str = str:gsub("%s+", "-")
	str = str:gsub("[^%w%-]", "")
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
	for name, value in pairs(frontmatter) do
		if (name == "tags") then goto continue end
		propertiesDrawer = propertiesDrawer ..
			":" .. kebabify(name) .. ": " .. formatMetadataValueToString(value) .. "\n"
		::continue::
	end
	propertiesDrawer = propertiesDrawer .. ":END:\n"
	return propertiesDrawer
end

return PropertyDrawer
