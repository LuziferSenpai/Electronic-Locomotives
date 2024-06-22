local modName = "__Electronic_Locomotives__"
local fuel = {}
local modifiers = {
    { nil, nil },
    { 1.2, 1.05 },
    { 1.8, 1.15 },
    { 2.5, 1.15 },
    { 3.5, 1.75 }
}

for i = 1, 5 do
    table.insert(fuel, {
        type = "item",
        name = "electronic-fuel-" .. i,
        localised_name = { "electronic-locomotives.fuel", i },
        icon = modName .. "/graphics/electric.png",
        icon_size = 22,
        fuel_category = "electronic",
        fuel_value = "10MJ",
        fuel_acceleration_multiplier = modifiers[i][1],
        fuel_top_speed_multiplier = modifiers[i][1],
        subgroup = "raw-resource",
        order = "z[energy]",
        stack_size = 1,
        enabled = false,
        hidden = true
    })
end

return fuel
