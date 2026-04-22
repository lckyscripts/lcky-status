-- lcky-status/client/main.lua
-- Main client-side logic

-- Player's current status (local cache)
local currentPlayerStatus = nil

-- /status command - Main command handler
RegisterCommand('status', function(source, args, rawCommand)
    OpenStatusMenu()
end, false)

-- Server event: Status update
RegisterNetEvent('lcky-status:client:updateStatus', function(newStatus)
    currentPlayerStatus = newStatus
end)

-- Server event: Status clear
RegisterNetEvent('lcky-status:client:clearStatus', function()
    currentPlayerStatus = nil
end)

-- Server event: Receive notification
RegisterNetEvent('lcky-status:client:receiveNotify', function(playerName)
    Bridge.Notify({
        title = 'Status Updated',
        description = playerName .. ' updated status:',
        type = 'inform',
        duration = 3000
    })
end)

-- Get player's current status
---@return string|nil
function GetPlayerStatus()
    return currentPlayerStatus
end

-- Set player status (local)
---@param status string
function SetPlayerStatus(status)
    currentPlayerStatus = status
    -- Trigger server event - save status to database
    TriggerServerEvent('lcky-status:server:updateStatus', status)
end

-- Get current status from server (callback) - global function
GetPlayerStatusFromServer = function()
    return lib.callback.await('lcky-status:server:getPlayerStatus', false)
end

-- Export: Get status from server
exports('GetPlayerStatusFromServer', GetPlayerStatusFromServer)
