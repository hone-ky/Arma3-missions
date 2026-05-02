_trigger = getPosATL thistrigger ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 8000, "none"];
_centerobjPS = getPosASL _centerobj;
_landLocation = locationPosition nearestLocation [_centerobjPS, "NameLocal"];
_landLocation set [2, 0];
_obj = createVehicle ["VirtualReammoBox_camonet_F", _landLocation, [], 100, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["Item_AntimalaricumVaccine", _objPS, [], 5, "none"];  
_obj1PS = getPosATL _obj1;

_rNumber = random 5 ;
for "_i" from 0 to _rNumber do {
    _grp = createGroup independent;
    _unit = _grp createUnit ["UK3CB_CCM_I_AT", _landLocation, [], 500, "NONE"];
for "_i" from 1 to 4 do {
    _wp = _grp addWaypoint [ _landLocation, 300 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _grp addWaypoint [ getWPPos [_grp, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 5 ;
for "_i" from 1 to _rNumber do {
    _grp = createGroup independent;
    _unit = _grp createUnit ["UK3CB_CCM_I_COM", _landLocation, [], 500, "NONE"];
for "_i" from 1 to 4 do {
    _wp = _grp addWaypoint [ _landLocation, 300 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _grp addWaypoint [ getWPPos [_grp, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 5 ;
for "_i" from 1 to _rNumber do {
    _grp = createGroup independent;
    _unit = _grp createUnit ["UK3CB_CCM_I_AR", _landLocation, [], 500, "NONE"];
for "_i" from 1 to 4 do {
    _wp = _grp addWaypoint [ _landLocation, 300 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _grp addWaypoint [ getWPPos [_grp, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 5 ;
for "_i" from 1 to _rNumber do {
    _grp = createGroup independent;
    _unit = _grp createUnit ["UK3CB_CCM_I_DEM", _landLocation, [], 500, "NONE"];
for "_i" from 1 to 4 do {
    _wp = _grp addWaypoint [ _landLocation, 300 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _grp addWaypoint [ getWPPos [_grp, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 5 ;
for "_i" from 1 to _rNumber do {
    _grp = createGroup independent;
    _unit = _grp createUnit ["UK3CB_CCM_I_RIF_3", _landLocation, [], 500, "NONE"];
for "_i" from 1 to 4 do {
    _wp = _grp addWaypoint [ _landLocation, 300 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _grp addWaypoint [ getWPPos [_grp, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 5 ;
for "_i" from 1 to _rNumber do {
    _grp = createGroup independent;
    _unit = _grp createUnit ["UK3CB_CCM_I_RIF_2", _landLocation, [], 500, "NONE"];
for "_i" from 1 to 4 do {
    _wp = _grp addWaypoint [ _landLocation, 300 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _grp addWaypoint [ getWPPos [_grp, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 5 ;
for "_i" from 1 to _rNumber do {
    _grp = createGroup independent;
    _unit = _grp createUnit ["UK3CB_CCM_I_RIF_1", _landLocation, [], 500, "NONE"];
for "_i" from 1 to 4 do {
    _wp = _grp addWaypoint [ _landLocation, 300 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _grp addWaypoint [ getWPPos [_grp, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 5 ;
for "_i" from 1 to _rNumber do {
    _grp = createGroup independent;
    _unit = _grp createUnit ["UK3CB_CCM_I_RIF_LITE", _landLocation, [], 500, "NONE"];
for "_i" from 1 to 4 do {
    _wp = _grp addWaypoint [ _landLocation, 300 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _grp addWaypoint [ getWPPos [_grp, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 5 ;
for "_i" from 1 to _rNumber do {
    _grp = createGroup independent;
    _unit = _grp createUnit ["UK3CB_CCM_I_RIF_BOLT", _landLocation, [], 500, "NONE"];
for "_i" from 1 to 4 do {
    _wp = _grp addWaypoint [ _landLocation, 300 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _grp addWaypoint [ getWPPos [_grp, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 5 ;
for "_i" from 1 to _rNumber do {
    _grp = createGroup independent;
    _unit = _grp createUnit ["UK3CB_CCM_I_SNI", _landLocation, [], 500, "NONE"];
for "_i" from 1 to 4 do {
    _wp = _grp addWaypoint [ _landLocation, 300 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _grp addWaypoint [ getWPPos [_grp, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_centerobj = createVehicle ["Land_WaterBottle_01_cap_F", _objPS, [], 50, "none"];  
_centerobjPS = getPosATL _centerobj;
_SpecOps = [_centerobjPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_ION_O_Woodland" >> "SpecOps" >> "UK3CB_ION_O_Woodland_Recon_SpecSquad")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _SpecOps addWaypoint [ _centerobjPS, 50 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _SpecOps addWaypoint [ getWPPos [_grp, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";

_marker17 = createMarker ["Marker17", _landLocation];
"Marker17" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _landLocation, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'Marker17';", ""];