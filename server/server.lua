ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback("eno_funk:getJob", function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    cb(xPlayer.getJob().name)
end)

ESX.RegisterServerCallback("eno_funk:getOpenMenu", function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then
        return
    end

    if xPlayer.hasItem("funk") then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("eno_funk:checkFunkItem", function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        cb(false)
        return
    end

    local hasFunk = xPlayer.getInventoryItem("funk").count > 0
    cb(hasFunk)
end)