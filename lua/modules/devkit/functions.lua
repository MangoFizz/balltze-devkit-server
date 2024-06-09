-- SPDX-License-Identifier: GPL-3.0-only

Devkit = {}

function Devkit.getTagList()
    local tagCount = Engine.tag.getTagDataHeader().tagCount
    local tagList = {}
    for i = 0, tagCount - 1 do
        local tag = Engine.tag.getTag(i)
        local class = tostring(tag.primaryClass):gsub("%b()", ""):lower()
        table.insert(tagList, { path = tag.path, handle = tag.handle.value, class = class})
    end
    return tagList
end
