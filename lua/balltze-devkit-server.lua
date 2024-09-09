-- SPDX-License-Identifier: GPL-3.0-only

local tango = require "tango"

require "devkit.engine-wrapper"
require "devkit.functions"

---@type Logger
Logger = {}

function PluginMetadata()
    return {
        name = "Balltze DevKit Server",
        author = "MangoFizz",
        version = "1.0.0",
        targetApi = "1.1.0",
        reloadable = true
    }
end

function PluginInit() 
    Logger = Balltze.logger.createLogger("Devkit")
    return true
end

---@type BalltzeTickEventCallback
local function tickEvent(event) 
    if(event.time == "before") then
        tango.server.copas_socket.step()
    end 
end

function PluginLoad() 
    Logger:info("Loading DevKit Server...")
    tango.server.copas_socket.init{ 
        port = 19190,
        functab = { 
            engine = EngineWrapper, 
            devkit = Devkit,
            print = print
        }
    }
    Balltze.event.tick.subscribe(tickEvent)
    Logger:info("Listening on localhost:19190")
end

function PluginUnload()
    Logger:info("Unloading DevKit Server...")
end
