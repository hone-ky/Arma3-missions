_centerobjPS = getPosASL centerobj;
_wreck = createVehicle ["RHS_UH60M", _centerobjPS, [], 10000, "none"];
_wreckPS = getPosATL _wreck;
_wreck setdamage 1;
_pilot = createVehicle ["Land_WaterBottle_01_cap_F",_wreckPS, [], 100, "none"];
_pilotPS = getPosASL _pilot;
for "_i" from 1 to 2 do {
    _grp = createGroup west;
    _unit = _grp createUnit ["rhsusf_army_ucp_helipilot", _pilotPS, [], 5, "NONE"];
    _rNumber = random 1 ;
    _hp = _unit setDamage _rnumber;
    hint _hp;
    [_unit, true] call ACE_captives_fnc_setSurrendered;
};

_rNumber = random 2 ;
for "_i" from 1 to _rNumber do {
    _RU_start = createVehicle ["Land_WaterBottle_01_cap_F",_wreckPS, [], 50, "none"];
    _RU_startPS = getPosASL _RU_start;
    _RU_HQ = [_RU_startPS, east, (configfile >> "CfgGroups" >> "East" >> "min_rf" >> "Infantry" >> "min_rf_InfSquad")] call BIS_fnc_spawnGroup;
    for "_i" from 1 to 4 do {
        _wp = _RU_HQ addWaypoint [ _wreckPS, 200 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _RU_HQ addWaypoint [ getWPPos [_RU_HQ, 0], 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_marker = createMarker ["_USER_DEFINED destination", _wreckPS];
"_USER_DEFINED destination" setMarkerType "hd_unknown";
