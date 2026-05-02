_trigger4 = getPosATL trigger4 ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger4, [], 12000, "none"];
_centerobjPS = getPosASL _centerobj;
_rNumber = random 40 ;
_landLocation = locationPosition nearestLocation [_centerobjPS, "NameLocal"];
_landLocation set [2, 0];
_obj = createVehicle ["UK3CB_BAF_Vehicles_Servicing_Ground_Point", _landLocation, [], 100, "none"];
_objPS = getPosATL _obj;
_obj1 = createVehicle ["rhs_9k79_B", _objPS, [], 10, "none"];
_obj1 setpos [getPos _obj1 select 0, getPos _obj1 select 1, (getPos _obj1 select 2) +10];
_obj1 setDamage 0;

_rNumber = random 3 ;
for "_i" from 0 to _rNumber do {
    _MEI_sentry = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_MEI_O" >> "Infantry" >> "UK3CB_MEI_O_RIF_01_Squad")] call BIS_fnc_spawnGroup;
    for "_i" from 1 to 4 do {
        _wp = _MEI_sentry addWaypoint [ _objPS, 300 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _MEI_sentry addWaypoint [ _objPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 4 ;
for "_i" from 0 to _rNumber do {
    _hilux = createVehicle ["UK3CB_MEI_O_Hilux_Pkm", _objPS, [], 300];
    _grp = createVehicleCrew _hilux;
    _hiluxPS = getPosATL _hilux;
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _landLocation, 300 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _hiluxPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 27 ;
for "_i" from 0 to _rNumber - 30 do {
    _t55 = createVehicle ["UK3CB_MEI_O_T55", _objPS, [], 300];
    _grp = createVehicleCrew _t55;
    _t55PS = getPosATL _t55;
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _landLocation, 300 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _t55PS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_marker4 = createMarker ["Marker4", _landLocation];
"Marker4" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _landlocation, false];
_trg setTriggerArea [500, 500, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'Marker4';", ""];