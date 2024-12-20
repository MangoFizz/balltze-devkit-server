-- SPDX-License-Identifier: GPL-3.0-only

local metaobject = require "devkit.metaobject"

EngineWrapper = {
    _table = Engine
}

local wrapperMetatable = {}

wrapperMetatable.__index = function(object, key)
    local field = object._table[key]
    local t = type(field)
    if t == "table" then
        local tableWrapper = {
            _table = field
        }
        setmetatable(tableWrapper, wrapperMetatable)
        return tableWrapper
    elseif t == "function" then
        return function(...)
            local result = field(...)
            local t = type(result)
            if t == "userdata" then
                return metaobject.dumpMetaObject(result)
            elseif t == "table" and #result > 0 then
                for index, value in ipairs(result) do
                    local t = type(value)
                    if t == "userdata" then
                        result[index] = metaobject.dumpMetaObject(value)
                    end
                end
            end
            return result
        end
    end
    return field
end

setmetatable(EngineWrapper, wrapperMetatable)
