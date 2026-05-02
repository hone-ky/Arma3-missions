_trigger3 = getPosATL trigger3 ;

_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger3, [], 15000, "none"];
_centerobjPS = getPosASL _centerobj;
_rNumber = random 40 ;
_landLocation = if ( _rNumber > 30 ) then {
    locationPosition nearestLocation [_centerobjPS, "NameCityCapital"];
} else {
    locationPosition nearestLocation [_centerobjPS, "NameCity"];
};
_landLocation set [2, 0];

_centerobj1 = createVehicle ["Land_WaterBottle_01_cap_F",_trigger3, [], 15000, "none"];
_centerobj1PS = getPosASL _centerobj1;
_rNumber = random 40 ;
_landLocation1 = if ( _rNumber > 30 ) then {
    locationPosition nearestLocation [_centerobj1PS, "NameCityCapital"];
} else {
    locationPosition nearestLocation [_centerobj1PS, "NameCity"];
};
_landLocation1 set [2, 0];

_obj = createVehicle ["RuggedTerminal_01_communications_F", _landLocation1, [], 100, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["UK3CB_BAF_Vehicles_Servicing_Ground_Point", _objPS, [], 10, "none"];

_obj2 = createVehicle ["RuggedTerminal_01_communications_F", _landLocation, [], 500, "none"];  
_obj2PS = getPosATL _obj2;
_obj3 = createVehicle ["UK3CB_BAF_Vehicles_Servicing_Ground_Point", _obj2PS, [], 10, "none"];

_msv_HQ_squad = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_chq")] call BIS_fnc_spawnGroup;
_nBuilding = nearestBuilding _objPS;
_nBuildingPS = getPosATL _nBuilding;
_wp = _msv_HQ_squad addWaypoint [ _nBuildingPS, 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";

_rNumber = random 4 ;
for "_i" from 0 to _rNumber do {
    _msv_squad = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad")] call BIS_fnc_spawnGroup;
    for "_i" from 1 to 4 do {
        _wp = _msv_squad addWaypoint [ _landLocation1, 300 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _msv_squad addWaypoint [ _objPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_msv_convoy_protect = [_obj2PS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_Ural" >> "rhs_group_rus_msv_Ural_squad")] call BIS_fnc_spawnGroup;
_wp = _msv_convoy_protect addWaypoint [ _objPS, 0 ] ;
_wp setWaypointType "move";
_wp setWaypointBehaviour "safe";
_wp setWaypointSpeed "LIMITED";

_rNumber = random 4 ;
for "_i" from 0 to _rNumber do {
    _btr = createVehicle ["rhs_btr80_msv", _obj2PS, [], 30];
    _grp = createVehicleCrew _btr;
    _wp = _grp addWaypoint [ _objPS, 0 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "aware";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 6 ;
for "_i" from 0 to _rNumber do {
    _ammotruck = createVehicle ["rhs_ural_ammo_msv_01", _obj2PS, [], 30];
    _grp = createVehicleCrew _ammotruck;
    _wp = _grp addWaypoint [ _objPS, 0 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "aware";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 6 ;
for "_i" from 0 to _rNumber do {
    _fueltruck = createVehicle ["rhs_ural_fuel_msv_01", _obj2PS, [], 30];
    _grp = createVehicleCrew _fueltruck;
    _wp = _grp addWaypoint [ _objPS, 0 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "aware";
    _wp setWaypointSpeed "LIMITED";
};

_marker1 = createMarker ["Marker1", _landLocation];
"Marker1" setMarkerType "hd_start";
_marker1 = createMarker ["Marker2", _landLocation1];
"Marker2" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _landlocation1, false];
_trg setTriggerArea [500, 500, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'Marker1';
deleteMarker 'Marker2';", ""];