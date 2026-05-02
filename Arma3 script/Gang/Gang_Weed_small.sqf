_trigger7 = getPosATL thistrigger ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger7, [], 15000, "none"];
_centerobjPS = getPosASL _centerobj;
_landLocation = locationPosition nearestLocation [_centerobjPS, "NameCity"];
_landLocation set [2, 0];
_obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 2000, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["CUP_VABox_ChDKZ", _objPS, [], 2000, "none"]; 
_obj1PS = getPosATL _obj1;
_obj2 = createVehicle ["UK3CB_Cocaine_Pallet_Wrapped", _obj1PS, [], 10, "none"]; 

_rNumber = random 5 ;
for "_i" from 1 to _rNumber - 3 do {
    _hilux = createVehicle ["UK3CB_CHD_O_Datsun_Pkm", _objPS, [], 100];
    _grp = createVehicleCrew _hilux;
    _hiluxPS = getPosATL _hilux;
    _hilux setpos [getPos _hilux select 0, getPos _hilux select 1, (getPos _hilux select 2) +5];
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _objPS, 150 ] ;
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
    _ION_QRF = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_CHD_O" >> "Infantry" >> "UK3CB_CHD_O_AT_Squad")] call BIS_fnc_spawnGroup;
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

_rNumber = random 2 ;
for "_i" from 1 to _rNumber do {
    _centerobj = createVehicle ["Land_WaterBottle_01_cap_F", _obj1PS, [], 100, "none"];  
    _centerobjPS = getPosATL _centerobj;
    _SpecOps = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_CHD_O" >> "Infantry" >> "UK3CB_CHD_O_UGL_FireTeam")] call BIS_fnc_spawnGroup;
    _wp = _SpecOps addWaypoint [ _centerobjPS, 150 ] ;
    _wp setWaypointType "move";
    _wpPS = getWPPos [_SpecOps, 1];
    for "_i" from 1 to 10 do {
        _wp = _SpecOps addWaypoint [ _wpPS, 100 ] ;
        _wp setWaypointType "move";
    };
    _wp = _SpecOps addWaypoint [ _centerobjPS, 0];
    _wp setWaypointType "cycle";
};

_marker = createMarker ["Marker9", _obj1ps];
"Marker9" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _obj1PS, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'Marker9';", ""];