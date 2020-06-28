local GUI = {}

local AddCheckbox = function( parent, name, caption, style )
	return parent.add{ type = "checkbox", name = name, caption = caption, state = false, style = style }
end

local AddFlow = function( parent, name, direction, style )
	return parent.add{ type = "flow", name = name, direction = direction, style = style }
end

local AddFrame = function( parent, name, style )
	return parent.add{ type = "frame", name = name, direction = "vertical", style = style }
end

local AddLabel = function( parent, name, caption, style )
	return parent.add{ type = "label", name = name, caption = caption, style = style }
end

local AddLine = function( parent, name, direction, style )
	return parent.add{ type = "line", name = name, direction = direction, style = style }
end

local AddListBox = function( parent, name, items, style )
	return parent.add{ type = "list-box", name = name, items = items, style = style }
end

local AddProgressbar = function( parent, name, value, style )
	return parent.add{ type = "progressbar", name = name, value = value, style = style }
end

local AddSpriteButton = function( parent, name, sprite, style )
	return parent.add{ type = "sprite-button", name = name, sprite = sprite, style = style }
end

local AddWidget = function( parent, name, style )
	return parent.add{ type = "empty-widget", name = name, style = style }
end


GUI.Main = function( parent )
	local A = {}

	A["01"] = AddFrame( parent, "ElectronicFrameAGUI01" )
	A["02"] =
	{
		["01"] = AddFlow( A["01"], "ElectronicFlowAGUI01", "horizontal", "SenpaisFlowCenter/Left8" ),
		["02"] = AddLine( A["01"], "ElectronicLineAGUI01", "horizontal", "SenpaisLine4" ),
		["03"] = AddFlow( A["01"], "ElectronicFlowAGUI02", "horizontal", "SenpaisFlowCenter/Left8" ),
		["04"] = AddLine( A["01"], "ElectronicLineAGUI02", "horizontal", "SenpaisLine4" ),
		["05"] = AddFlow( A["01"], "ElectronicFlowAGUI03", "horizontal", "SenpaisFlowCenter/Left4" ),
		["06"] = AddFlow( A["01"], "ElectronicFlowAGUI04", "horizontal", "SenpaisFlowCenter/Left4" ),
		["07"] = AddFlow( A["01"], "ElectronicFlowAGUI05", "horizontal", "SenpaisFlowCenter/Left4" ),
		["08"] = AddLine( A["01"], "ElectronicLineAGUI03", "horizontal", "SenpaisLine4" ),
		["09"] = AddFlow( A["01"], "ElectronicFlowAGUI06", "horizontal", "SenpaisFlowCenter/Left8" ),
		["10"] = AddLine( A["01"], "ElectronicLineAGUI04", "horizontal", "SenpaisLine4" ),
		["11"] = AddFlow( A["01"], "ElectronicFlowAGUI07", "horizontal", "SenpaisFlowCenter/Left4" )
	}
	A["03"] =
	{
		["01"] = AddLabel( A["02"]["01"], "ElectronicLabelAGUI01", { "Electronic.Title" }, "frame_title" ),
		["02"] = AddWidget( A["02"]["01"], "ElectronicWidgetAGUI01", "draggable_space_header" ),
		["03"] = AddSpriteButton( A["02"]["01"], "ElectronicSpriteButtonAGUI01", "utility/close_white", "frame_action_button" ),

		["04"] = AddSpriteButton( A["02"]["03"], "ElectronicSpriteButtonAGUI02", "utility/refresh", "SenpaisToolButton20" ),
		["05"] = AddCheckbox( A["02"]["03"], "ElectronicCheckboxAGUI01", { "Electronic.On/Off" }, "caption_checkbox" ),

		["06"] = AddLabel( A["02"]["05"], "ElectronicLabelAGUI02", { "Electronic.ElecLocos" }, "description_label" ),
		["07"] = AddLabel( A["02"]["05"], "ElectronicLabelAGUI03", "0", "description_value_label" ),

		["08"] = AddLabel( A["02"]["06"], "ElectronicLabelAGUI04", { "Electronic.ActiveLocos" }, "description_label" ),
		["09"] = AddLabel( A["02"]["06"], "ElectronicLabelAGUI05", "0", "description_value_label" ),

		["10"] = AddLabel( A["02"]["07"], "ElectronicLabelAGUI06", { "Electronic.EnergyLocos" }, "description_label" ),
		["11"] = AddLabel( A["02"]["07"], "ElectronicLabelAGUI07", { "Electronic.kW", 0 }, "description_value_label" ),

		["12"] = AddSpriteButton( A["02"]["09"], "ElectronicSpriteButtonAGUI03", "utility/refresh", "SenpaisToolButton20" ),
		["13"] = AddCheckbox( A["02"]["09"], "ElectronicCheckboxAGUI02", { "Electronic.On/Off" }, "caption_checkbox" ),

		["14"] = AddListBox( A["02"]["11"], "ElectronicListBoxAGUI01", {}, "train_station_list_box" ),
		["15"] = AddFlow( A["02"]["11"], "ElectronicFlowAGUI08", "vertical" )
	}
	A["04"] =
	{
		["01"] = AddFlow( A["03"]["15"], "ElectronicFlowAGUI09", "horizontal", "SenpaisFlowCenter/Left4" ),
		["02"] = AddFlow( A["03"]["15"], "ElectronicFlowAGUI10", "horizontal", "SenpaisFlowCenter/Left4" ),
		["03"] = AddFlow( A["03"]["15"], "ElectronicFlowAGUI11", "horizontal", "SenpaisFlowCenter/Left4" ),
		["04"] = AddFlow( A["03"]["15"], "ElectronicFlowAGUI12", "horizontal", "SenpaisFlowCenter/Left4" ),
		["05"] = AddProgressbar( A["03"]["15"], "ElectronicProgressbarAGUI13", 0, "electric_satisfaction_progressbar" )
	}
	A["05"] =
	{
		["01"] = AddLabel( A["04"]["01"], "ElectronicLabelAGUI08", { "Electronic.Providers" }, "description_label" ),
		["02"] = AddLabel( A["04"]["01"], "ElectronicLabelAGUI09", "0", "description_value_label" ),

		["03"] = AddLabel( A["04"]["02"], "ElectronicLabelAGUI10", { "Electronic.InProviders" }, "description_label" ),
		["04"] = AddLabel( A["04"]["02"], "ElectronicLabelAGUI11", { "Electronic.J", 0 }, "description_value_label" ),

		["05"] = AddLabel( A["04"]["03"], "ElectronicLabelAGUI12", { "Electronic.StoreProviders" }, "description_label" ),
		["06"] = AddLabel( A["04"]["03"], "ElectronicLabelAGUI13", { "Electronic.J", 0 }, "description_value_label" ),

		["07"] = AddLabel( A["04"]["04"], "ElectronicLabelAGUI14", { "Electronic.IntakeProviders" }, "description_label" ),
		["08"] = AddLabel( A["04"]["04"], "ElectronicLabelAGUI15", { "Electronic.kW", 0 }, "description_value_label" )
	}

	A["03"]["02"].style.horizontally_stretchable = true
	A["03"]["02"].style.natural_height = 24
	A["03"]["02"].style.minimal_width = 50
	A["03"]["02"].drag_target = A["01"]
	A["03"]["14"].style.width = 200
	A["03"]["15"].style.left_padding = 8

	A["04"]["05"].style.horizontally_stretchable = true
	A["04"]["05"].style.top_padding = 4

	return A
end

GUI.AddSpriteButton = AddSpriteButton

return GUI