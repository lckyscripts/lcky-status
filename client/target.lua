-- lcky-status/client/target.lua
-- Target integration - Player targeting

-- Add player targeting options
local function AddPlayerTargetOptions()
    Bridge.AddGlobalPlayerTarget({
        {
            name = 'lcky-status-show',
            label = 'Show Status',
            icon = 'fa-user-tag',
            distance = 3.0,
            onSelect = function(data)
                -- Get target player's server ID
                local targetPed = data.entity
                local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetPed))
                
                -- Get status from server (callback)
                local targetStatus = lib.callback.await('lcky-status:server:getPlayerStatusById', false, targetServerId)
                
                -- Display status
                if targetStatus and targetStatus ~= nil then
                    Bridge.Notify({
                        title = 'Player Status',
                        description = targetStatus,
                        type = 'inform'
                    })
                else
                    Bridge.Notify({
                        title = 'Player Status',
                        description = 'No Status',
                        type = 'error'
                    })
                end
            end,
        },
    })
end

-- Framework-specific player loaded events
if Bridge.Framework == 'qbcore' or Bridge.Framework == 'qbox' then
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        AddPlayerTargetOptions()
    end)
elseif Bridge.Framework == 'esx' then
    RegisterNetEvent('esx:playerLoaded', function()
        AddPlayerTargetOptions()
    end)
end

-- On resource start (for development or script restart)
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    AddPlayerTargetOptions()
end)
