-- lcky-status/server/main.lua
-- Server-side durum yönetimi

-- Client'tan gelen durum güncelleme event'i
RegisterNetEvent('lcky-status:server:updateStatus', function(newStatus)
    local src = source
    
    -- qbx_core SetMetadata export'ını kullanarak oyuncunun metadata'sına kaydet
    exports.qbx_core:SetMetadata(src, 'statuses', newStatus)
    
    -- Başarı bildirimini client'a gönder
    TriggerClientEvent('lcky-status:client:updateStatus', src, newStatus)
end)

-- Client'tan gelen durum temizleme event'i
RegisterNetEvent('lcky-status:server:clearStatus', function()
    local src = source
    
    -- qbx_core SetMetadata export'ını kullanarak oyuncunun metadata'sını temizle
    exports.qbx_core:SetMetadata(src, 'statuses', nil)
    
    -- Başarı bildirimini client'a gönder
    TriggerClientEvent('lcky-status:client:clearStatus', src)
end)

-- Yakındaki oyunculara bildirim gönder
RegisterNetEvent('lcky-status:server:sendNotifyToPlayer', function(targetServerId)
    local src = source
    local playerName = GetPlayerName(src)
    
    -- Hedef oyuncuya bildirim gönder
    TriggerClientEvent('lcky-status:client:receiveNotify', targetServerId, playerName)
end)

-- Oyuncunun durumunu al (callback - ox_lib için)
lib.callback.register('lcky-status:server:getPlayerStatus', function(source)
    return exports.qbx_core:GetMetadata(source, 'statuses')
end)

-- Oyuncunun durumunu al (callback - ID ile - ox_target için)
lib.callback.register('lcky-status:server:getPlayerStatusById', function(source, targetServerId)
    -- Hedef oyuncunun source'unu al
    local targetPlayer = exports.qbx_core:GetPlayer(targetServerId)
    if not targetPlayer then
        return nil
    end
    
    return exports.qbx_core:GetMetadata(targetServerId, 'statuses')
end)

-- Oyuncunun durumunu al (export olarak kullanılabilir)
exports('GetPlayerStatus', function(source)
    return exports.qbx_core:GetMetadata(source, 'statuses')
end)

-- Oyuncunun durumunu ayarla (export olarak kullanılabilir)
exports('SetPlayerStatus', function(source, status)
    exports.qbx_core:SetMetadata(source, 'statuses', status)
    
    -- Client'a bildir
    TriggerClientEvent('lcky-status:client:updateStatus', source, status)
end)
