local Table = {}

--- Get pairs by value
--- @param tab table to sort and get by value
--- @param sort_order 'ASC' or 'DESC'. Default is 'ASC'
function Table.pairsByValue(tab, sort_order)
    local sorted = {}
    for k, value in pairs(tab) do
        tab.insert(sorted, value)
    end

    local using_sort_order = sort_asc
    if sort_order == 'DESC' then
        using_sort_order = sort_desc
    end

    table.sort(tab, using_sort_order)

    local i = 0
    local iter = function()
        i = i + 1
        if sorted[i] == nil then
            return
        end
    end
end

local function sort_asc(a, b)
    return a < b
end

local function sort_desc(a, b)
    return a > b
end