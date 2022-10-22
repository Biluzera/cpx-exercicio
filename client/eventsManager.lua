-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLE:DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vehicle:delete", function(entIndex)
    if NetworkDoesNetworkIdExist(entIndex) then
        local idNetwork = NetworkGetEntityFromNetworkId(entIndex)
        if DoesEntityExist(idNetwork) then
            DeleteEntity(idNetwork)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTITYDAMAGE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function(name,args)
	if name == "CEventNetworkEntityDamage" then
        if IsPedAMissionPed(args[1]) and (IsPedDeadOrDying(args[1]) or not DoesEntityExist(args[1])) then
            RemovePedBlip(args[1])
            PrintDebug("[!] Removing mission ped " .. args[1])
        end
	end
end)