-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTOP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler('onResourceStop', function(stoppedResource)
    if (ResourceName ~= stoppedResource) then
        return
    end

    for k, v in pairs(GlobalState["vehicleMissionsActive"]) do
        if v and v["vehNet"] then
            local ent = NetworkGetEntityFromNetworkId(v["vehNet"])
            if DoesEntityExist(ent) then
                DeleteEntity(ent)
                print("^3[!] ^0Removing mission vehicle, net ID ^3" .. v["vehNet"] .. "^0")
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDisconnect", function (user_id, source)
    FinishMission(user_id, source, true, false)
    PrintDebug("[!] User ID ^3" .. user_id .. " ^0disconnected, ^3finishing ^0player mission")
end)