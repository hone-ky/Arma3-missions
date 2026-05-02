_trigger = getPosATL jupiter_center ;

_RU_HQ = [_trigger, east, (configfile >> "CfgGroups" >> "East" >> "min_rf" >> "Infantry" >> "min_rf_InfTeam")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _RU_HQ addWaypoint [ _trigger, 20 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _RU_HQ addWaypoint [ getWPPos [_RU_HQ, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";

_rNumber = random 1 ;
for "_i" from 1 to _rNumber do {
    _RU_QRF = [_trigger, east, (configfile >> "CfgGroups" >> "East" >> "min_rf" >> "Infantry" >> "min_rf_InfSquad")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _RU_QRF addWaypoint [ _trigger, 100 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _RU_QRF addWaypoint [ getWPPos [_RU_QRF, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 5 ;
for "_i" from 0 to _rNumber do {
    _RU_sentry = [_trigger, east, (configfile >> "CfgGroups" >> "East" >> "min_rf" >> "Infantry" >> "min_rf_InfSentry")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _RU_sentry addWaypoint [ _trigger, 250 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _RU_sentry addWaypoint [ getWPPos [_RU_sentry, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};