local frontmatter = {}
local tags = {}

local function createTags()
  local tagStr = ":"
    for _, tag in pairs(tags) do
       tagStr = tagStr ..  pandoc.utils.stringify(tag) .. ":"
    end
      return tagStr

end

local function getFrontmatter(meta)
    frontmatter = meta
    if meta.tags then
        tags = meta.tags
    end
end

local function formatMetadataValueToString(value)
    if type(value) == "table" then
        -- Handle pandoc MetaValue objects
        return pandoc.utils.stringify(value)
    else
        return tostring(value)
    end
end

local function createPropertyDrawer()
    local propertiesDrawer = ":PROPERTIES:\n"
    for name, value in pairs(frontmatter) do
      if( name == "tags") then goto continue end
        local valueStr = formatMetadataValueToString(value)
        propertiesDrawer = propertiesDrawer .. ":" .. name .. ": " .. valueStr .. "\n"
        ::continue::
     end
     propertiesDrawer = propertiesDrawer .. ":END:\n"
     return propertiesDrawer
end

function Pandoc(doc)
  doc:walk { Meta = getFrontmatter }
  local propDrawerPara = pandoc.Para({pandoc.Str(createPropertyDrawer())})
  table.insert(doc.blocks, 1, propDrawerPara)
  table.insert(doc.blocks, 2, pandoc.Str(createTags()))

  return doc
end
