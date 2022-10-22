-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp","lib/Proxy")
local Tunnel = module("vrp","lib/Tunnel")
ResourceName = GetCurrentResourceName()
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Client = {}
Tunnel.bindInterface(ResourceName,Client)
Server = Tunnel.getInterface(ResourceName)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
MissionActive = false
MissionData = {}
local inMissionAreaId = 0
Config = GlobalState["vehicleMissionConfig"]
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAINTHREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()

    Wait(500)

    while true do
        local timeDistance = 999
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        if not MissionActive then
            timeDistance = 500

            if inMissionAreaId == 0 then


                for k, v in pairs(Config["missionInitZones"]) do
                    local dist = #(coords - vector3(v[1], v[2], v[3]))
                    if dist <= Config["minZoneDistance"] then
                        inMissionAreaId = k

                        local chance = math.random(100)
                        if chance <= Config["getMissionChance"] then

                            local anyMissionFree, missionId = IsAnyMissionFree()
                            if anyMissionFree then
                                MissionActive, MissionData = Server.requestMission(missionId)

                                if MissionActive then
                                    StartMission()
                                    TriggerEvent("Notify", "verde", "Missão iniciada, verifique seu GPS para mais informações.", 8000)
                                end
                            end

                        end

                        break
                    end
                end

            else
                local zoneCoords = Config["missionInitZones"][inMissionAreaId]
                local dist = #(coords - vector3(zoneCoords[1], zoneCoords[2], zoneCoords[3]))

                if dist > Config["minZoneDistance"] then
                    inMissionAreaId = 0
                end
            end
        end

        Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISANYMISSIONFREE
-----------------------------------------------------------------------------------------------------------------------------------------
function IsAnyMissionFree()
    local missionsActive = GlobalState["vehicleMissionsActive"]
    for k, v in pairs(Config["missionDeliveryZones"]) do
        if not missionsActive[k] then
            return true, k
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function StartMission()

    CreateThread(function()

        CreateMissionPeds()

        while true do
            local timeDistance = 4
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)

            local vehNet = MissionData["vehNet"]
            if not NetworkDoesNetworkIdExist(vehNet) then
                return
            end

            local vehicle = NetworkGetEntityFromNetworkId(vehNet)
            if not DoesEntityExist(vehicle) then
                ForceMissionFinish(false)
                PrintDebug("Canceling mission, vehicle deleted")
                return
            end

            if not MissionVehicleBlip then
                UpdateMissionVehicleBlip(vehicle, true)
            end

            if GetVehicleEngineHealth(vehicle) <= 300.0 or GetEntityHealth(ped) <= 101 then
                NetworkExplodeVehicle(vehicle, true, false, 0)
                ForceMissionFinish(true)
                PrintDebug("Finishing mission, vehicle damaged or player died")
                return
            end

            if not IsAnyPedAlive() then

                local vehicleCoords = GetEntityCoords(vehicle)
                local deliveryCoords = Config["missionDeliveryZones"][MissionData["missionId"]]["deliveryCoords"]

                DrawTxt("ENTREGUE O ~b~VEÍCULO ~w~NO LOCAL ~b~DEMARCADO~w~", 0.5, 0.87)

                if IsPedInAnyVehicle(ped, false) then
                    local vehiclePedIsIn = GetVehiclePedIsIn(ped, false)
                    if vehiclePedIsIn == vehicle and GetPedInVehicleSeat(vehicle, -1) == ped then
                        DrawMarker(0, deliveryCoords[1], deliveryCoords[2], deliveryCoords[3] - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 8.75, 8.75, 0.0, 43, 141, 240, 70, 0, 0, 0, 0)

                        local dist = #(vehicleCoords - vector3(deliveryCoords[1], deliveryCoords[2], deliveryCoords[3]))
                        if dist <= Config["distanceToDelivery"] and IsControlJustPressed(0,38) then
                            ResetVariables()
                            Server.finishMission(false, true)
                        end
                    end
                end

            else
                DrawTxt("~b~DERROTE ~w~TODOS OS ~b~INIMIGOS~w~", 0.5, 0.87)
            end

            Wait(timeDistance)
        end
    end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETVARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
function ResetVariables()
    MissionActive = false
    MissionData = {}
    UpdateMissionVehicleBlip(false, false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISHMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function ForceMissionFinish(delayed)
    ResetVariables()
    Server.finishMission(delayed)
    KillPedsStealthly()
end