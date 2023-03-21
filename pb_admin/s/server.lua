local VorpCore
local VorpInv


TriggerEvent("getCore",function(core)
    VorpCore = core
end)

VorpInv = exports.vorp_inventory:vorp_inventoryApi()

RegisterCommand("a", function(source, args, rawCommand)
    local _source = source
    local user = VorpCore.getUser(_source).getUsedCharacter
        local group = user.group
        if group == 'admin' then
		TriggerClientEvent('556_admin:menu', _source, group)
        else
            return
        end
end)

RegisterCommand("nci", function(source, args, rawCommand)
    local _source = source
    local user = VorpCore.getUser(_source).getUsedCharacter
        local group = user.group
        if group == 'admin' then
		TriggerClientEvent('556_admin:menu2', _source)
        else
            return
        end
end)

RegisterServerEvent('556_admin:idadmincheck')
AddEventHandler('556_admin:idadmincheck', function()
    local _source = source
    local user = VorpCore.getUser(_source).getUsedCharacter
        local group = user.group
        if group == 'admin' then
		TriggerClientEvent('556_admin:id2', _source)
        else
            return
        end
end)