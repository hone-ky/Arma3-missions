_trigger = getPosATL thistrigger ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 9000, "none"];
_centerobjPS = getPosASL _centerobj;
_rNumber = random 40 ;
_landLocation = if ( _rNumber > 30 ) then {
    locationPosition nearestLocation [_centerobjPS, "NameCity"];
} else {
    if ( 15 > _rNumber ) then {
        locationPosition nearestLocation [_centerobjPS, "NameVillage"];
    } else {
        locationPosition nearestLocation [_centerobjPS, "NameLocal"];
    }
};
_landLocation set [2, 0];
_obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 200, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["Land_Communication_F", _objPS, [], 20, "none"];
_obj1PS = getPosATL _obj1;
_obj2 = createVehicle ["Land_PowerGenerator_F", _obj1PS, [], 5, "none"];

OP_HQ_squad = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_LSM_O" >> "Infantry" >> "UK3CB_LSM_O_AA_FireTeam")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = OP_HQ_squad addWaypoint [ _obj1PS, 100 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "AWARE";
    _fwp = getWPPos [OP_HQ_squad, 1] ;
    _wp = OP_HQ_squad addWaypoint [ _obj1PS, 100 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = OP_HQ_squad addWaypoint [ _fwp, 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";

_rNumber = random 5 ;
for "_i" from 0 to _rNumber do { 
    _patrol = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_LSM_O" >> "Infantry" >> "UK3CB_LSM_O_UGL_FireTeam")] call BIS_fnc_spawnGroup;
    _wp = _patrol addWaypoint [ _obj1PS, 300 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "AWARE";
    _fwp = getWPPos [_patrol, 1] ;
     for "_i" from 1 to 6 do {
        _wp = _patrol addWaypoint [ _fwp, 300 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "AWARE";
        _wp setWaypointSpeed "LIMITED";
     };
    _wp = _patrol addWaypoint [ _fwp, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 6 ;
for "_i" from 0 to _rNumber / 2 do { 
    _squad = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_LSM_O" >> "Infantry" >> "UK3CB_LSM_O_AR_Squad")] call BIS_fnc_spawnGroup;
    _wp = _squad addWaypoint [ _obj1PS, 300 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "AWARE";
    _fwp = getWPPos [_squad, 1] ;
    for "_i" from 1 to 6 do {
        _wp = _squad addWaypoint [ _fwp, 300 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "AWARE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _squad addWaypoint [ _fwp, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointSpeed "LIMITED";
};

for "_i" from 0 to _rNumber / 2 do { 
    _squad = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_LSM_O" >> "Infantry" >> "UK3CB_LSM_O_AT_Squad")] call BIS_fnc_spawnGroup;
    _wp = _squad addWaypoint [ _obj1PS, 300 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "AWARE";
    _fwp = getWPPos [_squad, 1] ;
    for "_i" from 1 to 6 do {
        _wp = _squad addWaypoint [ _fwp, 300 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "AWARE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _squad addWaypoint [ _fwp, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointSpeed "LIMITED";
};

_btr = _rNumber / 2 ;
for "_i" from 0 to _btr - 1 do {
    _veh = createVehicle ["UK3CB_LSM_O_BTR60", _obj1PS, [ ], 500, "NONE"];
    _grp = createVehicleCrew _veh;
    _wp = _grp addWaypoint [ _obj1PS, 500 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "AWARE";
    _fwp = getWPPos [_grp, 1] ;
    for "_i" from 1 to 6 do {
        _wp = _grp addWaypoint [ _fwp, 500 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "AWARE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _fwp, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 10 ;
for "_i" from 1 to _rNumber - 8 do {
    _veh = createVehicle ["UK3CB_LSM_O_BMP2K", _obj1PS, [ ], 500, "NONE"];
    _grp = createVehicleCrew _veh;
    _wp = _grp addWaypoint [ _obj1PS, 500 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "AWARE";
    _fwp = getWPPos [_grp, 1] ;
    for "_i" from 1 to 6 do {
        _wp = _grp addWaypoint [ _fwp, 500 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "AWARE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _fwp, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 10 ;
for "_i" from 1 to _rNumber - 8 do { 
  _veh = createVehicle ["UK3CB_LSM_O_ZsuTank", _obj1PS, [ ], 500, "NONE"];
  _grp = createVehicleCrew _veh;
  _fwp = getPosASL _veh ;
     for "_i" from 1 to 6 do {
        _wp = _grp addWaypoint [ _fwp, 500 ] ;
        _wp setWaypointType "move";
     };
  _wp = _grp addWaypoint [ _fwp, 0];
  _wp setWaypointType "cycle";
};

_rNumber = random 50 ;
for "_i" from 1 to _rNumber - 47 do { 
  _veh = createVehicle ["UK3CB_LSM_O_T72BB", _obj1PS, [ ], 500, "NONE"];
  _grp = createVehicleCrew _veh;
  _fwp = getPosASL _veh ;
     for "_i" from 1 to 6 do {
        _wp = _grp addWaypoint [ _fwp, 500 ] ;
        _wp setWaypointType "move";
     };
  _wp = _grp addWaypoint [ _fwp, 0];
  _wp setWaypointType "cycle";
};

_rNumber = random 10 ;
for "_i" from 1 to _rNumber - 9 do { 
    _patrol = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_LSM_O" >> "SpecOps" >> "UK3CB_LSM_O_Recon_SpecSquad")] call BIS_fnc_spawnGroup;
    _wp = _patrol addWaypoint [ _obj1PS, 300 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "AWARE";
    _fwp = getWPPos [_patrol, 1] ;
     for "_i" from 1 to 6 do {
        _wp = _patrol addWaypoint [ _fwp, 300 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "AWARE";
        _wp setWaypointSpeed "LIMITED";
     };
    _wp = _patrol addWaypoint [ _fwp, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointSpeed "LIMITED";
};

_marker = createMarker ["Marker11", _landLocation];
"Marker11" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _obj1PS, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'Marker11';", ""];