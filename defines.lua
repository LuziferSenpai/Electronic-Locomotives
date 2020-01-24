local MODNAME = "__Electronic_Locomotives__"
local table_deepcopy = util.table.deepcopy

Senpais = Senpais or {}

Senpais.Functions = Senpais.Functions or {}

Senpais.Functions.Create = Senpais.Functions.Create or {}

Senpais.Functions.Create.Electronic_Locomotive = function( name, max_health, weight, max_speed, max_power, color, grid, subgroup, order, stack_size, ingredients, technology )
	local icons =
	{
		{ icon = MODNAME .. "/graphics/diesel-locomotive-base.png", icon_size = 32 },
		{ icon = MODNAME .. "/graphics/diesel-locomotive-mask.png", icon_size = 32, tint = util.color( color ) }
	}

	local locomotive_entity = table_deepcopy( data.raw["locomotive"]["locomotive"] )
	locomotive_entity.name = name
	locomotive_entity.icon = nil
	locomotive_entity.icon_size = nil
	locomotive_entity.icon_mipmap = nil
	locomotive_entity.icons = icons
	locomotive_entity.minable.result = name
	locomotive_entity.max_health = max_health
	locomotive_entity.weight = weight
	locomotive_entity.max_speed = max_speed
	locomotive_entity.max_power = max_power
	locomotive_entity.burner =
	{
		fuel_category = "electronic",
		effictivity = 1,
		fuel_inventory_size = 1
	}
	locomotive_entity.color = util.color( color )

	for _, layer in pairs( locomotive_entity.pictures.layers ) do
		if layer.apply_runtime_tint == true then
			for i = 1, 8 do
				layer.filenames[i] = MODNAME .. "/graphics/mask-" .. i .. ".png"
			end

			for i = 1, 16 do
				layer.hr_version.filenames[i] = MODNAME .."/graphics/hr-mask-" .. i .. ".png"
			end

			break
		end
	end

	if type( grid ) == "string" then
		locomotive_entity.equipment_grid = grid
	end

	local locomotive_item = table_deepcopy( data.raw["item-with-entity-data"]["locomotive"] )
	locomotive_item.name = name
	locomotive_item.icon = nil
	locomotive_item.icon_size = nil
	locomotive_item.icon_mipmap = nil
	locomotive_item.icons = icons
	locomotive_item.subgroup = subgroup
	locomotive_item.order = order
	locomotive_item.place_result = name
	locomotive_item.stack_size = stack_size
	
	local locomotive_recipe = table_deepcopy( data.raw["recipe"]["locomotive"] )
	locomotive_recipe.name = name
	locomotive_recipe.ingredients = ingredients
	locomotive_recipe.result = name

	data:extend{ locomotive_entity, locomotive_item, locomotive_recipe }

	table.insert( data.raw["technology"][technology].effects, { type = "unlock-recipe", recipe = name } )
end

Senpais.Functions.Create.Grid = function( name, width, height, category )
	local grid = table_deepcopy( data.raw["equipment-grid"]["large-equipment-grid"] )
	grid.name = name
	grid.width = width
	grid.height = height
	grid.equipment_categories = category

	data:extend{ grid }
end