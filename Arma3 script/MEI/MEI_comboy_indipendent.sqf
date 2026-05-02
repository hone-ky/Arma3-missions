if (isserver) then {
    _triggerPosATL = getPosATL thisTrigger;

    _vehicleConfigs = [
        ("UK3CB_MEI_I_V3S_Reammo"),
        ("UK3CB_MEI_I_V3S_Refuel"),
        ("UK3CB_MEI_I_V3S_Repair"),
        ("UK3CB_MEI_I_V3S_Open"),
        ("UK3CB_MEI_I_Van_Fuel"),
        ("UK3CB_MEE_I_M113tank_supply")
    ];

    _randomIndexVehicle = floor random (count _vehicleConfigs);
    _selectedVehicle = _vehicleConfigs select _randomIndexVehicle;

    _Vehicle = createVehicle [_selectedVehicle, getMarkerPos HQVehicleSpawnPosition, [], 0];
    _crew = createVehicleCrew _Vehicle;
    _VehiclePosATL = getPosATL _Vehicle;
    _Vehicle setPos [_VehiclePosATL select 0, _VehiclePosATL select 1, (_VehiclePosATL select 2) + 5];
    _wpVehicle = _crew addWaypoint [getMarkerPos Offar, -1];
    _wpVehicle setWaypointType "MOVE";
    _wpVehicle setWaypointBehaviour "SAFE";
    _wpVehicle setWaypointSpeed "LIMITED";
    _wpVehicle = _crew addWaypoint [getMarkerPos MEIHQ, -1];
    _wpVehicle setWaypointType "MOVE";
    _wpVehicle setWaypointBehaviour "SAFE";
    _wpVehicle setWaypointSpeed "LIMITED";
    _wpVehicle = _crew addWaypoint [getMarkerPos Offar, -1];
    _wpVehicle setWaypointType "cycle";
    _wpVehicle setWaypointBehaviour "SAFE";
    _wpVehicle setWaypointSpeed "LIMITED";
};