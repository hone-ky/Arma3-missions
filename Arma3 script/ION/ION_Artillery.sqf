_trigger6 = getPosATL trigger6 ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger6, [], 15000, "none"];
_centerobjPS = getPosASL _centerobj;
_landLocation = locationPosition nearestLocation [_centerobjPS, "NameCity"];
_landLocation set [2, 0];
_obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 500, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["Land_Cargo_House_V1_F", _objPS, [], 500, "none"]; 
_obj1PS = getPosATL _obj1;
_obj2 = createVehicle ["Land_Communication_F", _obj1PS, [], 20, "none"];
_obj2PS = getPosATL _obj2;
_obj3 = createVehicle ["Land_PowerGenerator_F", _obj2PS, [], 5, "none"];
_obj4 = createVehicle ["rhs_D30_msv", _obj2PS, [], 30, "none"];

OP_HQ_squad = [_obj2PS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_ION_O_Woodland" >> "Infantry" >> "UK3CB_ION_O_Woodland_HQ_FireTeam")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = OP_HQ_squad addWaypoint [ _obj1PS, 50 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = OP_HQ_squad addWaypoint [ _obj1PS, 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";

_rNumber = random 2 ;
for "_i" from 0 to _rNumber do {
    _ION_sentry = [_obj2PS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_ION_O_Woodland" >> "Infantry" >> "UK3CB_ION_O_Woodland_AR_FireTeam")] call BIS_fnc_spawnGroup;
    for "_i" from 1 to 4 do {
        _wp = _ION_sentry addWaypoint [ _obj1PS, 300 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _ION_sentry addWaypoint [ _obj2PS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 1 ;
for "_i" from 0 to _rNumber do {
    _ION_QRF = [_obj2PS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_ION_O_Woodland" >> "Infantry" >> "UK3CB_ION_O_Woodland_MG_Squad")] call BIS_fnc_spawnGroup;
    _wp = _ION_QRF addWaypoint [ _obj1PS, 150 ] ;
    _wp setWaypointType "move";
    _wpPS = getWPPos [_ION_QRF, 1];
    for "_i" from 1 to 10 do {
        _wp = __ION_QRF addWaypoint [ _wpPS, 100 ] ;
        _wp setWaypointType "move";
    };
    _wp = _ION_QRF addWaypoint [ _wpPS, 0];
    _wp setWaypointType "cycle";
};

_centerobj = createVehicle ["Land_WaterBottle_01_cap_F", _obj1PS, [], 500, "none"];  
_centerobjPS = getPosATL _centerobj;
_SpecOps = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_ION_O_Woodland" >> "SpecOps" >> "UK3CB_ION_O_Woodland_Recon_SpecSquad")] call BIS_fnc_spawnGroup;
_wp = _SpecOps addWaypoint [ _centerobjPS, 1000 ] ;
_wp setWaypointType "move";
_wpPS = getWPPos [_SpecOps, 1];
for "_i" from 1 to 10 do {
    _wp = _SpecOps addWaypoint [ _wpPS, 1000 ] ;
    _wp setWaypointType "move";
};
_wp = _SpecOps addWaypoint [ _centerobjPS, 0];
_wp setWaypointType "cycle";

_marker6 = createMarker ["Marker6", _obj1ps];
"Marker6" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _obj1PS, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'Marker6';", ""];