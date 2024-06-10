-- SPDX-License-Identifier: GPL-3.0-only

Devkit = {}

local metaobject = require "devkit.metaobject"

local function addSignToIndex(value)
    if value == 65535 then
        return -1
    else
        return value
    end
end

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

function table.find(t, f)
    for k, v in pairs(t) do
        if f(v, k) then
            return v
        end
    end
end

function Devkit.getObjectList()
    local objects = {}
    local scenario = Engine.tag.getTag(0)
    assert(scenario ~= nil, "Scenario tag not found")
    ---@type MetaEngineTagDataScenario
    local scenarioData = scenario.data 
    local objectNames = scenarioData.objectNames

    for i = 0, 2047 do
        local object = Engine.gameState.getObject(i)
        if object ~= nil then
            local scenarioObjectName = {}
            if addSignToIndex(object.nameListIndex) ~= -1 then
                scenarioObjectName = table.find(objectNames.elements, function (v, k) return k == object.nameListIndex + 1 end)
            end
            table.insert(objects, { 
                index = i, 
                tagHandle = object.tagHandle.value, 
                objectType = metaobject.enumUserdataToString(object.type), 
                parentIndex = addSignToIndex(object.parentObject.index),
                name = scenarioObjectName.name
            })
        end
    end
    return objects
end
