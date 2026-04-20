-- lcky-status/client/main.lua
-- Ana client-side mantık dosyası

-- Oyuncunun mevcut durumu (local cache)
local currentPlayerStatus = nil

-- /durum komutu - Ana komut handler
RegisterCommand('status', function(source, args, rawCommand)
    -- interact.lua'daki context menüyü aç
    OpenStatusMenu()
end, false)

-- Server event: Durum güncelleme
RegisterNetEvent('lcky-status:client:updateStatus', function(newStatus)
    currentPlayerStatus = newStatus
end)

-- Server event: Durum temizleme
RegisterNetEvent('lcky-status:client:clearStatus', function()
    currentPlayerStatus = nil
end)

-- Server event: Bildirim al
RegisterNetEvent('lcky-status:client:receiveNotify', function(playerName)
    lib.notify({
        title = 'Status Updated',
        description = playerName .. ' updated status:',
        type = 'inform',
        duration = 3000
    })
end)

-- Oyuncunun mevcut durumunu al
---@return string|nil
function GetPlayerStatus()
    return currentPlayerStatus
end

-- Oyuncunun durumunu ayarla (local)
---@param status string
function SetPlayerStatus(status)
    currentPlayerStatus = status
    -- Server event tetikle - durumu database'e kaydet
    TriggerServerEvent('lcky-status:server:updateStatus', status)
end

-- Server'dan mevcut durumu al (callback) - global fonksiyon
GetPlayerStatusFromServer = function()
    return lib.callback.await('lcky-status:server:getPlayerStatus', false)
end

-- Export: Server'dan durum almak için
exports('GetPlayerStatusFromServer', GetPlayerStatusFromServer)
