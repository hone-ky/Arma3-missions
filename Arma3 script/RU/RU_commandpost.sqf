_trigger = getPosATL thistrigger ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 8000, "none"];
_centerobjPS = getPosASL _centerobj;
_rNumber = random 40 ;
_landLocation = if ( _rNumber > 30 ) then {
    locationPosition nearestLocation [_centerobjPS, "NameCity"];
} else {
    locationPosition nearestLocation [_centerobjPS, "Namevillage"];
};
_landLocation set [2, 0];
_obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 2000, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["Land_Cargo_House_V1_F", _objPS, [], 500, "none"]; 
_obj1PS = getPosATL _obj1;
_obj2 = createVehicle ["Land_Communication_F", _obj1PS, [], 20, "none"];
_obj2PS = getPosATL _obj2;
_obj3 = createVehicle ["Land_PowerGenerator_F", _obj2PS, [], 5, "none"];

_RU_HQ = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_chq")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _RU_HQ addWaypoint [ _objPS, 50 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _RU_HQ addWaypoint [ getWPPos [_RU_HQ, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";

_rNumber = random 5 ;
for "_i" from 1 to _rNumber - 4 do {
    _hilux = createVehicle ["rhs_btr70_msv", _obj1PS, [], 300];
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

_rNumber = random 5 ;
for "_i" from 0 to _rNumber do {
    _RU_sentry = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_fireteam")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _RU_sentry addWaypoint [ _objPS, 400 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _RU_sentry addWaypoint [ getWPPos [_RU_sentry, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 3 ;
for "_i" from 0 to _rNumber do {
    _RU_QRF = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _RU_QRF addWaypoint [ _objPS, 200 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _RU_QRF addWaypoint [ getWPPos [_RU_QRF, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_marker = createMarker ["beketov1", _obj1ps];
"beketov1" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _obj1PS, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'beketov1';", ""];