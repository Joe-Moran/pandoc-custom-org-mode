package.path = package.path .. ";/Users/joemoran/Notes/dev/scripts/pandoc/?.lua"

local pandoc = require("pandoc")
local PropertyDrawer = require("property-drawer")
local Title = require("title")
local MyCodeBlock = require("code-block")
local FileTags = require("tags")
local Alias = require("alias")
local frontmatter = {}


local function getFrontmatter(meta)
  frontmatter = meta
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

-- Decrease header levels by 1 to allow for a new top-level header to be generated
function Header(elem)
  elem.level = elem.level == 1 and elem.level or elem.level - 1

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
  table.insert(doc.blocks, 1, PropertyDrawer.create(frontmatter))
  table.insert(doc.blocks, 2, FileTags.create(frontmatter.tags))
  table.insert(doc.blocks, 3, Title.create())

  return doc
end
