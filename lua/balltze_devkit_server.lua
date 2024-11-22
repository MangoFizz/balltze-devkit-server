-- SPDX-License-Identifier: GPL-3.0-only
local tango = require "tango"
local luna = require "luna"

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
    Logger = Balltze.logger.createLogger("devkit")
    return true
end

---@type BalltzeTickEventCallback
local function tickEvent(event)
    if (event.time == "before") then
        tango.server.copas_socket.step()
    end
end

local commands = {
    debug = {
        description = "Enable or disable Devkit debug mode",
        help = "<boolean>",
        execute = function(enable)
            DebugMode = luna.bool(enable)
            Engine.core.consolePrint("Debug mode: " .. tostring(DebugMode))
        end
    }
}

function PluginLoad()
    Logger:info("Loading DevKit Server...")
    tango.server.copas_socket.init {
        port = 19190,
        functab = {engine = EngineWrapper, devkit = Devkit, print = print}
    }
    Balltze.event.tick.subscribe(tickEvent)
    Logger:info("Listening on localhost:19190")

    for command, data in pairs(commands) do
        Balltze.command.registerCommand(command, command, data.description, data.help, false,
                                        data.minArgs or 0, data.maxArgs or 0, false, true,
                                        function(...)
            local success, result = pcall(data.execute, table.unpack(...))
            if not success then
                Logger:error("Error executing command '{}': {}", command, result)
                return false
            end
            return true
        end)
    end
end

function PluginUnload()
    Logger:info("Unloading DevKit Server...")
end
