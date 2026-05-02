if (isServer) then {
    diag_log "CHDKZ_MISSION: STARTING FINAL REVISION...";
    systemChat "Mission Generating (Ver. Final)...";
    _triggerPos = getPosATL thistrigger;
    _centerobj = createVehicle ["Land_WaterBottle_01_cap_F", _triggerPos, [], 8000, "none"];
    _centerobjPS = getPosASL _centerobj;
    _targetLoc = nearestLocation [_centerobjPS, (selectRandom ["NameCityCapital", "NameCity", "NameVillage"])];
    _targetPos = locationPosition _targetLoc;

    _searchAreaCenter = [_targetPos, 0, 600, 15, 0, 0.4, 0] call BIS_fnc_findSafePos;
    _searchMarker = createMarker ["ChDKZ_9M79B_Area", _searchAreaCenter];
    _searchMarker setMarkerShape "ELLIPSE";
    _searchMarker setMarkerSize [1500, 1500];
    _searchMarker setMarkerBrush "Border";
    _searchMarker setMarkerColor "ColorOPFOR";
    _searchMarker setMarkerAlpha 0.5;

    missionNamespace setVariable ["ChDKZ_MissionUnits", [], true];
    _allBasePositions = [];
    _mUnits = [];

    _basePos = [0,0,0];
    for "_i" from 1 to 100 do {
        _tempPos = [_searchAreaCenter, 0, 1400, 20, 0, 0.25, 0] call BIS_fnc_findSafePos;
        _nearObjs = nearestTerrainObjects [_tempPos, ["TREE", "BUSH", "ROCK", "HOUSE"], 40];
        if (count _nearObjs > 3) exitWith { _basePos = _tempPos; };
        if (_i == 100) then { _basePos = _tempPos; };
    };
    _allBasePositions pushBack _basePos;
    { _x hideObjectGlobal true } forEach (nearestTerrainObjects [_basePos, ["TREE", "BUSH", "ROCK"], 25]);

    _scarab = createVehicle ["rhs_9k79_B", _basePos, [], 0, "none"];
    _scarab setDir (random 360);
    _scarab setPosATL _basePos;
    _scarab setVectorUp (surfaceNormal (getPosASL _scarab));
    createVehicleCrew _scarab;
    _net = createVehicle ["CamoNet_BLUFOR_big_F", _basePos, [], 0, "CAN_COLLIDE"];
    _net setDir (getDir _scarab);
    _net setPosATL [(getPosATL _scarab select 0), (getPosATL _scarab select 1), (getPosATL _scarab select 2) + 0.3];
    _mUnits pushBack _scarab; _mUnits pushBack _net;

    {
        _vPos = [_basePos, 20, 55, 12, 0, 0.3, 0] call BIS_fnc_findSafePos;
        if !(_vPos isEqualTo [0,0,0]) then {
            _v = createVehicle [_x, _vPos, [], 0, "none"];
            _v setDir (random 360);
            _v setVectorUp (surfaceNormal (getPosASL _v));
            createVehicleCrew _v;
            _mUnits pushBack _v; { _mUnits pushBack _x; } forEach (units (group (crew _v select 0)));
        };
    } forEach [(selectRandom ["rhsgref_BRDM2UM_ins", "rhsgref_ins_gaz66_r142"]), "rhsgref_ins_gaz66_ammo", "rhsgref_ins_gaz66_repair"];

    for "_d" from 1 to (3 + floor(random 2)) do {
        _dPos = [0,0,0];
        for "_attempts" from 1 to 50 do {
            _tempPos = [_searchAreaCenter, 0, 1400, 25, 0, 0.3, 0] call BIS_fnc_findSafePos;
            if ({_tempPos distance _x < 600} count _allBasePositions == 0) exitWith { _dPos = _tempPos; };
        };
        if !(_dPos isEqualTo [0,0,0]) then {
            _allBasePositions pushBack _dPos;
            _dScarab = createVehicle ["rhs_9k79_B", _dPos, [], 0, "none"];
            _dScarab setDir (random 360);
            _dScarab setDamage 0.5;
            _dScarab setVectorUp (surfaceNormal (getPosASL _dScarab));
            _dNet = createVehicle ["CamoNet_BLUFOR_big_F", _dPos, [], 0, "CAN_COLLIDE"];
            _dNet setDir (getDir _dScarab);
            _dNet setPosATL [(getPosATL _dScarab select 0), (getPosATL _dScarab select 1), (getPosATL _dScarab select 2) + 0.3];
            _mUnits pushBack _dScarab; _mUnits pushBack _dNet;
            for "_t" from 1 to 2 do {
                _dvPos = [_dPos, 15, 45, 10, 0, 0.3, 0] call BIS_fnc_findSafePos;
                if !(_dvPos isEqualTo [0,0,0]) then {
                    _dv = createVehicle [(selectRandom ["rhsgref_ins_gaz66_ammo", "rhsgref_ins_gaz66_repair", "rhsgref_ins_gaz66_flat"]), _dvPos, [], 0, "none"];
                    _dv setDir (random 360);
                    _dv setVectorUp (surfaceNormal (getPosASL _dv));
                    _mUnits pushBack _dv;
                };
            };
            _dGrp = [_dPos, east, (configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhsgref_group_chdkz_insurgents_infantry" >> "rhsgref_group_chdkz_infantry_patrol")] call BIS_fnc_spawnGroup;
            [_dGrp, _dPos, 50] call BIS_fnc_taskPatrol;
            { _mUnits pushBack _x; } forEach (units _dGrp);
        };
    };

    for "_i" from 1 to 3 do {
        _zPos = [_searchAreaCenter, 0, 1400, 12, 0, 0.4, 0] call BIS_fnc_findSafePos;
        if !(_zPos isEqualTo [0,0,0]) then {
            _zsu = createVehicle ["rhsgref_ins_zsu234", _zPos, [], 0, "none"];
            _zsu setDir (random 360);
            createVehicleCrew _zsu;
            [_zsu, _searchAreaCenter, 1300] spawn { params ["_v", "_p", "_r"]; [(group _v), _p, _r] call BIS_fnc_taskPatrol; };
            _mUnits pushBack _zsu; { _mUnits pushBack _x; } forEach (units (group (crew _zsu select 0)));
        };
    };

    for "_i" from 1 to 4 do {
        _aaPos = [_basePos, 80, 400, 8, 0, 0.4, 0] call BIS_fnc_findSafePos;
        if !(_aaPos isEqualTo [0,0,0]) then {
            _aa = createVehicle [(selectRandom ["rhsgref_ins_Igla_AA_pod", "rhsgref_ins_zu23"]), _aaPos, [], 0, "none"];
            _aa setDir (random 360);
            _aa setVectorUp (surfaceNormal (getPosASL _aa));
            createVehicleCrew _aa;
            _mUnits pushBack _aa; { _mUnits pushBack _x; } forEach (units (group (crew _aa select 0)));
        };
    };

    for "_i" from 1 to 5 do {
        _pPos = [_basePos, 60, 450, 3, 0, 0.5, 0] call BIS_fnc_findSafePos;
        if !(_pPos isEqualTo [0,0,0]) then {
            _pGrp = [_pPos, east, (configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhsgref_group_chdkz_insurgents_infantry" >> "rhsgref_group_chdkz_infantry_patrol")] call BIS_fnc_spawnGroup;
            [_pGrp, _pPos, 200] call BIS_fnc_taskPatrol;
            { _mUnits pushBack _x; } forEach (units _pGrp);
        };
    };

    for "_i" from 1 to 6 do {
        _oPos = [_searchAreaCenter, 0, 1500, 10, 0, 0.4, 0] call BIS_fnc_findSafePos;
        if !(_oPos isEqualTo [0,0,0]) then {
            _uaz = createVehicle ["rhsgref_ins_uaz_dshkm", _oPos, [], 0, "none"];
            _uaz setDir (random 360);
            createVehicleCrew _uaz;
            [_uaz, _searchAreaCenter, 1300] spawn { params ["_v", "_p", "_r"]; [(group _v), _p, _r] call BIS_fnc_taskPatrol; };
            _mUnits pushBack _uaz; { _mUnits pushBack _x; } forEach (units (group (crew _uaz select 0)));
        };
    };

    missionNamespace setVariable ["ChDKZ_MissionUnits", _mUnits, true];
    systemChat "Mission Setup Complete. Monitoring QRF...";

    [_scarab, _basePos] spawn {
        params ["_scarab", "_basePos"];
        _triggered = false;
        while {alive _scarab && !_triggered} do {
            sleep 3;
            _allP = allPlayers select {alive _x && _x distance _scarab < 2000};
            _spotted = {east knowsAbout _x > 1.2} count _allP > 0;
            if (_spotted || !alive _scarab || (damage _scarab > 0.05)) then {
                _triggered = true;
                ['Enemy QRF Dispatched!', 'systemChat'] remoteExec ['bis_fnc_call', 0];
                _playerPos = if (count _allP > 0) then {getPos (_allP select 0)} else {getPos (allPlayers select 0)};
                _dirFromPlayer = _playerPos getDir _basePos;
                _usedQPos = [];
                _qUnits = [];
                for "_i" from 1 to 10 do {
                    _sPos = [0,0,0];
                    for "_a" from 1 to 60 do {
                        _temp = _basePos getPos [1100 + (random 400), _dirFromPlayer + (random 40 - 20)];
                        if (!surfaceIsWater _temp && ({_temp distance _x < 50} count _usedQPos == 0)) exitWith { _sPos = _temp; };
                    };
                    if !(_sPos isEqualTo [0,0,0]) then {
                        _usedQPos pushBack _sPos;
                        _grp = grpNull;
                        if (_i <= 4) then {
                            _grp = [_sPos, east, (configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhs_group_indp_ins_ural" >> "rhs_group_chdkz_ural_squad")] call BIS_fnc_spawnGroup;
                        } else {
                            _v = createVehicle ["rhsgref_ins_uaz_dshkm", _sPos, [], 0, "none"];
                            createVehicleCrew _v;
                            _grp = group (crew _v select 0);
                        };
                        { deleteWaypoint _x } forEach (waypoints _grp);
                        _grp setBehaviour "CARELESS";
                        _grp setSpeedMode "FULL";
                        _wp = _grp addWaypoint [_basePos, 50];
                        _wp setWaypointType "SAD";
                        { (vehicle _x) setVectorUp (surfaceNormal (getPosASL (vehicle _x))); _qUnits pushBack (vehicle _x); _qUnits pushBack _x; } forEach (units _grp);
                    };
                };
                _current = missionNamespace getVariable ["ChDKZ_MissionUnits", []];
                missionNamespace setVariable ["ChDKZ_MissionUnits", _current + _qUnits, true];
            };
        };
    };

    [
        "Abort Scrab Mission",
        {
            [[], {
                deleteMarker "ChDKZ_9M79B_Area";
                { if (!isNull _x) then { deleteVehicle _x }; } forEach (missionNamespace getVariable ["ChDKZ_MissionUnits", []]);
                missionNamespace setVariable ["ChDKZ_MissionUnits", [], true];
                systemChat "Mission Aborted.";
            }] remoteExec ["spawn", 2];
        },
        nil, 1.5, false, true, "", "true", 5000
    ] remoteExec ["addAction", [0, -2] select isDedicated, true];

    [_scarab, "Secure Intel", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa", "_this distance _target < 10", "true", {}, {}, { deleteMarker "ChDKZ_9M79B_Area"; systemChat "Objective Complete."; }, {}, [], 5, 0, false, false] remoteExec ["BIS_fnc_holdActionAdd", 0, _scarab];
    deleteVehicle _centerobj;
};