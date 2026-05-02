if (isserver) then {
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
_obj = createVehicle ["CUP_BOX_ChDKZ_AmmoVeh_F", _landLocation, [], 100, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["CamoNet_BLUFOR_open_F", _objPS, [], 0, "none"];  
_obj1PS = getPosATL _obj1;

_MEI_HQ = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_CHD_O" >> "Infantry" >> "UK3CB_CHD_O_MG_FireTeam")] call BIS_fnc_spawnGroup;
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

_rNumber = random 5 ;
for "_i" from 0 to _rNumber do {
    _hilux = createVehicle ["UK3CB_CHD_O_BMD1", _obj1PS, [], 300];
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

_rNumber = random 8 ;
for "_i" from 0 to _rNumber do {
    _MEI_sentry = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_CHD_O" >> "Infantry" >> "UK3CB_CHD_O_UGL_Fireteam")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _MEI_sentry addWaypoint [ _objPS, 400 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _MEI_sentry addWaypoint [ getWPPos [_MEI_sentry, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 5 ;
for "_i" from 0 to _rNumber do {
    _MEI_QRF = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_CHD_O" >> "Infantry" >> "UK3CB_CHD_O_AR_Squad")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _MEI_QRF addWaypoint [ _objPS, 200 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _MEI_QRF addWaypoint [ getWPPos [_MEI_QRF, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_marker15 = createMarker ["Marker15", _objPS];
"Marker15" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _objPS, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'Marker15';", ""];
};