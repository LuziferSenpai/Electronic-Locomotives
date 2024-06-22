local locomotives = data.raw.locomotive
local providers = data.raw["electric-energy-interface"]
local locomotiveList = {}
local providerList = {}

data:extend{
    {
        type = "selection-tool",
        name = "electronic-locomotive-list",
        flags = { "hidden" },
        icon = "__flib__/graphics/empty.png",
        icon_size = 1,
        entity_filters = locomotiveList,
        stack_size = 1,
        selection_color = {},
        alt_selection_color = {},
        selection_mode = { "any-entity" },
        alt_selection_mode = { "any-entity" },
        selection_cursor_box_type = "entity",
        alt_selection_cursor_box_type = "entity"
    },
    {
        type = "selection-tool",
        name = "electronic-provider-list",
        flags = { "hidden" },
        icon = "__flib__/graphics/empty.png",
        icon_size = 1,
        entity_filters = providerList,
        stack_size = 1,
        selection_color = {},
        alt_selection_color = {},
        selection_mode = { "any-entity" },
        alt_selection_mode = { "any-entity" },
        selection_cursor_box_type = "entity",
        alt_selection_cursor_box_type = "entity"
    }
}

for _, locomotive in pairs(locomotives) do
    if locomotive.is_electronic then
        table.insert(locomotiveList, locomotive.name)

        locomotive.burner = {
            fuel_category = "electronic",
            effictivity = 1,
            fuel_inventory_size = 1
        }
    end
end

for _, provider in pairs(providers) do
    if provider.is_electronic then
        table.insert(providerList, provider.name)
    end
end

if data.raw["cargo-wagon"]["cargo-wagon"].max_speed < 3 then
    data.raw["cargo-wagon"]["cargo-wagon"].max_speed = 3
end

if data.raw["fluid-wagon"]["fluid-wagon"].max_speed < 3 then
    data.raw["fluid-wagon"]["fluid-wagon"].max_speed = 3
end