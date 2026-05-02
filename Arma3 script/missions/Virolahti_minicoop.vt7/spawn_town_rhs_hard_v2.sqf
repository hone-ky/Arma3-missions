if (!isServer) exitWith {};

params [["_args", []]];
_args params [["_target", objNull], ["_caller", objNull]];

// --- 1. ロケーションの選定 ---
private _originPos = if (!isNull _caller) then { getPosATL _caller } else { [worldSize/2, worldSize/2, 0] };
private _locTypes = ["NameCityCapital", "NameCity", "NameVillage"];
private _allLocs = nearestLocations [_originPos, _locTypes, worldSize];
private _validLocs = _allLocs select { (_originPos distance (locationPosition _x)) > 1000 };

private _missionCenter = [0,0,0];
private _locName = "作戦区域";

if (count _validLocs > 0) then {
    private _targetLoc = selectRandom _validLocs;
    _missionCenter = locationPosition _targetLoc;
    _locName = text _targetLoc;
} else {
    _missionCenter = _originPos getPos [2000, random 360];
};

// --- 2. 補助関数の定義 (安全生成 & 歩哨命令) ---
private _fnc_safeSpawnVehicle = {
    params ["_type", "_pos", "_radius"];
    private _safePos = [_pos, 0, _radius, 8, 0, 0.4, 0] call BIS_fnc_findSafePos;
    if (count _safePos < 2) then { _safePos = _pos getPos [random _radius, random 360]; };
    
    private _veh = createVehicle [_type, _safePos, [], 0, "NONE"];
    _veh setPosATL [(_safePos select 0), (_safePos select 1), 0.5];
    _veh setVectorUp (surfaceNormal _safePos);
    _veh
};

private _fnc_spawnAndPatrolSquad = {
    params ["_pos", "_patrolRadius"];
    private _safePos = [_pos, 0, 20, 2, 0, 0.5, 0] call BIS_fnc_findSafePos;
    if (count _safePos < 2) then { _safePos = _pos; };
    
    private _grp = [_safePos, east, (configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhsgref_group_chdkz_insurgents_infantry" >> "rhsgref_group_chdkz_insurgents_squad")] call BIS_fnc_spawnGroup;
    
    if (!isNull _grp) then {
        // 歩哨命令 (車両の周囲をパトロール)
        [_grp, _pos, _patrolRadius] call BIS_fnc_taskPatrol;
        units _grp
    } else { [] };
};

// --- 3. 拠点とHQの配置 ---
private _allDefenders = [];

// 弾薬箱 (目標)
private _obj = createVehicle ["O_supplyCrate_F", _missionCenter, [], 20, "NONE"];
_obj setPosATL [(getPosATL _obj select 0), (getPosATL _obj select 1), 0.1];
private _objPS = getPosATL _obj;
_obj setVectorUp (surfaceNormal _objPS);
private _net = createVehicle ["CamoNet_BLUFOR_open_F", _objPS, [], 0, "NONE"];

// HQ分隊 (弾薬箱の直近)
private _hqGroup = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhsgref_group_chdkz_insurgents_infantry" >> "rhsgref_group_chdkz_infantry_patrol")] call BIS_fnc_spawnGroup;
if (!isNull _hqGroup) then { 
    _allDefenders append (units _hqGroup);
    { _x setUnitPos "MIDDLE"; } forEach (units _hqGroup);
};

// BMP-2K (HQ用)
private _bmp2k = ["rhsgref_ins_bmp2k", _objPS, 60] call _fnc_safeSpawnVehicle;
private _bmp2kCrew = createVehicleCrew _bmp2k;
_allDefenders append (units _bmp2kCrew);
(group _bmp2k) setBehaviour "SAFE";

// --- 4. 初期防衛戦力 (車両 + 随伴歩哨) ---

// 内側 (BMP-2D: 0~2, BTR-70: 2~5)
private _innerTypes = [];
for "_i" from 1 to (floor(random 3)) do { _innerTypes pushBack "rhsgref_ins_bmp2d" };
for "_i" from 1 to (2 + floor(random 4)) do { _innerTypes pushBack "rhsgref_ins_btr70" };

{
    private _v = [_x, _objPS, 120] call _fnc_safeSpawnVehicle;
    private _g = createVehicleCrew _v;
    [_g, _objPS, 150] call BIS_fnc_taskPatrol;
    _allDefenders append (units _g);
    // 車両の周囲100mをパトロールする歩兵
    _allDefenders append ([getPosATL _v, 100] call _fnc_spawnAndPatrolSquad);
} forEach _innerTypes;

// 外縁 (UAZ: 3~5, BRDM-2: 0~3)
private _outerTypes = [];
for "_i" from 1 to (3 + floor(random 3)) do { _outerTypes pushBack "rhsgref_ins_uaz_dshkm" };
for "_i" from 1 to (floor(random 4)) do { _outerTypes pushBack "rhsgref_BRDM2_ins" };

{
    private _v = [_x, _objPS, 400] call _fnc_safeSpawnVehicle;
    private _g = createVehicleCrew _v;
    [_g, _objPS, 500] call BIS_fnc_taskPatrol;
    _allDefenders append (units _g);
    // 車両の周囲200mをパトロールする歩兵
    _allDefenders append ([getPosATL _v, 200] call _fnc_spawnAndPatrolSquad);
} forEach _outerTypes;

// マーカー設置
private _mkr = createMarker ["mkr_town_hard", _objPS];
_mkr setMarkerType "hd_objective";
_mkr setMarkerColor "ColorOPFOR";
_mkr setMarkerText format ["目標: %1 弾薬庫爆破", _locName];

["拠点を捕捉。弾薬箱を爆破せよ。"] remoteExec ["hint", 0];

// --- 5. 増援ロジック ---
[_objPS, _allDefenders] spawn {
    params ["_targetPos", "_defenders"];
    private _initialCount = count _defenders;
    waitUntil {
        sleep 5;
        ({ alive _x } count _defenders) < (_initialCount * 0.5)
    };
    
    ["敵の増援を確認！近隣より装甲部隊が接近中！"] remoteExec ["hint", 0];
    private _nearbyTowns = nearestLocations [_targetPos, ["NameCity", "NameVillage"], 5000];
    private _spawnLoc = if (count _nearbyTowns > 1) then { locationPosition (_nearbyTowns select 1) } else { _targetPos getPos [1500, random 360] };

    for "_i" from 1 to (floor(random [3, 5, 8])) do {
        private _safePos = [_spawnLoc, 0, 100, 7, 0, 0.5, 0] call BIS_fnc_findSafePos;
        if (count _safePos < 2) then { _safePos = _spawnLoc; };
        
        private _btr = createVehicle ["rhsgref_ins_btr70", _safePos, [], 0, "NONE"];
        _btr setPosATL [(_safePos select 0), (_safePos select 1), 0.5];
        _btr setVectorUp (surfaceNormal _safePos);
        private _btrGrp = createVehicleCrew _btr;
        
        private _infGrp = [_safePos, east, (configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhsgref_group_chdkz_insurgents_infantry" >> "rhsgref_group_chdkz_insurgents_squad")] call BIS_fnc_spawnGroup;
        
        {
            private _wp = _x addWaypoint [_targetPos, 50];
            _wp setWaypointType "SAD";
        } forEach [_btrGrp, _infGrp];
        sleep 1;
    };

    if (random 100 < 15) then {
        private _safePos = [_spawnLoc, 0, 100, 10, 0, 0.4, 0] call BIS_fnc_findSafePos;
        if (count _safePos < 2) then { _safePos = _spawnLoc; };
        private _t72Grp = [_safePos, east, (configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhs_group_indp_ins_72" >> "RHS_T72baPlatoon")] call BIS_fnc_spawnGroup;
        if (!isNull _t72Grp) then { (_t72Grp addWaypoint [_targetPos, 0]) setWaypointType "SAD"; };
    };
};

// --- 6. 完了判定 ---
waitUntil { sleep 2; !alive _obj };
["目標破壊を確認。残存勢力を掃討せよ。"] remoteExec ["hint", 0];

waitUntil {
    sleep 5;
    ({ alive _x } count _allDefenders) < 3
};

deleteMarker _mkr;
["ミッション完了。エリアを制圧した。"] remoteExec ["hint", 0];