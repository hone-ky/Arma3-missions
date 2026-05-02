if (isServer) then {
_trigger7 = getPosATL thistrigger ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger7, [], 15000, "none"];
_centerobjPS = getPosASL _centerobj;
_landLocation = locationPosition nearestLocation [_centerobjPS, "NameCity"];
_landLocation set [2, 0];
_obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 1000, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["Land_WaterBottle_01_cap_F", _objPS, [], 300, "none"];  
_obj1PS = getPosATL _obj1;

_rNumber = random 4 ;
for "_i" from 0 to _rNumber * 5 do {
    _MEI_sentry = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhsgref_group_chdkz_insurgents_infantry" >> "rhsgref_group_chdkz_insurgents_squad")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _MEI_sentry addWaypoint [ _obj1PS, 100 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "AWARE";
    _wp = _MEI_sentry addWaypoint [ _obj1PS, 100 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _MEI_sentry addWaypoint [ getWPPos [_MEI_sentry, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_marker14 = createMarker ["ChDKZ_Town_inf", _obj1PS];
"ChDKZ_Town_inf" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _obj1PS, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'ChDKZ_Town_inf';", ""];
};