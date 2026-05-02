if (isserver) then {
    _triggerPosATL = getPosATL thisTrigger;

    _groupConfigs = [
        (configFile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_RIF_01_Squad"),
        (configFile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_RIF_01_FireTeam"),
        (configFile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_RIF_Sentry"),
        (configFile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_AT_FireTeam")
    ];

    _eastUnitsInTrigger = ({side _x == independent} count thisList);

    if (_eastUnitsInTrigger <= 70) then {
        {
            _rNumber = random 5;
            for "_i" from 1 to _rNumber do {
                _centerObj = createVehicle ["Land_WaterBottle_01_cap_F", _triggerPosATL, [], 1500, "NONE"];
                _centerObjPosASL = getPosASL _centerObj;
                _group = [_centerObjPosASL, independent, _x] call BIS_fnc_spawnGroup;
                _wp = _group addWaypoint [_centerObjPosASL, 0];
                _wp setWaypointType "GUARD";
                _wp setWaypointBehaviour "SAFE";
                _wp setWaypointSpeed "LIMITED";
            };
        } foreach _groupConfigs;

        _rNumberHilux = random 5;
        for "_i" from 1 to _rNumberHilux do {
            _hilux = createVehicle ["UK3CB_MEI_Hilux_Pkm", _triggerPosATL, [], 1500];
            _crew = createVehicleCrew _hilux;
            _hiluxPosATL = getPosATL _hilux;
            _hilux setPos [_hiluxPosATL select 0, _hiluxPosATL select 1, (_hiluxPosATL select 2) + 5];
            _wpHilux = _crew addWaypoint [_hiluxPosATL, 0];
            _wpHilux setWaypointType "GUARD";
            _wpHilux setWaypointBehaviour "SAFE";
            _wpHilux setWaypointSpeed "LIMITED";
        };
    };
};