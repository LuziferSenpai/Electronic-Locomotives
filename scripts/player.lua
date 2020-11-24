local mod_gui = require "mod-gui"
local player_data = {}
local filter = {"left"}
local descriptionflow = {type = "flow", direction = "horizontal", style = "electronicdescriptionflow"}
local line = {type = "line", style = "electronicline"}

player_data.metatable = {__index = player_data}

function player_data.new(player, surfacenames)
    local module = {
        player = player,
        index = tostring(player.index),
        location = {x = 5, y = 85 * player.display_scale},
        button = mod_gui.get_button_flow(player).add{type = "sprite-button", name = "ELECTRONIC_CLICK01", sprite = "item/Electronic-Energy-Provider", mouse_button_filter = filter, style = mod_gui.button_style},
        update_locos = false,
        update_provider = false,
        surfacenames = surfacenames,
        selected_index = 1
    }

    setmetatable(module, player_data.metatable)

    return module
end

function player_data:gui(locotable, providertable)
    local frame = self.player.gui.screen.add{type = "frame", name = "ELECTRONIC_LOCATION", direction = "vertical", style = "inner_frame_in_outer_frame"}
    frame.location = self.location
    self.frame = frame
    local titleflow = frame.add{type = "flow", direction = "horizontal"}
    titleflow.add{type = "label", caption = {"Electronic.Title"}, style = "frame_title"}
    titleflow.add{type = "empty-widget", style = "electronicdragwidget"}.drag_target = frame
    titleflow.add{type = "sprite-button", name = "ELECTRONIC_CLICK02", sprite = "utility/close_white", mouse_button_filter = filter, style = "frame_action_button"}
    frame.add(line)
    local updatelocoflow = frame.add(descriptionflow)
    self.updatelocobutton = updatelocoflow.add{type = "sprite-button", name = "ELECTRONIC_CLICK03", sprite = "utility/refresh", mouse_button_filter = filter, style = "electronictoolbutton"}
    updatelocoflow.add{type = "checkbox", name = "ELECTRONIC_CHECK01", state = self.update_locos, caption = {"Electronic.On/Off"}, style = "caption_checkbox"}
    frame.add(line)
    local lococountflow = frame.add(descriptionflow)
    lococountflow.add{type = "label", caption = {"Electronic.ElecLocos"}, style = "description_label"}
    self.lococount = lococountflow.add{type = "label", caption = locotable.locomotives, "description_value_label"}
    local activelocoflow = frame.add(descriptionflow)
    activelocoflow.add{type = "label", caption = {"Electronic.ActiveLocos"}, style = "description_label"}
    self.activeloco = activelocoflow.add{type = "label", caption = locotable.energyall, "description_value_label"}
    local energylocoflow = frame.add(descriptionflow)
    energylocoflow.add{type = "label", caption = {"Electronic.EnergyLocos"}, style = "description_label"}
    self.energyloco = energylocoflow.add{type = "label", caption = {"Electronic." .. locotable.energy[1], locotable.energy[2]}, "description_value_label"}
    frame.add(line)
    local updateproviderflow = frame.add(descriptionflow)
    self.updateproviderbutton = updateproviderflow.add{type = "sprite-button", name = "ELECTRONIC_CLICK04", sprite = "utility/refresh", mouse_button_filter = filter, style = "electronictoolbutton"}
    updateproviderflow.add{type = "checkbox", name = "ELECTRONIC_CHECK02", state = self.update_provider, caption = {"Electronic.On/Off"}, style = "caption_checkbox"}
    frame.add(line)
    local providerflowhorizontal = frame.add{type = "flow", direction = "horizontal", style = "electronicproviderflow"}
    self.listbox = providerflowhorizontal.add{type = "list-box", name = "ELECTRONIC_DROP01", items = self.surfacenames, selected_index = self.selected_index, style = "electroniclistbox"}
    local providerflowvertical = providerflowhorizontal.add{type = "flow", direction = "vertical"}
    local providercountflow = providerflowvertical.add(descriptionflow)
    providercountflow.add{type = "label", caption = {"Electronic.Providers"}, style = "description_label"}
    self.providercount = providercountflow.add{type = "label", caption = providertable.amount, "description_value_label"}
    local providerinputflow = providerflowvertical.add(descriptionflow)
    providerinputflow.add{type = "label", caption = {"Electronic.InProviders"}, style = "description_label"}
    self.providerinput = providerinputflow.add{type = "label", caption = {"Electronic." .. providertable.energyin[1], providertable.energyin[2]}, "description_value_label"}
    local providerstorageflow = providerflowvertical.add(descriptionflow)
    providerstorageflow.add{type = "label", caption = {"Electronic.StoreProviders"}, style = "description_label"}
    self.providerstorage = providerstorageflow.add{type = "label", caption = {"Electronic." .. providertable.storageenergy[1], providertable.storageenergy[2]}, "description_value_label"}
    local providerintakeflow = providerflowvertical.add(descriptionflow)
    providerintakeflow.add{type = "label", caption = {"Electronic.IntakeProviders"}, style = "description_label"}
    self.providerintake = providerintakeflow.add{type = "label", caption = {"Electronic." .. providertable.intakeenergy[1], providertable.intakeenergy[2]}, "description_value_label"}
    self.progressbar = providerflowvertical.add{type = "progressbar", value = providertable.value, style = "electronicprogressbar"}
end

function player_data:clear()
    self.frame.destroy()
    self.frame = nil
    self.updatelocobutton = nil
    self.lococount = nil
    self.activeloco = nil
    self.energyloco = nil
    self.updateproviderbutton = nil
    self.listbox = nil
    self.providercount = nil
    self.providerinput = nil
    self.providerstorage = nil
    self.providerintake = nil
    self.progressbar = nil
end

return player_data