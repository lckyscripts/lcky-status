-- lcky-status/server/main.lua
-- Server-side status management

-- Status update event from client
RegisterNetEvent('lcky-status:server:updateStatus', function(newStatus)
    local src = source
    
    -- Save to player metadata using Bridge system
    Bridge.SetMetadata(src, 'statuses', newStatus)
    
    -- Send success notification to client
    TriggerClientEvent('lcky-status:client:updateStatus', src, newStatus)
end)

-- Status clear event from client
RegisterNetEvent('lcky-status:server:clearStatus', function()
    local src = source
    
    -- Clear player metadata using Bridge system
    Bridge.SetMetadata(src, 'statuses', nil)
    
    -- Send success notification to client
    TriggerClientEvent('lcky-status:client:clearStatus', src)
end)

-- Send notification to nearby players
RegisterNetEvent('lcky-status:server:sendNotifyToPlayer', function(targetServerId)
    local src = source
    local playerName = GetPlayerName(src)
    
    -- Send notification to target player
    TriggerClientEvent('lcky-status:client:receiveNotify', targetServerId, playerName)
end)

-- Get player status (callback - for ox_lib)
lib.callback.register('lcky-status:server:getPlayerStatus', function(source)
    return Bridge.GetMetadata(source, 'statuses')
end)

-- Get player status (callback - by ID - for targeting)
lib.callback.register('lcky-status:server:getPlayerStatusById', function(source, targetServerId)
    -- Get target player
    local targetPlayer = Bridge.GetPlayer(targetServerId)
    if not targetPlayer then
        return nil
    end
    
    return Bridge.GetMetadata(targetServerId, 'statuses')
end)

-- Get player status (available as export)
exports('GetPlayerStatus', function(source)
    return Bridge.GetMetadata(source, 'statuses')
end)

-- Set player status (available as export)
exports('SetPlayerStatus', function(source, status)
    Bridge.SetMetadata(source, 'statuses', status)
    
    -- Notify client
    TriggerClientEvent('lcky-status:client:updateStatus', source, status)
end)
