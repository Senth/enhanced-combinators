local Inspect = require 'inspect'

local NONE = 0
local ERROR = 1
local WARNING = 2
local INFO = 3
local DEBUG = 4
local DEBUG_LEVEL = DEBUG

local Debug = {}

local function print(text)
    if type(text) == "string" then
        game.print(text)
    else
        -- Localized string
        local printed = false
        if type(text) == "table" then
            local is_array_of_length_one = false
            for k, v in pairs(text) do
                if k == 1 then
                    is_array_of_length_one = true
                else
                    is_array_of_length_one = false
                    break
                end
            end

            if is_array_of_length_one and type(text[1]) == "string" then
                printed = true
                game.print(text)
            end
        end


        if not printed then
            game.print(Inspect(text))
        end
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