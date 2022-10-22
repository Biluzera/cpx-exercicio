-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEGLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function UpdateGlobalState(stateBag, key, value)
    local data = GlobalState[stateBag]
    data[key] = value
    GlobalState[stateBag] = data

    PrintDebug("Updated state bag " .. stateBag .. " with key " .. key .. " and value " .. tostring(value))
end