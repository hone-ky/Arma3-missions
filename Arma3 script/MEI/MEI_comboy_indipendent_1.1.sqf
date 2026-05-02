if (isserver) then {
    _vehicleConfigs = [
        ("UK3CB_MEI_I_V3S_Reammo"),
        ("UK3CB_MEI_I_V3S_Refuel"),
        ("UK3CB_MEI_I_V3S_Repair"),
        ("UK3CB_MEI_I_V3S_Open"),
        ("UK3CB_MEI_I_Van_Fuel"),
        ("UK3CB_MEE_I_M113tank_supply")
    ];

    if (isNil "HQVehicleSpawnPosition") then {
        diag_log "Error: HQVehicleSpawnPosition marker not found.";
        return;
    };

    _randomIndexVehicle = floor random (count _vehicleConfigs);
    _selectedVehicle = _vehicleConfigs select _randomIndexVehicle;

    _vehicle = createVehicle [_selectedVehicle, getMarkerPos "HQVehicleSpawnPosition", [], 0, "CAN_COLLIDE"];

    if (isNull _vehicle) then {
        diag_log format ["Error: Failed to create vehicle %1.", _selectedVehicle];
        return;
    };

    _vehicleGroup = createGroup civilian;
    {
        _unit = _vehicleGroup createUnit [_x, getPosATL _vehicle, [], 0, "NONE"];
        _unit moveInDriver _vehicle;
    } forEach crew _vehicle;

    _crewUnits = units _vehicleGroup;
    deleteGroup _vehicleGroup;

    if (isArray _crewUnits) then {
        _waypointsData = [
            ["Offar", "MOVE"],
            ["MEIHQ", "MOVE"],
            ["Offar", "CYCLE"]
        ];

        {
            _unit = _x;

            {
                _markerName = _x select 0;
                _waypointType = _x select 1;

                if (isNil _markerName) then {
                    diag_log format ["Error: Marker %1 not found.", _markerName];
                } else {
                    _wp = _unit addWaypoint [getMarkerPos _markerName, -1];
                    _wp setWaypointType _waypointType;
                    _wp setWaypointBehaviour "SAFE";
                    _wp setWaypointSpeed "LIMITED";
                };
            } forEach _waypointsData;
        } forEach _crewUnits;
    } else {
        diag_log "Error: Failed to get an array of crew units.";
        deleteVehicle _vehicle;
        return;
    };

    _vehiclePosATL = getPosATL _vehicle;
    _vehicle setPos [_vehiclePosATL select 0, _vehiclePosATL select 1, _vehiclePosATL select 2];
};