-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local missionPeds = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITTHREAD - RELATIONSHIP
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    _, PedGroupHash = AddRelationshipGroup("BLZR-MISSION-PEDS")
    _, PlayerGroupHash = AddRelationshipGroup("BLZR-PLAYERS")
    SetRelationshipBetweenGroups(5, PedGroupHash, PlayerGroupHash)

    while not DoesEntityExist(PlayerPedId()) do
        Wait(500)
    end

    SetPedRelationshipGroupHash(PlayerPedId(), PlayerGroupHash)
    PrintDebug("[!] Setting ped relationship between player and mission npcs")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUPPEDATTRIBUTES
-----------------------------------------------------------------------------------------------------------------------------------------
function SetupPedAttributes(ped)
    if DoesEntityExist(ped) then
       SetEntityMaxHealth(ped, 200)
       SetEntityHealth(ped, GetEntityMaxHealth(ped))
       SetPedAccuracy(ped, 30)
       SetPedAlertness(ped, 2)
       SetPedAllowedToDuck(ped, true)
       SetPedCanCowerInCover(ped, true)
       SetPedCanRagdoll(ped, true)
       SetPedCanRagdollFromPlayerImpact(ped, true)
       SetPedCanSwitchWeapon(ped, false)
       SetPedCombatAbility(ped, 2)
       SetPedCombatAttributes(ped, 0, true)
       SetPedCombatAttributes(ped, 1, false)
       SetPedCombatAttributes(ped, 2, true)
       SetPedCombatAttributes(ped, 3, true)
       SetPedCombatAttributes(ped, 5, true)
       SetPedCombatAttributes(ped, 20, true)
       SetPedCombatAttributes(ped, 1424  , true)
       SetPedCombatMovement(ped, 1)
       SetPedCombatRange(ped, 2)
       SetPedDiesInWater(ped, false)
       SetPedDiesInstantlyInWater(ped, false)
       SetPedDiesWhenInjured(ped, false)
       SetCanAttackFriendly(ped, false, false)
       SetPedFiringPattern(ped, `FIRING_PATTERN_BURST_FIRE`)
       TaskCombatPed(ped, PlayerPedId(), 0, 16)
       SetPedDropsWeaponsWhenDead(ped, false)

       local randomWeapon = Config["pedWeapons"][math.random(#Config["pedWeapons"])]
       GiveWeaponToPed(ped, randomWeapon, 999, false, true)
       SetPedInfiniteAmmo(ped, true, randomWeapon)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEMISSIONPEDS
-----------------------------------------------------------------------------------------------------------------------------------------
function CreateMissionPeds()

    if not MissionData["missionId"] then
        return
    end

    local pedAmount = math.random(Config["pedAmount"][1], Config["pedAmount"][2])
    local deliveryCoords = Config["missionDeliveryZones"][MissionData["missionId"]]["deliveryCoords"]
    local pedSpawnRadius = Config["pedSpawnRadius"]

    for i = 1, pedAmount do

        local x, y, z = deliveryCoords[1] + math.random( pedSpawnRadius * -1, pedSpawnRadius ), deliveryCoords[2] + math.random( pedSpawnRadius * -1, pedSpawnRadius ), deliveryCoords[3]
        local pedModelHash = Config["pedSkins"][math.random(#Config["pedSkins"])]

        if not HasModelLoaded(pedModelHash) then
            while not HasModelLoaded(pedModelHash) do
                RequestModel(pedModelHash)
                Wait(10)
            end
        end

        local randomHeading = math.random(36099)/100
        missionPeds[i] = CreatePed(5, pedModelHash, x, y, z-0.96, randomHeading, true, true)
        SetEntityAsMissionEntity(missionPeds[i], true, true)
        PlaceObjectOnGroundProperly(missionPeds[i])
        SetupPedAttributes(missionPeds[i])
        SetPedRelationshipGroupHash(missionPeds[i], PedGroupHash)
        CreateEnemyPedBlip(missionPeds[i])
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KILLPEDSSTEALTHLY
-----------------------------------------------------------------------------------------------------------------------------------------
function KillPedsStealthly()
    PrintDebug("[!] Killing peds stealthly")
    for k, v in pairs(missionPeds) do
        if DoesEntityExist(v) and not IsPedDeadOrDying(v) then

            PrintDebug("[!] Killing ped " .. v)

            ClearPedTasksImmediately(v)
            RemoveAllPedWeapons(v, true)
            TaskWanderStandard(v, 10, 10)

            SetTimeout(math.random(5000, 20000), function()

                NetworkFadeOutEntity(v, false, true)

                Wait(1000)

                RemovePedBlip(v)
                SetEntityAsMissionEntity(v, false, false)
                DeleteEntity(v)

                missionPeds[k] = nil
                PrintDebug("[!] Ped " .. v .. " killed")
            end)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISPEDAMISSIONPED
-----------------------------------------------------------------------------------------------------------------------------------------
function IsPedAMissionPed(ped)
    for _, v in pairs(missionPeds) do
        if v == ped then
            return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEPEDBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function RemovePedBlip(ped)
    local blip = GetBlipFromEntity(ped)
    if blip and DoesBlipExist(blip) then
        RemoveBlip(blip)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISANYPEDALIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function IsAnyPedAlive()
    for _, v in pairs(missionPeds) do
        if DoesEntityExist(v) and not IsPedDeadOrDying(v) then
            return true
        end
    end

    return false
end