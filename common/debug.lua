local NONE = 0
local ERROR = 1
local WARNING = 2
local INFO = 3
local DEBUG = 4
local DEBUG_LEVEL = DEBUG

function logd(text)
    if DEBUG_LEVEL >= DEBUG then
        game.print(text)
    end
end

function logi(text)
    if DEBUG_LEVEL >= INFO then
        game.print(text)
    end
end

function logw(text)
    if DEBUG_LEVEL >= WARNING then
        game.print(text)
    end
end

function loge(text)
    if DEBUG_LEVEL >= ERROR then
        game.print(text)
    end
end