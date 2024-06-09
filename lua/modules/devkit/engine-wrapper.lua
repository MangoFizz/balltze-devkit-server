-- SPDX-License-Identifier: GPL-3.0-only

local metaobject = require "devkit.metaobject"

local wrapper = {
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
            end
        end
    end
    return field
end

setmetatable(wrapper, wrapperMetatable)

Engine = wrapper
