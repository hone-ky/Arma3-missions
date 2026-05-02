if (isserver) then {
_trigger = getPosATL thistrigger ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 3500, "none"];
_centerobjPS = getPosASL _centerobj;
_rNumber = random 40 ;
_landLocation = if ( _rNumber > 45 ) then {
    locationPosition nearestLocation [_centerobjPS, "NameCity"];
} else {
    if ( 20 > _rNumber ) then {
        locationPosition nearestLocation [_centerobjPS, "Namevillage"];
    } else {
        locationPosition nearestLocation [_centerobjPS, "Namelocal"];
    };
};
_landLocation set [2, 0];
_obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 500, "none"];  
_objPS = getPosATL _obj;

_rNumber = random 2 ;
for "_i" from 0 to _rNumber do {
    _MEI_HQ = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_MEI_O" >> "Infantry" >> "UK3CB_MEI_O_RIF_01_Squad")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _MEI_HQ addWaypoint [ _objPS, 50 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _MEI_HQ addWaypoint [ getWPPos [_MEI_HQ, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_marker = createMarker ["kunduz1", _objPS];
"kunduz1" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _objPS, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'kunduz1';", ""];
};