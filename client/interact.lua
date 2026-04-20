-- lcky-status/client/interact.lua
-- ox_lib context menu ve etkileşim fonksiyonları

-- Durum context menüsünü oluştur
local function CreateStatusMenu(currentStatus)
    local statusDisplay = currentStatus and currentStatus or "Mevcut durum yok."
    
    lib.registerContext({
        id = 'lcky-status-menu',
        title = 'Status Menu',
        position = 'top-right',
        options = {
            {
                title = 'Current Status',
                description = statusDisplay,
                icon = 'user',
                readOnly = true,  -- Salt okunur, tıklanamaz
            },
            {
                title = 'Update Status',
                description = 'Click to set your new status.',
                icon = 'pencil',
                onSelect = function()
                    OpenUpdateDialog()
                end,
            },
            {
                title = 'Clear Status',
                description = 'Click to clear your status.',
                icon = 'trash',
                onSelect = function()
                    ClearStatus()
                end,
            },
        }
    })
end

-- Durum güncelleme dialog'u
function OpenUpdateDialog()
    local status = lib.inputDialog('Update Status', {
        {
            type = 'input',
            label = 'New Status',
            placeholder = 'Enter your status...',
            description = 'Enter your new status here',
            required = true,
            minLength = 1,
            maxLength = 100
        }
    })

    if not status then
        return
    end

    local newStatus = status[1]
    SetPlayerStatus(newStatus)

    lib.notify({
        title = 'Status Updated',
        description = 'Your new status: ' .. newStatus,
        type = 'success',
        duration = 3000
    })

    -- Yakındaki oyunculara bildirim gönder
    NotifyNearbyPlayers()
end

-- Yakındaki oyunculara bildirim gönder
function NotifyNearbyPlayers()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local notificationDistance = 10.0

    -- lib.getNearbyPlayers kullanarak yakındaki oyuncuları al
    local nearbyPlayers = lib.getNearbyPlayers(playerCoords, notificationDistance, false)

    -- Yakındaki her oyuncuya bildirim gönder
    for i = 1, #nearbyPlayers do
        local player = nearbyPlayers[i]
        TriggerServerEvent('lcky-status:server:sendNotifyToPlayer', player.id)
    end
end

-- Durumu temizle
function ClearStatus()
    -- Server event tetikle - durumu temizle
    TriggerServerEvent('lcky-status:server:clearStatus')
    
    -- Menü kapat
    lib.hideContext()
    
    -- Başarı bildirimi
    lib.notify({
        title = 'Status Cleared',
        description = 'Your status has been cleared successfully.',
        type = 'success',
        duration = 3000
    })
end

-- Ana context menüyü aç
function OpenStatusMenu()
    -- Server'dan mevcut durumu al
    local currentStatus = GetPlayerStatusFromServer()
    
    -- Menü oluştur ve göster
    CreateStatusMenu(currentStatus)
    lib.showContext('lcky-status-menu')
end