-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
ResourceName = GetCurrentResourceName()
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Client = Tunnel.getInterface(ResourceName)
Server = {}
Tunnel.bindInterface(ResourceName,Server)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Config = GlobalState["vehicleMissionConfig"]
Debug = Config["debug"]
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Server.requestMission(missionId)
    if not missionId or GlobalState["vehicleMissionsActive"][missionId] then
        return false
    end

    local source = source
    local user_id = vRP.getUserId(source)
    if not source or not user_id then
        return false
    end

    local vehicleModel = Config["vehicleModels"][math.random(#Config["vehicleModels"])]
    local missionCoords = Config["missionDeliveryZones"][missionId]
    local vehicle = CreateVehicle(vehicleModel, missionCoords["vehicleSpawnCoords"][1], missionCoords["vehicleSpawnCoords"][2], missionCoords["vehicleSpawnCoords"][3], missionCoords["vehicleSpawnCoords"][4], true, true)

    local waitTime = 0
    while not DoesEntityExist(vehicle) and waitTime <= 1000 do
        waitTime += 1
        Wait(100)
    end

    if DoesEntityExist(vehicle) then

        if GlobalState["vehicleMissionsActive"][missionId] then
            DeleteEntity(vehicle)
            return false
        end


        local vehPlate = tostring(math.random(10000000, 99999999))
        SetVehicleNumberPlateText(vehicle, vehPlate)

        TriggerEvent("plateEveryone",vehPlate)
        TriggerEvent("platePlayers",vehPlate,user_id)

        local vehNet = NetworkGetNetworkIdFromEntity(vehicle)
        PrintDebug("[!] Creating vehicle mission ID " .. missionId .. " with vehNet " .. vehNet .. " and plate " .. vehPlate .. " - mission owner ID " .. user_id)

        local missionData = {
            user_id = user_id,
            source = source,
            missionId = missionId,
            vehNet = vehNet,
            vehPlate = vehPlate
        }

        UpdateGlobalState("vehicleMissionsActive", missionId, missionData)
        return true, missionData
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FORCEMISSIONEND
-----------------------------------------------------------------------------------------------------------------------------------------
function Server.finishMission(delayedVehicleDelete, reward)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        FinishMission(user_id, source, delayedVehicleDelete, reward)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERMISSIONID
-----------------------------------------------------------------------------------------------------------------------------------------
function GetUserMissionId(user_id)
    if user_id then
        for k, v in pairs(GlobalState["vehicleMissionsActive"]) do
            if v and v["user_id"] and v["user_id"] == user_id then
                return true, k
            end
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISHMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function FinishMission(user_id, source, delayedVehicleDelete, reward)

    local doesUserHaveMission, missionId = GetUserMissionId(user_id)
    if doesUserHaveMission then

        local missionData = GlobalState["vehicleMissionsActive"][missionId]
        local ent = NetworkGetEntityFromNetworkId(missionData["vehNet"])
        if DoesEntityExist(ent) then

            local deleteDelay = delayedVehicleDelete and 30000 or 1
            PrintDebug("^3[!] ^0Deletando o veículo em ^3" .. deleteDelay .. "^0ms")

            SetTimeout(deleteDelay, function()

                local vehicleOwner = NetworkGetEntityOwner(ent)
                if vehicleOwner and vehicleOwner ~= 0 then
                    TriggerClientEvent("vehicle:delete", vehicleOwner, missionData["vehNet"])
                else
                    DeleteEntity(ent)
                end

            end)

            if reward then

                local ped = GetPlayerPed(source)
                if not ped or ped == 0 or not DoesEntityExist(ped) then
                    goto updateGlobalState
                end

                local deliveryCoords = Config["missionDeliveryZones"][missionId]["deliveryCoords"]
                local vehicleCoords = GetEntityCoords(ent)
                local dist = #(vehicleCoords - vector3(deliveryCoords[1], deliveryCoords[2], deliveryCoords[3]))

                if dist <= Config["distanceToDelivery"] then
                    TriggerClientEvent("Notify", source, "verde", "Parabéns, a entrega foi finalizada com sucesso. Logo enviaremos seu pagamento!", 8000)
                end
            end
        end

        ::updateGlobalState::
        UpdateGlobalState("vehicleMissionsActive", missionId, false)
    end
end