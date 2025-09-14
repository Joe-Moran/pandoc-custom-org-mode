local CodeBlock = {}

CodeBlock.wasRemoved = false

function CodeBlock.remove(code, typeToRemove)
	for _, class in ipairs(code.classes) do
		if class == typeToRemove then
			CodeBlock.wasRemoved = true
			return pandoc.Para("")
		end
	end
	CodeBlock.wasRemoved = false

	return code
end

return CodeBlock
