Citizen.CreateThread(function()
    print("DEBUG: Skript disable_vehicle_self_right gestartet")
    local notified = false
    local flippedTime = 0
    local isFlipped = false
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle ~= 0 then
            local vehicleClass = GetVehicleClass(vehicle)
            -- Prüfen, ob das Fahrzeug ein Auto (Klassen 0-7) oder ein Boot (Klasse 14) ist
            if (vehicleClass >= 0 and vehicleClass <= 7) or vehicleClass == 14 then
                local roll = GetEntityRoll(vehicle)
                if roll > 80.0 or roll < -80.0 then
                    if not isFlipped then
                        flippedTime = GetGameTimer() -- Starte Timer, wenn Fahrzeug umkippt
                        isFlipped = true
                    end
                    if isFlipped and (GetGameTimer() - flippedTime) >= 3000 then
                        DisableControlAction(0, 71, true) -- W (INPUT_VEH_ACCELERATE)
                        DisableControlAction(0, 72, true) -- S (INPUT_VEH_BRAKE)
                        DisableControlAction(0, 59, true) -- A/D (INPUT_VEH_MOVE_LR)
                        if not notified then
                            ShowNotification("~r~Fahrzeug umgekippt! Rufe einen Abschleppdienst.")
                            notified = true
                        end
                    end
                else
                    EnableControlAction(0, 71, true)
                    EnableControlAction(0, 72, true)
                    EnableControlAction(0, 59, true)
                    notified = false
                    isFlipped = false
                    flippedTimeEG = 0
                end
            else
                notified = false
                isFlipped = false
                flippedTime = 0
            end
        else
            notified = false
            isFlipped = false
            flippedTime = 0
        end
    end
end)


function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- function ShowNotification(text)
--    -- Trigger txAdmin announcement event nur für den lokalen Spieler
--     TriggerEvent('txAdmin:receiveAnnounce', text)
-- end