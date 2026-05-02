_trigger8 = getPosATL trigger8 ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger8, [], 15000, "none"];
_centerobjPS = getPosASL _centerobj;
_landLocation = locationPosition nearestLocation [_centerobjPS, "NameCity"];
_landLocation set [2, 0];
_obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 3000, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["Land_Cargo_HQ_V1_F", _objPS, [], 1000, "none"]; 
_obj1PS = getPosATL _obj1;
_obj2 = createVehicle ["Land_Communication_F", _obj1PS, [], 20, "none"];
_obj2PS = getPosATL _obj2;
_obj3 = createVehicle ["Land_PowerGenerator_F", _obj2PS, [], 5, "none"];
_trg = createTrigger ["EmptyDetector", _obj1PS, false];
_trg setTriggerArea [250, 250, -1, false];
_trg setTriggerType "EAST G";

OP_HQ_squad = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_chq")] call BIS_fnc_spawnGroup;
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

_rNumber = random 5 ;
for "_i" from 1 to _rNumber do { 
  _squad = [_obj2PS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad")] call BIS_fnc_spawnGroup;
  _wp = _squad addWaypoint [ _obj1PS, 0];
  _wp setWaypointType "guard";
};

_btr = _rNumber / 2 ;
for "_i" from 0 to _btr - 1 do {
    _veh = createVehicle ["rhs_btr70_msv", _obj1PS, [ ], 300, "NONE"];
    _grp = createVehicleCrew _veh;
    _wp = _grp addWaypoint [ _obj1PS, 10 ];
    _wp setWaypointType "guard" ;
};

_rNumber = random 4 ;
for "_i" from 0 to _rNumber - 1 do { 
  _veh = createVehicle ["rhs_zsu234_aa", _obj1PS, [ ], 500, "NONE"];
  _grp = createVehicleCrew _veh;
  _fwp = getPosASL _veh ;
     for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _fwp, 100 ] ;
        _wp setWaypointType "move";
     };
  _wp = _grp addWaypoint [ _fwp, 0];
  _wp setWaypointType "cycle";
};

_allLocationTypes = [];
{
    _trg1 = createTrigger ["EmptyDetector", getPos _x, false];
    _trg1 setTriggerArea [1000, 1000, -1, false];
    _trg1 setTriggerType "EAST G";
    _trg2 = createTrigger ["EmptyDetector", getPos _x, false];
    _trg2 setTriggerArea [1000, 1000, -1, false];
    _trg2 setTriggerActivation ["EAST SEIZED", "PRESENT", true];
    _trg2 setTriggerStatements ["this", "_obj = createVehicle ['Land_WaterBottle_01_cap_F', thisTrigger, [], 3000, 'none'];  
_objPS = getPosATL _obj;
_rNumber = random 5 ;
for '_i' from 1 to _rNumber do { 
  _squad = [_objPS, east, (configfile >> 'CfgGroups' >> 'East' >> 'rhs_faction_msv' >> 'rhs_group_rus_msv_infantry_emr' >> 'rhs_group_rus_msv_infantry_emr_squad')] call BIS_fnc_spawnGroup;
  _wp = _squad addWaypoint [ _objPS, 0];
  _wp setWaypointType 'guard';
};
_btr = _rNumber / 2 ;
for '_i' from 0 to _btr - 1 do {
    _veh = createVehicle ['rhs_btr70_msv', _objPS, [ ], 300, 'NONE'];
    _grp = createVehicleCrew _veh;
    _wp = _grp addWaypoint [ _objPS, 10 ];
    _wp setWaypointType 'guard' ;
};
", ""];
} forEach nearestLocations [_trigger8, _allLocationTypes, 2000];

    _trg = createTrigger ["EmptyDetector", _x, false];
    _trg setTriggerArea [1000, 1000, -1, false];
    _trg setTriggerActivation ["EAST SEIZED", "PRESENT", false];
    _trg setTriggerStatements ["this", "private _allLocationTypes = [];
{
    createGuardedPoint [east, _x, -1, objnull];
    _trg = createTrigger ['EmptyDetector', _x, false];
    _trg setTriggerArea [1000, 1000, -1, false];
    _trg setTriggerActivation ['EAST SEIZED', 'PRESENT', false];
    _trg setTriggerStatements ['this', '', ''];
} forEach nearestLocations [_trigger8, _allLocationTypes, 2000];", ""];

_obj = createVehicle ["Land_WaterBottle_01_cap_F", thistrigger, [], 3000, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["Land_Cargo_HQ_V1_F", _objPS, [], 1000, "none"]; 
_obj1PS = getPosATL _obj1;
_obj2 = createVehicle ["Land_Communication_F", _obj1PS, [], 20, "none"];
_obj2PS = getPosATL _obj2;
_obj3 = createVehicle ["Land_PowerGenerator_F", _obj2PS, [], 5, "none"];

_obj = createVehicle ["Land_WaterBottle_01_cap_F", thistrigger, [], 200, "none"];  
_objPS = getPosATL _obj;

_rNumber = random 5 ;
for "_i" from 1 to _rNumber do { 
  _squad = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad")] call BIS_fnc_spawnGroup;
  _wp = _squad addWaypoint [ _objPS, 0];
  _wp setWaypointType "guard";
};

_btr = _rNumber / 2 ;
for "_i" from 0 to _btr - 1 do {
    _veh = createVehicle ["rhs_btr70_msv", _objPS, [ ], 100, "NONE"];
    _grp = createVehicleCrew _veh;
    _wp = _grp addWaypoint [ _objPS, 10 ];
    _wp setWaypointType "guard" ;
};

_obj1 = createVehicle ["Land_Cargo_HQ_V1_F", getpos thistrigger, [], 100, "none"]; 
_obj1PS = getPosATL _obj1;
_obj2 = createVehicle ["Land_Communication_F", _obj1PS, [], 20, "none"];
_obj2PS = getPosATL _obj2;
_obj3 = createVehicle ["Land_PowerGenerator_F", _obj2PS, [], 5, "none"];
_trg = createTrigger ["EmptyDetector", _obj1PS, false];
_trg setTriggerArea [250, 250, -1, false];
_trg setTriggerType "EAST G";

OP_HQ_squad = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_chq")] call BIS_fnc_spawnGroup;
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

_rNumber = random 5 ;
for "_i" from 1 to _rNumber do { 
  _squad = [_obj2PS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad")] call BIS_fnc_spawnGroup;
  _wp = _squad addWaypoint [ _obj1PS, 0];
  _wp setWaypointType "guard";
};

_btr = _rNumber / 2 ;
for "_i" from 0 to _btr do {
    _veh = createVehicle ["rhs_btr70_msv", _obj1PS, [ ], 100, "NONE"];
    _grp = createVehicleCrew _veh;
    _wp = _grp addWaypoint [ _obj1PS, 10 ];
    _wp setWaypointType "guard" ;
};

_rNumber = random 4 ;
for "_i" from 0 to _rNumber - 1 do { 
  _veh = createVehicle ["rhs_zsu234_aa", _obj1PS, [ ], 100, "NONE"];
  _grp = createVehicleCrew _veh;
  _fwp = getPosASL _veh ;
     for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _fwp, 100 ] ;
        _wp setWaypointType "move";
     };
  _wp = _grp addWaypoint [ _fwp, 0];
  _wp setWaypointType "cycle";
};