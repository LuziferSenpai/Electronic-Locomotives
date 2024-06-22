local util = require("__core__/lualib/util")

function util.round(number, decimals)
    local multiplier = 10 ^ decimals

    return math.floor(number * multiplier + 0.5) / multiplier
end

return util