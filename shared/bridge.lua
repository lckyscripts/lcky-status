-- lcky-status/shared/bridge.lua
-- Bridge system for framework compatibility

Bridge = {}
Bridge.Framework = nil -- 'qbox', 'qbcore', 'esx'
Bridge.Target = nil    -- 'ox_target', 'qb-target'

-- Detect Framework
local function DetectFramework()
    if GetResourceState('qbx_core') == 'started' then
        Bridge.Framework = 'qbox'
    elseif GetResourceState('qb-core') == 'started' then
        Bridge.Framework = 'qbcore'
    elseif GetResourceState('es_extended') == 'started' then
        Bridge.Framework = 'esx'
    end
    return Bridge.Framework
end

-- Detect Target System
local function DetectTarget()
    if GetResourceState('ox_target') == 'started' then
        Bridge.Target = 'ox_target'
    elseif GetResourceState('qb-target') == 'started' then
        Bridge.Target = 'qb-target'
    end
    return Bridge.Target
end

DetectFramework()
DetectTarget()

-- Core Objects
if Bridge.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Bridge.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
end

-------------------------------------------------------------------------------
-- SERVER FUNCTIONS
-------------------------------------------------------------------------------
if IsDuplicityVersion() then
    -- Get Player Data
    function Bridge.GetPlayer(source)
        if Bridge.Framework == 'qbox' then
            return exports.qbx_core:GetPlayer(source)
        elseif Bridge.Framework == 'qbcore' then
            return QBCore.Functions.GetPlayer(source)
        elseif Bridge.Framework == 'esx' then
            return ESX.GetPlayerFromId(source)
        end
    end

    -- Get Metadata
    function Bridge.GetMetadata(source, key)
        if Bridge.Framework == 'qbox' then
            return exports.qbx_core:GetMetadata(source, key)
        elseif Bridge.Framework == 'qbcore' then
            local pData = Bridge.GetPlayer(source)
            return pData and pData.PlayerData.metadata[key]
        elseif Bridge.Framework == 'esx' then
            local xPlayer = Bridge.GetPlayer(source)
            return xPlayer and xPlayer.getMeta(key)
        end
    end

    -- Set Metadata
    function Bridge.SetMetadata(source, key, value)
        if Bridge.Framework == 'qbox' then
            exports.qbx_core:SetMetadata(source, key, value)
        elseif Bridge.Framework == 'qbcore' then
            local pData = Bridge.GetPlayer(source)
            if pData then
                pData.Functions.SetMetaData(key, value)
            end
        elseif Bridge.Framework == 'esx' then
            local xPlayer = Bridge.GetPlayer(source)
            if xPlayer then
                xPlayer.setMeta(key, value)
            end
        end
    end
end

-------------------------------------------------------------------------------
-- CLIENT FUNCTIONS
-------------------------------------------------------------------------------
if not IsDuplicityVersion() then
    -- Add Global Player Target
    function Bridge.AddGlobalPlayerTarget(options)
        if Bridge.Target == 'ox_target' then
            exports.ox_target:addGlobalPlayer(options)
        elseif Bridge.Target == 'qb-target' then
            local qbOptions = {}
            for _, opt in ipairs(options) do
                table.insert(qbOptions, {
                    type = "client",
                    action = opt.onSelect,
                    icon = opt.icon,
                    label = opt.label,
                    canInteract = opt.canInteract
                })
            end
            exports['qb-target']:AddGlobalPlayer({
                options = qbOptions,
                distance = options[1].distance or 2.5,
            })
        end
    end

    -- Notification
    function Bridge.Notify(data)
        if GetResourceState('ox_lib') == 'started' then
            lib.notify(data)
        else
            if Bridge.Framework == 'qbcore' then
                QBCore.Functions.Notify(data.description, data.type)
            elseif Bridge.Framework == 'esx' then
                ESX.ShowNotification(data.description)
            else
                print("Notify: " .. tostring(data.description))
            end
        end
    end
end
