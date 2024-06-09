
local json = require "json"
local inspect = require "inspect"
local luna = require "luna"

local function encode(data, id)
    local result = json.decode(data:replace("{", "["):replace("}", "]"))
    if #result == 1 then
        result = result[1]
    end
    local encodedJson = {
        jsonrpc = "2.0",
        result = result,
        id = id
    }
    return json.encode(encodedJson)
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
