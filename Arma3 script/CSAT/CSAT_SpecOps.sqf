_trigger5 = getPosATL trigger5 ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger5, [], 15000, "none"];
_centerobjPS = getPosASL _centerobj;
_landLocation = locationPosition nearestLocation [_centerobjPS, "NameLocal"];
_landLocation set [2, 0];
_obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 50, "none"];  
_objPS = getPosATL _obj;
_SpecOps = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_CSAT_W_O" >> "SpecOps" >> "UK3CB_CSAT_W_O_Recon_SpecSquad")] call BIS_fnc_spawnGroup;
_wp = _SpecOps addWaypoint [ _objPS, 500 ] ;
_wp setWaypointType "move";
_wpPS = getWPPos [_SpecOps, 1];
for "_i" from 1 to 4 do {
    _wp = _SpecOps addWaypoint [ _wpPS, 500 ] ;
    _wp setWaypointType "move";
};
_wp = _SpecOps addWaypoint [ _objPS, 0];
_wp setWaypointType "cycle";

_marker5 = createMarker ["Marker5", _landLocation];
"Marker5" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _objPS, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'Marker5';", ""];

{
    _x setskill ['aimingAccuracy',1];
    _x setskill ['aimingShake',1];
    _x setskill ['aimingSpeed',1];
    _x setskill ['commanding',1];
    _x setskill ['courage',1];
    _x setskill ['general',1];
    _x setskill ['reloadSpeed',1];
    _x setskill ['spotDistance',1];
    _x setskill ['spotTime',1];
    _x allowfleeing 0;
} forEach (units _SpecOps);