-- SPDX-License-Identifier: GPL-3.0-only

local function userdataIsEnum(value)
    local metatable = getmetatable(value)
    if metatable and metatable.__name == "luacenumval1" then
        return true
    end
    return false
end

local function enumUserdataToString(enum)
    return tostring(enum):gsub("%b()", "")
end

local function dumpMetaObject(value, limitElems)
    local output = {}
    local i = 1
    for k, v in pairs(value) do
        local t = type(v)
        if t == "userdata" or t == "table" then
            if userdataIsEnum(v) then
                output[k] = enumUserdataToString(v)
            else
                local count = nil
                if k == "elements" and value.count then
                    count = value.count
                end
                output[k] = dumpMetaObject(v, count)
            end
        elseif t == "function" then
            output[k] = "<function>"
        else
            output[k] = v
        end

        i = i + 1
        if limitElems and i > limitElems then
            break
        end
    end
    return output
end

return {
    userdataIsEnum = userdataIsEnum,
    enumUserdataToString = enumUserdataToString,
    dumpMetaObject = dumpMetaObject
}
