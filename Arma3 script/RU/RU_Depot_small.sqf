_trigger1 = getPosATL trigger1 ;
_obj = createVehicle ["Land_Cargo_House_V1_F", _trigger1, [], 5000, "none"]; 
_objPS = getPosATL _obj;
_obj1 = createVehicle ["Land_Communication_F", _objPS, [], 20, "none"];
_obj1PS = getPosATL _obj1;
_obj2 = createVehicle ["Land_PowerGenerator_F", _obj1PS, [], 5, "none"];
OP_HQ_squad = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_chq")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = OP_HQ_squad addWaypoint [ _objPS, 20 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = OP_HQ_squad addWaypoint [ _objPS, 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
_rNumber = random 7 ;
for "_i" from 0 to _rNumber do { 
    _patrol = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_fireteam")] call BIS_fnc_spawnGroup;
    _wp = _patrol addWaypoint [ _obj1PS, 500 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "AWARE";
    _fwp = getWPPos [_patrol, 1] ;
     for "_i" from 1 to 4 do {
        _wp = _patrol addWaypoint [ _fwp, 100 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "AWARE";
        _wp setWaypointSpeed "LIMITED";
     };
    _wp = _patrol addWaypoint [ _fwp, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointSpeed "LIMITED";
};
createGuardedPoint [east, _obj1PS, -1, objnull];
_rNumber = random 5 ;
for "_i" from 0 to _rNumber - 1 do { 
  _squad = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad")] call BIS_fnc_spawnGroup;
  _wp = _squad addWaypoint [ _obj1PS, 0];
  _wp setWaypointType "guard";
};
_btr = _rNumber / 2 ;
for "_i" from 0 to _btr - 1 do {
    _veh = createVehicle ["rhs_btr70_msv", _obj1PS, [ ], 50, "NONE"];
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
_rNumber = random 4 ;
for "_i" from 0 to _rNumber - 1 do { 
    _veh = createVehicle ["rhs_2b14_82mm_msv", _obj1PS, [ ], 20, "NONE"];
    _grp = createVehicleCrew _veh;
    private _variableName = format [mortar%1, _i];
    _veh setVehicleVarName _variableName;
};