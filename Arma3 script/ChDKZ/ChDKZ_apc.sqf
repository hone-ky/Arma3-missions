_trigger7 = getPosATL thistrigger ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger7, [], 8000, "none"];
_centerobjPS = getPosASL _centerobj;
_landLocation = locationPosition nearestLocation [_centerobjPS, "NameCity"];
_landLocation set [2, 0];
_obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 1000, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["Land_WaterBottle_01_cap_F", _objPS, [], 300, "none"];  
_obj1PS = getPosATL _obj1;

_rNumber = random 1 ;
for "_i" from 0 to _rNumber do {
    _hilux = createVehicle ["UK3CB_CHD_O_BMD1", _obj1PS, [], 50];
    _grp = createVehicleCrew _hilux;
    _hiluxPS = getPosATL _hilux;
    _hilux setpos [getPos _hilux select 0, getPos _hilux select 1, (getPos _hilux select 2) +5];
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _obj1PS, 300 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _hiluxPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 4 ;
for "_i" from 0 to _rNumber do {
    _MEI_sentry = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_CHD_O" >> "Infantry" >> "UK3CB_CHD_O_AT_Squad")] call BIS_fnc_spawnGroup;
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

_marker14 = createMarker ["Marker14", _obj1PS];
"Marker14" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _obj1PS, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'Marker14';", ""];