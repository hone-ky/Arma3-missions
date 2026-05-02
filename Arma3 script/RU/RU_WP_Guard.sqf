if (isserver) then {
    _trigger = thisTrigger;
    _triggerPosATL = getPosATL oppspawner;

    _groupConfigs = [
        (configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_des_infantry" >> "rhs_group_rus_msv_des_infantry_squad"),
        (configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_des_infantry" >> "rhs_group_rus_msv_des_infantry_squad_2mg"),
        (configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_des_infantry" >> "rhs_group_rus_msv_des_infantry_section_AT"),
        (configFile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_des_infantry" >> "rhs_group_rus_msv_des_infantry_fireteam")
    ];

    _vehicleConfigs = [
        ("rhs_btr70_msv"),
        ("rhs_tiger_sts_3camo_msv")
    ];

    _eastUnitsInTrigger = ({side _x == east} count thisList);

    if (_eastUnitsInTrigger <= 20) then {
        {
            _rNumber = random 3;
            for "_i" from 1 to _rNumber do {
                _centerObj = createVehicle ["Land_WaterBottle_01_cap_F", _triggerPosATL, [], 150, "NONE"];
                _centerObjPosASL = getPosASL _centerObj;
                _group = [_centerObjPosASL, east, _x] call BIS_fnc_spawnGroup;
                _wp = _group addWaypoint [_centerObjPosASL, 0];
                _wp setWaypointType "GUARD";
                _wp setWaypointBehaviour "SAFE";
                _wp setWaypointSpeed "LIMITED";
            };
        } foreach _groupConfigs;

        {
            _rNumberVehicle = random 2;
                for "_i" from 1 to _rNumberVehicle do {
                _Vehicle = createVehicle [_x, _triggerPosATL, [], 150];
                _crew = createVehicleCrew _Vehicle;
                _VehiclePosATL = getPosATL _Vehicle;
                _Vehicle setPos [_VehiclePosATL select 0, _VehiclePosATL select 1, (_VehiclePosATL select 2) + 5];
                _wpVehicle = _crew addWaypoint [_VehiclePosATL, 0];
                _wpVehicle setWaypointType "GUARD";
                _wpVehicle setWaypointBehaviour "SAFE";
                _wpVehicle setWaypointSpeed "LIMITED";
            };
        } foreach _vehicleConfigs;
    };
};