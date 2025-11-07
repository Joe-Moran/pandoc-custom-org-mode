local Title = {}

function Title.create()
	local fileName = PANDOC_STATE.input_files[1]:match("([^/]+)%.md$")
	return pandoc.RawInline('org', "#+TITLE: " .. fileName)
end

return Title
