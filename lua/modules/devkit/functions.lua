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
        if tag then
            local class = metaobject.enumUserdataToString(tag.primaryClass)
            table.insert(tagList, { path = tag.path, handle = tag.handle.value, class = class})
        end
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
            local tag = Engine.tag.getTag(object.tagHandle)
            if addSignToIndex(object.nameListIndex) ~= -1 then
                scenarioObjectName = table.find(objectNames.elements, function (v, k) return k == object.nameListIndex + 1 end)
            end
            table.insert(objects, { 
                index = i, 
                tagHandle = object.tagHandle.value, 
                tagPath = tag.path,
                objectType = metaobject.enumUserdataToString(object.type), 
                parentIndex = addSignToIndex(object.parentObject.index),
                name = scenarioObjectName.name
            })
        end
    end
    return objects
end

function Devkit.pathForTag(tagHandle)
    local tag = Engine.tag.getTag(tagHandle)
    if tag ~= nil then
        return tag.path
    end
    return nil
end

function Devkit.updateTag(tagHandle, data)
    local tag = Engine.tag.getTag(tagHandle)
    if not tag then
        return
    end
    local apply 
    apply = function (currentObject, currentObjectData) 
        for k, v in pairs(currentObjectData) do
            if type(v) == "table" then
                local i = tonumber(k)
                if i then
                    apply(currentObject[i], v)
                else
                    apply(currentObject[k], v)
                end
            elseif type(v) == "boolean" then
                currentObject[k](currentObject, v)
            else
                currentObject[k] = v
            end
        end
    end
    apply(tag.data, data)
end
