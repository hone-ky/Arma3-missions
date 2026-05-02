if (isserver) then {
_trigger = getPosATL thistrigger ;

_rnumber = random 3 ;
for "_i" from 1 to _rNumber do {
    _centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 1500, "none"];
    _centerobjPS = getPosASL _centerobj;
    _rifle_squad = [_centerobjPS, independent, (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_RIF_01_Squad")] call BIS_fnc_spawnGroup;
    _wp = _rifle_squad addWaypoint [ _centerobjPS, 0 ] ;
    _wp setWaypointType "Gaurd";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_rnumber = random 5 ;
for "_i" from 1 to _rNumber do {
    _centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 1500, "none"];
    _centerobjPS = getPosASL _centerobj;
    _rifle_squad = [_centerobjPS, independent, (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_RIF_01_FireTeam")] call BIS_fnc_spawnGroup;
    _wp = _rifle_squad addWaypoint [ _centerobjPS, 0 ] ;
    _wp setWaypointType "Gaurd";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_rnumber = random 5 ;
for "_i" from 1 to _rNumber do {
    _centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 1500, "none"];
    _centerobjPS = getPosASL _centerobj;
    _rifle_squad = [_centerobjPS, independent, (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_RIF_Sentry")] call BIS_fnc_spawnGroup;
    _wp = _rifle_squad addWaypoint [ _centerobjPS, 0 ] ;
    _wp setWaypointType "Gaurd";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_rNumber = random 5 ;
for "_i" from 1 to _rNumber do {
    _hilux = createVehicle ["UK3CB_MEI_I_Hilux_Pkm", _trigger, [], 1500];
    _grp = createVehicleCrew _hilux;
    _hiluxPS = getPosATL _hilux;
    _hilux setpos [getPos _hilux select 0, getPos _hilux select 1, (getPos _hilux select 2) +5];
    _wp = _grp addWaypoint [ _hiluxPS, 0];
    _wp setWaypointType "Gaurd";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
};