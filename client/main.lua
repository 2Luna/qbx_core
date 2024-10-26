QBX = {}

---@diagnostic disable-next-line: missing-fields
QBX.PlayerData = {}
QBX.Shared = require 'shared.main'
QBX.IsLoggedIn = false

---@return table<string, Vehicle>
function GetVehiclesByName()
    return QBX.Shared.Vehicles
end

exports('GetVehiclesByName', GetVehiclesByName)

---@return table<number, Vehicle>
function GetVehiclesByHash()
    return QBX.Shared.VehicleHashes
end

exports('GetVehiclesByHash', GetVehiclesByHash)

---@return table<string, Vehicle[]>
function GetVehiclesByCategory()
    return qbx.table.mapBySubfield(QBX.Shared.Vehicles, 'category')
end

exports('GetVehiclesByCategory', GetVehiclesByCategory)

---@return table<number, Weapon>
function GetWeapons()
    return QBX.Shared.Weapons
end

exports('GetWeapons', GetWeapons)

---@deprecated
---@return table<string, vector4>
function GetLocations()
    return QBX.Shared.Locations
end

---@diagnostic disable-next-line: deprecated
exports('GetLocations', GetLocations)

AddStateBagChangeHandler('isLoggedIn', ('player:%s'):format(cache.serverId), function(_, _, value)
    QBX.IsLoggedIn = value
end)

lib.callback.register('qbx_core:client:setHealth', function(health)
    SetEntityHealth(cache.ped, health)
end)

local mapText = require 'config.client'.pauseMapText
if mapText == '' or type(mapText) ~= 'string' then mapText = 'FiveM' end
AddTextEntry('FE_THDR_GTAO', mapText)

local map_category = require 'config.client'.pausemapCategory
if map_category == '' or type(map_category) ~= 'string' then map_category = 'Map' end
AddTextEntry('PM_SCR_MAP', map_category)

local game_category = require 'config.client'.pausegameCategory
if game_category == '' or type(game_category) ~= 'string' then game_category = 'Take the plane' end
AddTextEntry('PM_SCR_GAM', game_category)

local disconnect_submenu = require 'config.client'.pauseDisconnect
if disconnect_submenu == '' or type(disconnect_submenu) ~= 'string' then disconnect_submenu = 'Go back to the list of servers' end
AddTextEntry('PM_PANE_LEAVE', disconnect_submenu)

local closegame_submenu = require 'config.client'.pauseCloseGame
if closegame_submenu == '' or type(closegame_submenu) ~= 'string' then closegame_submenu = 'Exit FiveM and return to desktop' end
AddTextEntry('PM_PANE_QUIT', closegame_submenu)

local info_category = require 'config.client'.pauseInfo
if info_category == '' or type(info_category) ~= 'string' then info_category = 'Logs' end
AddTextEntry('PM_SCR_INF', info_category)

local statistics_category = require 'config.client'.pauseStatistics
if statistics_category == '' or type(statistics_category) ~= 'string' then statistics_category = 'Statistics' end
AddTextEntry('PM_SCR_STA', statistics_category)

local settings_category = require 'config.client'.pauseSettings
if settings_category == '' or type(settings_category) ~= 'string' then settings_category = 'Settings' end
AddTextEntry('PM_SCR_SET', settings_category)

local gallery_category = require 'config.client'.pauseGallery
if gallery_category == '' or type(gallery_category) ~= 'string' then gallery_category = 'Gallery' end
AddTextEntry('PM_SCR_GAL', gallery_category)

local rockstar_editor_category = require 'config.client'.pauseRockstarEditor
if rockstar_editor_category == '' or type(rockstar_editor_category) ~= 'string' then rockstar_editor_category = 'R-Editor' end
AddTextEntry('PM_SCR_RPL', rockstar_editor_category)

local fivem_key_config_submenu = require 'config.client'.pauseFiveMKeyConfig
if fivem_key_config_submenu == '' or type(fivem_key_config_submenu) ~= 'string' then fivem_key_config_submenu = 'FiveM' end
AddTextEntry('PM_PANE_CFX', fivem_key_config_submenu)

CreateThread(function()
    for _, v in pairs(GetVehiclesByName()) do
        if v.model and v.name then
            local gameName = GetDisplayNameFromVehicleModel(v.model)
            if gameName and gameName ~= 'CARNOTFOUND' then
                AddTextEntryByHash(joaat(gameName), v.name)
            else
                lib.print.warn('Could not find gameName value in vehicles.meta for vehicle model %s', v.model)
            end
        end
    end
end)

lib.callback.register('qbx_core:client:getVehicleClasses', function()
    local models = GetAllVehicleModels()
    local classes = {}
    for i = 1, #models do
        local model = models[i]
        local class = GetVehicleClassFromName(model)
        classes[joaat(model)] = class
    end
    return classes
end)