local modName = "__Electronic_Locomotives__"
local electronicTechnology = {}
local electronicTechnologyData = {
    {
        effects = {
            {
                type = "unlock-recipe",
                recipe = "electronic-standard-provider"
            },
            {
                type = "unlock-recipe",
                recipe = "electronic-standard-locomotive"
            }
        },
        prerequisites = { "railway", "electric-engine", "battery", "electric-energy-distribution-2" },
        unit = {
            count = 400,
            time = 60,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 }
            }
        },
    },
    {
        effects = {
            {
                type = "unlock-recipe",
                recipe = "electronic-cargo-locomotive"
            }
        },
        unit = {
            count = 800,
            time = 60,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "production-science-pack", 1 }
            }
        },
    },
    {
        localised_description = { "electronic-locomotives.description", 1.2, 1.05 },
        unit = {
            count = 1000,
            time = 60,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "production-science-pack", 1 }
            }
        },
    },
    {
        localised_description = { "electronic-locomotives.description", 1.8, 1.15 },
        unit = {
            count = 1200,
            time = 60,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "production-science-pack", 1 },
                { "utility-science-pack",    1 }
            }
        },
    },
    {
        localised_description = { "electronic-locomotives.description", 2.5, 1.15 },
        unit = {
            count = 1400,
            time = 60,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "production-science-pack", 1 },
                { "utility-science-pack",    1 }
            }
        },
    },
    {
        localised_description = { "electronic-locomotives.description", 3.5, 1.75 },
        unit = {
            count = 2000,
            time = 60,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "production-science-pack", 1 },
                { "utility-science-pack",    1 },
                { "space-science-pack",      1 }
            }
        },
    },
    {
        effects = {
            {
                type = "unlock-recipe",
                recipe = "electronic-heavy-provider"
            },
        },
        unit = {
            count = 10000,
            time = 60,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "production-science-pack", 1 },
                { "utility-science-pack",    1 },
                { "space-science-pack",      1 }
            }
        },
    },
}

for i = 1, #electronicTechnologyData do
    table.insert(electronicTechnology, {
        type = "technology",
        name = "electronic-locomotives" .. (i > 1 and "-" .. i or ""),
        icon = modName .. "/graphics/electronic-railway.png",
        icon_size = 256,
        icon_mip_maps = 4,
        localised_description = electronicTechnologyData[i].localised_description,
        effects = electronicTechnologyData[i].effects,
        prerequisites = electronicTechnologyData[i].prerequisites or
        { ((i > 2 and "electronic-locomotives-" .. i - 1) or "electronic-locomotives") },
        unit = electronicTechnologyData[i].unit,
        order = "e-l",
        upgrade = true
    })
end

return electronicTechnology
