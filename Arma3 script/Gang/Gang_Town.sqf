_trigger2 = getPosATL thistrigger ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger2, [], 15000, "none"];
_centerobjPS = getPosASL _centerobj;
_rNumber = random 40 ;
_landLocation = if ( _rNumber > 30 ) then {
    locationPosition nearestLocation [_centerobjPS, "NameCityCapital"];
} else {
    locationPosition nearestLocation [_centerobjPS, "NameCity"];
};
_landLocation set [2, 0];
_obj = createVehicle ["UK3CB_Cocaine_Pallet_Wrapped", _landLocation, [], 100, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["UK3CB_BAF_Vehicles_Servicing_Ground_Point", _objPS, [], 10, "none"];
_obj1 setVehicleVarName "evidence";
_MEI_HQ_squad = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_MEI_O" >> "Infantry" >> "UK3CB_MEI_O_RIF_01_FireTeam")] call BIS_fnc_spawnGroup;
_nBuilding = nearestBuilding _objPS;
_nBuildingPS = getPosATL _nBuilding;
_wp = _MEI_HQ_squad addWaypoint [ _nBuildingPS, 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";

_rNumber = random 4 ;
for "_i" from 0 to _rNumber do {
    _MEI_sentry = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_MEI_O" >> "Infantry" >> "UK3CB_MEI_O_RIF_01_Squad")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _MEI_sentry addWaypoint [ _objPS, 100 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "AWARE";
    _wp = _MEI_sentry addWaypoint [ _objPS, 100 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _MEI_sentry addWaypoint [ getWPPos [_MEI_sentry, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 4 ;
for "_i" from 0 to _rNumber - 1 do {
    _hilux = createVehicle ["UK3CB_MEI_O_Hilux_Pkm", _objPS, [], 300];
    _grp = createVehicleCrew _hilux;
    _hiluxPS = getPosATL _hilux;
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _landLocation, 20 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _hiluxPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

'_rNumber = random 3 ;
if (_rNumber > 0) then {
    _mortar = createVehicle ["UK3CB_MEI_O_2b14_82mm", _objPS, [], 50];
    _grp = createVehicleCrew _mortar;
    _mortar setVehicleVarName "mortar0";
    _mortarPS = getPosATL _mortar;
    for "_i" from 0 to _rNumber - 2 do {
        _mortar = createVehicle ["UK3CB_MEI_O_2b14_82mm", _mortarPS, [], 20];
        _grp = createVehicleCrew _mortar;
        _mortar setVehicleVarName format ["mortar%1", _i + 1];
    };
    _trg = createTrigger ["EmptyDetector", _morterPS];
    _trg setTriggerArea [500, 500, 0, false];
    _trg setTriggerActivation ["west", "EAST D", true];
    _trg setTriggerStatements ["this && round (time %1) == 60", "_visibleposition = visiblePosition motar0 findNearestEnemy getPosATL mortar0 ;
mortar0 commandArtilleryFire [ _visibleposition, currentMagazine mortar0, 5];
mortar1 commandArtilleryFire [ _visibleposition, currentMagazine mortar1, 5];
mortar2 commandArtilleryFire [ _visibleposition, currentMagazine mortar2, 5];", ""];
};';

_rNumber = random 15 ;
for "_i" from 0 to _rNumber - 15 do {
    _bmp = createVehicle ["UK3CB_MEE_O_MTLB_BMP", _objPS, [], 300];
    _grp = createVehicleCrew _bmp;
    _bmpPS = getPosATL _bmp;
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _landLocation, 20 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _bmpPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 27 ;
for "_i" from 0 to _rNumber - 30 do {
    _t55 = createVehicle ["UK3CB_MEI_O_T55", _objPS, [], 300];
    _grp = createVehicleCrew _t55;
    _t55PS = getPosATL _t55;
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _landLocation, 300 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _t55PS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 50 ;
for "_i" from 0 to _rNumber - 50 do {
    _SFfireteam = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_CHD_O" >> "SpecOps" >> "UK3CB_CHD_O_Recon_SpecTeam")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _SFfireteam addWaypoint [ _objPS, 100 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "AWARE";
    _fwp = getWPPos [_SFfireteam, 1] ;
    _wp = _SFfireteam addWaypoint [ _objPS, 100 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _SFfireteam addWaypoint [ _fwp, 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 75 ;
for "_i" from 0 to _rNumber - 75 do {
    _SFsniper = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_CHD_O" >> "SpecOps" >> "UK3CB_CHD_O_SF_Sniper_Team")] call BIS_fnc_spawnGroup;
    for "_i" from 1 to 4 do {
        _wp = _SFsniper addWaypoint [ _objPS, 100 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "AWARE";
        _fwp = getWPPos [_SFsniper, 1] ;
        _wp = _SFsniper addWaypoint [ _objPS, 100 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _SFsniper addWaypoint [ _fwp, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 100 ;
for "_i" from 0 to _rNumber - 100 do {
    _SFsquad = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_CHD_O" >> "SpecOps" >> "UK3CB_CHD_O_Recon_SpecSquad")] call BIS_fnc_spawnGroup;
    for "_i" from 1 to 4 do {
        _wp = _SFsniper addWaypoint [ _objPS, 100 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "AWARE";
        _fwp = getWPPos [_SFsniper, 1] ;
        _wp = _SFsniper addWaypoint [ _objPS, 100 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _SFsniper addWaypoint [ _fwp, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_marker1 = createMarker ["Marker1", _landLocation];
"Marker1" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _landlocation, false];
_trg setTriggerArea [500, 500, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'Marker1';", ""];

_rNumber = random 15 ;
for "_i" from 0 to _rNumber do {
    _grp = createGroup civilian;
    _civ = _grp createunit ["C_man_p_beggar_F", _landlocation, [], 300, "none"];
    _civPS = getPosATL _civ;
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _landLocation, 20 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _civPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 15 ;
for "_i" from 0 to _rNumber do {
    _grp = createGroup civilian;
    _civ = _grp createunit ["C_man_1", _landlocation, [], 300, "none"];
    _civPS = getPosATL _civ;
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _landLocation, 20 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _civPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 15 ;
for "_i" from 0 to _rNumber - 1 do {
    _grp = createGroup civilian;
    _civ = _grp createunit ["C_Man_casual_5_v2_F", _landlocation, [], 300, "none"];
    _civPS = getPosATL _civ;
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _landLocation, 20 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _civPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 10 ;
for "_i" from 0 to _rNumber - 5 do {
    _hilux = createVehicle ["UK3CB_C_Hilux_Open", _landlocation, [], 300];
    _grp = createVehicleCrew _hilux;
    _civPS = getPosATL _hilux;
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _landLocation, 20 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _civPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 10 ;
for "_i" from 0 to _rNumber - 5 do {
    _uaz = createVehicle ["UK3CB_C_UAZ_Closed", _landlocation, [], 300];
    _grp = createVehicleCrew _uaz;
    _civPS = getPosATL _uaz;
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _landLocation, 20 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _civPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 5 ;
for "_i" from 0 to _rNumber do {
    _centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger2, [], 15000, "none"];
    _centerobjPS = getPosASL _centerobj;
    _landLocation = locationPosition nearestLocation [_centerobjPS, "NameCity"];
    _landLocation set [2, 0];
    _obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 1000, "none"];  
    _objPS = getPosATL _obj;
    _MEI_sentry_big = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_MEI_O" >> "Infantry" >> "UK3CB_MEI_O_RIF_05_FireTeam")] call BIS_fnc_spawnGroup;
    _wp = _MEI_sentry_big addWaypoint [ _objPS, 1000 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wpPS = getWPPos [_MEI_sentry_big, 1];
    for "_i" from 1 to 4 do {
        _wp = _MEI_sentry_big addWaypoint [ _wpPS, 300 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _MEI_sentry_big addWaypoint [ _objPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 50 ;
for "_i" from 0 to _rNumber - 50 do {
    _centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger2, [], 15000, "none"];
    _centerobjPS = getPosASL _centerobj;
    _landLocation = locationPosition nearestLocation [_centerobjPS, "NameCity"];
    _landLocation set [2, 0];
    _obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 1000, "none"];  
    _objPS = getPosATL _obj;
    _SpecOps = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "UK3CB_CSAT_W_O" >> "SpecOps" >> "UK3CB_CSAT_W_O_Recon_SpecSquad")] call BIS_fnc_spawnGroup;
    {
        _x setSkill ["general", 1];
    } forEachmemberagent _SpecOps;
    _wp = _SpecOps addWaypoint [ _objPS, 1000 ] ;
    _wp setWaypointType "move";
    _wpPS = getWPPos [_SpecOps, 1];
    for "_i" from 1 to 4 do {
        _wp = _SpecOps addWaypoint [ _wpPS, 1000 ] ;
        _wp setWaypointType "move";
    };
    _wp = _SpecOps addWaypoint [ _objPS, 0];
    _wp setWaypointType "cycle";
};