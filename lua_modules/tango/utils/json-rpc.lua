
local json = require "json"
local inspect = require "inspect"
local luna = require "luna"

local function encode(data, id)
    local ok, result = data[1], data[2]
    if not ok then
        result = {
            code = -32000,
            message = result
        }
    else 
        if #result == 1 then
            result = result[1]
        end
    end
    
    return json.encode({
        jsonrpc = "2.0",
        result = result,
        id = id
    }) .. "\n"
end

local function decode(data)
    local decodedJson = json.decode(data)
    local output = { decodedJson.method, table.unpack(decodedJson.params) }
    return tostring(inspect(output)), decodedJson.id
end

return {
    encode = encode,
    decode = decode
}
