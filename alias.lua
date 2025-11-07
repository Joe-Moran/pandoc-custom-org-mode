local Alias = {}

function Alias.create(aliasList)
	if #aliasList == 0 then
		return ""
	end
	-- howm.el backlink format
	local aliasDelimiter = pandoc.utils.stringify("<<<")
	local result = ""
	for _, alias in ipairs(aliasList) do
		local aliasText = pandoc.utils.stringify(alias)
		result = result .. " " .. aliasDelimiter .. " " .. aliasText
	end
	return pandoc.Str(result)
end

return Alias
