if (isserver) then {
    _triggerPosATL = getPosATL thisTrigger;

    _vehicleConfigs = [
        "UK3CB_MEI_I_V3S_Reammo",
        "UK3CB_MEI_I_V3S_Refuel",
        "UK3CB_MEI_I_V3S_Repair",
        "UK3CB_MEI_I_V3S_Open",
        "UK3CB_MEI_I_Van_Fuel",
        "UK3CB_MEE_I_M113tank_supply"
    ];

    if (count _vehicleConfigs > 0) then {
        _randomIndexVehicle = floor random (count _vehicleConfigs);
        _selectedVehicle = _vehicleConfigs select _randomIndexVehicle;

        _hqVehicleSpawnPosition = getMarkerPos "HQVehicleSpawnPosition";
        _vehicle = createVehicle [_selectedVehicle, [_hqVehicleSpawnPosition select 0, _hqVehicleSpawnPosition select 1, 0], [], 0];
        _crew = createVehicleCrew _vehicle;
        _vehiclePosATL = getPosATL _vehicle;
        _vehicle setPos [_vehiclePosATL select 0, _vehiclePosATL select 1, (_vehiclePosATL select 2) + 5];
        _wpVehicle = _crew addWaypoint [getMarkerPos "Offar", -1];
        _wpVehicle setWaypointType "MOVE";
        _wpVehicle setWaypointBehaviour "SAFE";
        _wpVehicle setWaypointSpeed "LIMITED";
        _wpVehicle = _crew addWaypoint [getMarkerPos "MEIHQ", -1];
        _wpVehicle setWaypointType "MOVE";
        _wpVehicle setWaypointBehaviour "SAFE";
        _wpVehicle setWaypointSpeed "LIMITED";
        _wpVehicle = _crew addWaypoint [getMarkerPos "Offar", -1];
        _wpVehicle setWaypointType "cycle";
        _wpVehicle setWaypointBehaviour "SAFE";
        _wpVehicle setWaypointSpeed "LIMITED";
    } else {
        diag_log "Error: _vehicleConfigs is empty. No vehicle will be created.";
    };
};