ESX = exports["es_extended"]:getSharedObject()

local isInFunk = false
local isOpen = false

function toggleUi(bool)
    isOpen = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "toggleUi",
        bool = bool,
        isInFunk = isInFunk,
    })
end

RegisterCommand("funkmenu", function()
    if not isOpen then
        ESX.TriggerServerCallback("eno_funk:getOpenMenu", function(hasItem)
            if hasItem then
                toggleUi(true)
            else
                TriggerEvent("masora_hud-v2:notify", "error", "Du hast kein Funkgerät.", 5000)
            end
        end)
    else
        toggleUi(false)
    end
end)

RegisterNUICallback("frak", function(data, cb)
    ESX.TriggerServerCallback("eno_funk:getJob", function(job)
        if cl_config.frakfunks[job] then
            exports["pma-voice"]:setRadioChannel(cl_config.frakfunks[job])
            TriggerEvent("masora_hud-v2:notify", "success", "Fraktions Funk betreten.", 5000)
            isInFunk = true
            cb(true)
        else
            TriggerEvent("masora_hud-v2:notify", "error", "Deine Fraktion hat keinen zugewiesenen Funk.", 5000)
            cb(false)
        end
    end)
end)

RegisterNUICallback("join", function(data, cb)
    if data.funk ~= "" or not string.find(string.lower(data.funk), "e") or data.funk ~= nil or data.funk > 0 then
        local isLocked = false
        local hasAccess = false

        ESX.TriggerServerCallback("eno_funk:getJob", function(job)
            for k, v in pairs(cl_config.lockedfunks) do
                if tonumber(k) == tonumber(data.funk) then
                    isLocked = true
                    for kk, vv in pairs(v) do
                        if vv == job then
                            hasAccess = true
                            break
                        end
                    end
                    break
                end
            end

            if not isLocked then
                exports["pma-voice"]:setRadioChannel(tonumber(data.funk))
                TriggerEvent("masora_hud-v2:notify", "success", "Funk betreten.", 5000) 
                isInFunk = true
                cb(true)
            elseif isLocked then
                if hasAccess then
                    exports["pma-voice"]:setRadioChannel(tonumber(data.funk))
                    TriggerEvent("masora_hud-v2:notify", "success", "Funk betreten.", 5000) 
                    isInFunk = true
                    cb(true)
                else
                    TriggerEvent("masora_hud-v2:notify", "error", "Du bist nicht berechtigt diesen Funk zu betreten.", 5000) 
                end
            end
        end)
    else
        TriggerEvent("masora_hud-v2:notify", "error", "Bitte gebe einen Funk an.", 5000) 
        cb(false)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4000)

        ESX.TriggerServerCallback("eno_funk:checkFunkItem", function(hasFunk)
            if not hasFunk and isInFunk then
                exports["pma-voice"]:removePlayerFromRadio()
                TriggerEvent("masora_hud-v2:notify", "error", "Funk verlassen, da kein Funkgerät nicht mehr vorhanden ist.", 5000)
                isInFunk = false
            end
        end)
    end
end)


RegisterNUICallback("leave", function(data, cb)
    exports["pma-voice"]:removePlayerFromRadio()
    TriggerEvent("masora_hud-v2:notify", "error", "Funk verlassen.", 5000) 
    isInFunk = false
end)

RegisterNUICallback("close", function(data, cb)
    isOpen = false
    SetNuiFocus(false, false)
end)

RegisterKeyMapping("funkmenu", "Funk-System öffnen", "keyboard", "M")