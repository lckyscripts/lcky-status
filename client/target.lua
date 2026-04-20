-- lcky-status/client/target.lua
-- ox_target entegrasyonu - Oyuncu hedefleme

-- Oyuncu hedefleme seçeneklerini ekle
local function AddPlayerTargetOptions()
    exports.ox_target:addGlobalPlayer({
        {
            name = 'lcky-status-show',
            label = 'Show Status',
            icon = 'fa-user-tag',
            distance = 3.0,
            onSelect = function(data)
                -- Hedef oyuncunun server ID'sini al
                local targetPed = data.entity
                local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetPed))
                
                -- Server'dan durumu al (callback)
                local targetStatus = lib.callback.await('lcky-status:server:getPlayerStatusById', false, targetServerId)
                
                -- Durumu chate yaz
                if targetStatus and targetStatus ~= nil then
                    lib.print.info('Player Status: ' .. targetStatus)
                else
                    lib.print.info('No Status')
                end
            end,
        },
    })
end

-- Resource başlatıldığında hedefleme seçeneklerini ekle
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    AddPlayerTargetOptions()
end)


-- Sistemi yeniden başlattığımda çalışması için eklendi, silinecek
AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  print('The resource ' .. resourceName .. ' has been started.')
  AddPlayerTargetOptions()
end)