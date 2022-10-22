-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local missionBlips = {}
MissionVehicleBlip = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEMISSIONBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function UpdateMissionBlip(missions)
    for k, v in pairs(missions) do

        if v then
            if not missionBlips[k] then
                local missionCoords = Config["missionDeliveryZones"][v["missionId"]]["deliveryCoords"]
                missionBlips[k] = AddBlipForCoord(missionCoords[1], missionCoords[2], missionCoords[3])

                SetBlipSprite(missionBlips[k],488)
                SetBlipAsShortRange(missionBlips[k],true)
                SetBlipColour(missionBlips[k],3)
                SetBlipScale(missionBlips[k],0.75)

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Missão de entrega de veículo #" .. k)
                EndTextCommandSetBlipName(missionBlips[k])

                if GetPlayerServerId(PlayerId()) == v["source"] then
                    SetBlipRoute(missionBlips[k], true)
                end
            end
        else
            if missionBlips[k] then
                if DoesBlipExist(missionBlips[k]) then
                    RemoveBlip(missionBlips[k])
                    missionBlips[k] = nil
                end
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEMISSIONVEHICLEBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function UpdateMissionVehicleBlip(vehicle, create)

    if create then

        if not DoesEntityExist(vehicle) then
            return
        end

        MissionVehicleBlip = AddBlipForEntity(vehicle)
        SetBlipSprite(MissionVehicleBlip,225)
        SetBlipAsShortRange(MissionVehicleBlip,false)
        SetBlipColour(MissionVehicleBlip,3)
        SetBlipScale(MissionVehicleBlip,0.6)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Veículo para entrega")
        EndTextCommandSetBlipName(MissionVehicleBlip)

    else
        if DoesBlipExist(MissionVehicleBlip) then
            RemoveBlip(MissionVehicleBlip)
        end
        MissionVehicleBlip = false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEENEMYPEDBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function CreateEnemyPedBlip(entity)
    if DoesEntityExist(entity) then
       local entityBlip = AddBlipForEntity(entity)
       SetBlipAsFriendly(entityBlip, false)
    end
 end