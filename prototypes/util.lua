local util = require("__core__/lualib/util")
local modName = "__Electronic_Locomotives__"

function util.standardElectronicIcons(color)
    return {
        {
            icon = modName .. "/graphics/diesel-locomotive-base.png",
            icon_size = 32
        },
        {
            icon = modName .. "/graphics/diesel-locomotive-mask.png",
            icon_size = 32,
            tint = util.color(color)
        },
        {
            icon = modName .. "/graphics/electric.png",
            icon_size = 22,
            scale = 0.5,
            shift = { -11, 11 }
        }
    }
end

return util