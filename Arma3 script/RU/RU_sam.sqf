if (isServer) then {
_trigger = getPosATL thistrigger ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 8000, "none"];
_centerobjPS = getPosASL _centerobj;
_rNumber = random 40 ;
_landLocation = if ( _rNumber > 30 ) then {
    locationPosition nearestLocation [_centerobjPS, "NameCity"];
} else {
    if ( _rNumber > 15 ) then {
        locationPosition nearestLocation [_centerobjPS, "Namevillage"];
    } else {
        locationPosition nearestLocation [_centerobjPS, "Namelocal"];
    };
};
_landLocation set [2, 0];
_obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 2000, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["Land_WaterBottle_01_cap_F", _objPS, [], 500, "none"]; 
_obj1PS = getPosATL _obj1;

_RU_Guard = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "min_rf" >> "Infantry" >> "min_rf_InfSquad")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _RU_Guard addWaypoint [ _obj1PS, 50 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _RU_Guard addWaypoint [ getWPPos [_RU_Guard, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";

_rNumber = random 5 ;
for "_i" from 5 to _rNumber do {
    _btr70 = createVehicle ["rhs_btr70_msv", _obj1PS, [], 300];
    _grp = createVehicleCrew _btr70;
    _btr70PS = getPosATL _btr70;
    _btr70 setpos [getPos _btr70 select 0, getPos _btr70 select 1, (getPos _btr70 select 2) +5];
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _obj1PS, 300 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _btr70PS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 3 ;
for "_i" from 0 to _rNumber do {
    _SAM = createVehicle ["O_R_SAM_System_04_F", _obj1PS, [], 30];
    _grp = createVehicleCrew _SAM;
};

_Radar = createVehicle ["O_R_Radar_System_02_F", _obj1PS, [], 30];
_grp = createVehicleCrew _Radar;

_marker = createMarker ["beketov5", _obj1ps];
"beketov5" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _obj1PS, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'beketov5';", ""];
};