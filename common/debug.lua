local Inspect = require 'inspect'

local NONE = 0
local ERROR = 1
local WARNING = 2
local INFO = 3
local DEBUG = 4
local DEBUG_LEVEL = DEBUG

local Debug = {}

function print(text)
    if type(text) == "string" then
        game.print(text)
    else
        game.print(Inspect(text))
    end
end

function Debug.logd(text)
    if DEBUG_LEVEL >= DEBUG then
        print(text)
    end
end

function Debug.logi(text)
    if DEBUG_LEVEL >= INFO then
        print(text)
    end
end

function Debug.logw(text)
    if DEBUG_LEVEL >= WARNING then
        print(text)
    end
end

function Debug.loge(text)
    if DEBUG_LEVEL >= ERROR then
        print(text)
    end
end

return Debug