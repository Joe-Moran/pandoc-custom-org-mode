package.path = package.path .. ";/Users/joemoran/Notes/dev/scripts/pandoc/?.lua"

local pandoc = require("pandoc")
local PropertyDrawer = require("property-drawer")
local MyHeader = require("header")
local MyCodeBlock = require("code-block")

local frontmatter = {}
local tags = {}


local function getFrontmatter(meta)
  frontmatter = meta
  if meta.tags then
    tags = meta.tags
  end
end

function CodeBlock(block)
  return MyCodeBlock.remove(block, "dataviewjs")
end

function HorizontalRule()
  if MyCodeBlock.wasRemoved then
    MyCodeBlock.wasRemoved = false
    return pandoc.Para("")
  end
  MyCodeBlock.wasRemoved = false
  return pandoc.HorizontalRule()
end

-- Increase header levels by 1 to allow for a new top-level header to be generated
function Header(elem)
  return elem
end

function Link(elem)
  if elem.target:match("%%20") then
    elem.target = elem.target:gsub("%%20", " ")
  end
  if elem.target:match("zotero") then
    elem.target = elem.target:gsub("zotero", "shell:open zotero")
  end
  return elem
end

 function Code(el)
    -- Return org-mode inline code format using tildes
    return pandoc.RawInline('org', '~' .. el.text .. '~')
  end

function Pandoc(doc)
  doc:walk { Meta = getFrontmatter }
  local propDrawer = pandoc.Para({ pandoc.Str(PropertyDrawer.create(frontmatter)) })
  table.insert(doc.blocks, 1, MyHeader.create(tags))
  table.insert(doc.blocks, 2, propDrawer)

  return doc
end
