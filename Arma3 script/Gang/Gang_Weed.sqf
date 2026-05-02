if (isServer) then {
_trigger = getPosATL thistrigger ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 15000, "none"];
_centerobjPS = getPosASL _centerobj;
_landLocation = locationPosition nearestLocation [_centerobjPS, "NameCity"];
_landLocation set [2, 0];
_obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 1000, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["CUP_BOX_I_NAPA_Ammo_F", _objPS, [], 1000, "none"]; 
_obj1PS = getPosATL _obj1;
_obj2 = createVehicle ["UK3CB_Cocaine_Pallet_Wrapped", _obj1PS, [], 10, "none"]; 

OP_HQ_squad = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_NAP_O" >> "Infantry" >> "UK3CB_NAP_O_AT_FireTeam")] call BIS_fnc_spawnGroup;
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

_rNumber = random 1 ;
for "_i" from 0 to _rNumber do {
    _hilux = createVehicle ["UK3CB_NAP_O_Hilux_Pkm", _objPS, [], 300];
    _grp = createVehicleCrew _hilux;
    _hiluxPS = getPosATL _hilux;
    _hilux setpos [getPos _hilux select 0, getPos _hilux select 1, (getPos _hilux select 2) +5];
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _objPS, 300 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _hiluxPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 1 ;
for "_i" from 0 to _rNumber do {
    _ION_QRF = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_NAP_O" >> "Infantry" >> "UK3CB_NAP_O_AR_Squad")] call BIS_fnc_spawnGroup;
    _wp = _ION_QRF addWaypoint [ _obj1PS, 150 ] ;
    _wp setWaypointType "move";
    _wpPS = getWPPos [_ION_QRF, 1];
    for "_i" from 1 to 10 do {
        _wp = _ION_QRF addWaypoint [ _wpPS, 100 ] ;
        _wp setWaypointType "move";
    };
    _wp = _ION_QRF addWaypoint [ _wpPS, 0];
    _wp setWaypointType "cycle";
};

_rNumber = random 1 ;
for "_i" from 0 to _rNumber do {
    _centerobj = createVehicle ["Land_WaterBottle_01_cap_F", _obj1PS, [], 500, "none"];  
    _centerobjPS = getPosATL _centerobj;
    _SpecOps = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_NAP_O" >> "Infantry" >> "UK3CB_NAP_O_AR_FireTeam")] call BIS_fnc_spawnGroup;
    _wp = _SpecOps addWaypoint [ _centerobjPS, 200 ] ;
    _wp setWaypointType "move";
    _wpPS = getWPPos [_SpecOps, 1];
    for "_i" from 1 to 10 do {
        _wp = _SpecOps addWaypoint [ _wpPS, 300 ] ;
        _wp setWaypointType "move";
    };
    _wp = _SpecOps addWaypoint [ _centerobjPS, 0];
    _wp setWaypointType "cycle";
    _wp = _SpecOps addWaypoint [ _centerobjPS, 0];
};

_marker7 = createMarker ["Marker7", _obj1ps];
"Marker7" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _obj1PS, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'Marker7';", ""];
};