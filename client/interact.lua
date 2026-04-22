-- lcky-status/client/interact.lua
-- ox_lib context menu and interaction functions

-- Create the status context menu
local function CreateStatusMenu(currentStatus)
    local statusDisplay = currentStatus and currentStatus or "No status set."
    
    lib.registerContext({
        id = 'lcky-status-menu',
        title = 'Status Menu',
        position = 'top-right',
        options = {
            {
                title = 'Current Status',
                description = statusDisplay,
                icon = 'user',
                readOnly = true,  -- Read-only, not clickable
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

-- Status update dialog
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

    Bridge.Notify({
        title = 'Status Updated',
        description = 'Your new status: ' .. newStatus,
        type = 'success',
        duration = 3000
    })

    -- Notify nearby players
    NotifyNearbyPlayers()
end

-- Notify nearby players
function NotifyNearbyPlayers()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local notificationDistance = 10.0

    -- Get nearby players using lib.getNearbyPlayers
    local nearbyPlayers = lib.getNearbyPlayers(playerCoords, notificationDistance, false)

    -- Send notification to each nearby player
    for i = 1, #nearbyPlayers do
        local player = nearbyPlayers[i]
        TriggerServerEvent('lcky-status:server:sendNotifyToPlayer', player.id)
    end
end

-- Clear status
function ClearStatus()
    -- Trigger server event - clear status
    TriggerServerEvent('lcky-status:server:clearStatus')
    
    -- Close menu
    lib.hideContext()
    
    -- Success notification
    Bridge.Notify({
        title = 'Status Cleared',
        description = 'Your status has been cleared successfully.',
        type = 'success',
        duration = 3000
    })
end

-- Open main context menu
function OpenStatusMenu()
    -- Get current status from server
    local currentStatus = GetPlayerStatusFromServer()
    
    -- Create and show menu
    CreateStatusMenu(currentStatus)
    lib.showContext('lcky-status-menu')
end
