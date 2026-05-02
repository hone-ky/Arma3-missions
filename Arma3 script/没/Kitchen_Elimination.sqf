_trigger7 = getPosATL thistrigger ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger7, [], 15000, "none"];
_centerobjPS = getPosASL _centerobj;
_landLocation = locationPosition nearestLocation [_centerobjPS, "CityCenter"];
_landLocation set [2, 0];
_obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 2000, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["Land_Radar_01_kitchen_F", _objPS, [], 2000, "none"]; 
_obj1PS = getPosATL _obj1;

_rNumber = random 1 ;
for "_i" from 0 to _rNumber do {
    _ION_QRF = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_CHD_O" >> "Infantry" >> "UK3CB_CHD_O_AT_Squad")] call BIS_fnc_spawnGroup;
    _wp = _ION_QRF addWaypoint [ _obj1PS, 0];
};

_rNumber = random 1 ;
for "_i" from 0 to _rNumber do {
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
    _wp = _SpecOps addWaypoint [ _centerobjPS, 0];
};

_marker = createMarker ["Marker10", _obj1ps];
"Marker10" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _obj1PS, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'Marker10';", ""];