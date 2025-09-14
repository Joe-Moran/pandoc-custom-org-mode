local pandoc = require("pandoc")

local frontmatter = {}
local tags = {}
local lastWasDataview = false

local function createTags()
  local tagStr = ":"
  for _, tag in pairs(tags) do
    tagStr = tagStr .. pandoc.utils.stringify(tag) .. ":"
  end
  return tagStr
end

local function getFrontmatter(meta)
  frontmatter = meta
  if meta.tags then
    tags = meta.tags
  end
end

local function removeDataView(code)
  for _, class in ipairs(code.classes) do
    if class == "dataviewjs" then
      lastWasDataview = true
      return pandoc.Para("")
    end
  end
  lastWasDataview = false

  return code
end

local function formatMetadataValueToString(value)
  if type(value) == "table" then
    -- Handle pandoc MetaValue objects
    return pandoc.utils.stringify(value)
  else
    return tostring(value)
  end
end

local function kebabify(str)
  str = str:lower()
  str = str:gsub("%s+", "-")
  str = str:gsub("[^%w%-]", "")
  return str
end

local function createPropertyDrawer()
  local propertiesDrawer = ":PROPERTIES:\n"
  for name, value in pairs(frontmatter) do
    if (name == "tags") then goto continue end
    propertiesDrawer = propertiesDrawer .. ":" .. kebabify(name) .. ": " .. formatMetadataValueToString(value) .. "\n"
    ::continue::
  end
  propertiesDrawer = propertiesDrawer .. ":END:\n"
  return propertiesDrawer
end

local function createHeader()
  local fileName = PANDOC_STATE.input_files[1]:match("([^/]+)%.md$")
  return pandoc.Header(1, pandoc.Str(fileName .. " " .. createTags()))
end

function CodeBlock(block)
  return removeDataView(block)
end

function HorizontalRule()
  if lastWasDataview then
    lastWasDataview = false
    return pandoc.Para("")
  end
  lastWasDataview = false
  return pandoc.HorizontalRule()
end

function Pandoc(doc)
  doc:walk { Meta = getFrontmatter }
  local propDrawer = pandoc.Para({ pandoc.Str(createPropertyDrawer()) })
  table.insert(doc.blocks, 1, createHeader())
  table.insert(doc.blocks, 2, propDrawer)

  return doc
end
