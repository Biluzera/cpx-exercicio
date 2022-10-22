-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["vehicleMissionConfig"] = {

    -- Debug para habilitar os prints
    ["debug"] = true,

    -- Coordenadas em que será possível adquirir uma missão
    ["missionInitZones"] = {
        {-2095.74,-319.91,12.77}
    },

    -- Coordenadas em que será possível o jogador entregar o veículo
    ["missionDeliveryZones"] = {
        {
            ["deliveryCoords"] = {-1660.0,-223.12,54.96},
            ["vehicleSpawnCoords"] = {-2064.51,-302.84,13.14,170.08}
        },
    },

    -- Range mínimo para ser considerado dentro da zona
    ["minZoneDistance"] = 20,

    -- Porcentagem do jogador receber uma missão ao entrar em uma zona
    ["getMissionChance"] = 20,

    -- Margens da quantidade de npcs que serão spawnados
    ["pedAmount"] = {10, 20},

    -- Raio em que os peds poderão nascer (ponto central é o deliveryCoords)
    ["pedSpawnRadius"] = 5,

    -- Distância para entregar o veículo
    ["distanceToDelivery"] = 10,

    -- Possíveis modelos de veículos que serão criados para a missão
    ["vehicleModels"] = {
        `KURUMA`,
        `ZENTORNO`,
        `SUGOI`,
        `SEVEN70`,
        `SCHLAGEN`
    },

    -- Possíveis armas que os peds poderão receber para confrontar o jogador
    ["pedWeapons"] = {
        `WEAPON_PISTOL`,
        `WEAPON_COMBATPISTOL`,
        `WEAPON_APPISTOL`,
        `WEAPON_PISTOL50`,
        `WEAPON_MICROSMG`,
        `WEAPON_SMG`,
        `WEAPON_ASSAULTSMG`,
        `WEAPON_ASSAULTRIFLE`,
        `WEAPON_CARBINERIFLE`,
        `WEAPON_ADVANCEDRIFLE`,
        `WEAPON_MG`,
        `WEAPON_COMBATMG`,
        `WEAPON_PUMPSHOTGUN`,
        `WEAPON_SAWNOFFSHOTGUN`,
        `WEAPON_ASSAULTSHOTGUN`,
        `WEAPON_BULLPUPSHOTGUN`
    },

    -- Possíveis skins dos peds que serão criados
    ["pedSkins"] = {
        `ig_abigail`,
        `a_m_m_fatlatin_01`,
        `a_m_m_acult_01`,
        `a_m_m_afriamer_01`,
        `ig_mp_agent14`,
    },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHAREDVARIABLES - GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["vehicleMissionsActive"] = {}