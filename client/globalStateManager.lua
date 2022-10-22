-----------------------------------------------------------------------------------------------------------------------------------------
-- STATE BAG CHANGE: vehicleMissionConfig
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("vehicleMissionConfig", nil, function(bagName, key, value, reserved, replicated)
    Config = value

    PrintDebug("[!] Global State vehicleMissionConfig updated")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATE BAG CHANGE: vehicleMissionsActive
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("vehicleMissionsActive", nil, function(bagName, key, value, reserved, replicated)

    UpdateMissionBlip(value)

    PrintDebug("[!] Global State vehicleMissionsActive updated: " .. (type(value) == "table" and json.encode(value) or tostring(value)))
end)