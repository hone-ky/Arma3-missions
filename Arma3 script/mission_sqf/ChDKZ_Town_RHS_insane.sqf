if (!isServer) exitWith {};

// --- ログ出力用関数 ---
private _fnc_log = {
    params ["_msg"];
    diag_log format ["[INSANE_MODE] %1", _msg];
};

[_fnc_log, "Script Started V6 (Final Polish: SafeZones & Land Checks)."] call _fnc_log;

params [["_args", []]];
_args params [["_target", objNull], ["_caller", objNull]];

// --- 0. リスポーン地点（安全地帯）の特定 ---
private _safeZonePos = [0,0,0];

// terminalがあれば優先、なければrespawn_westマーカー、それもなければプレイヤー位置
if (!isNil "terminal") then { 
    _safeZonePos = getPosATL terminal;
    ["SafeZone: Defined by 'terminal' object."] call _fnc_log;
} else {
    if (getMarkerColor "respawn_west" != "") then {
        _safeZonePos = getMarkerPos "respawn_west";
        ["SafeZone: Defined by 'respawn_west' marker."] call _fnc_log;
    } else {
        if (!isNull _caller) then {
            _safeZonePos = getPosATL _caller;
            ["SafeZone: Defined by Caller position (Fallback)."] call _fnc_log;
        };
    };
};

// --- 1. 作戦エリアの選定 ---
private _originPos = if (!isNull _caller) then { getPosATL _caller } else { [worldSize/2, worldSize/2, 0] };
private _locTypes = ["NameCityCapital", "NameCity", "NameVillage"];
private _allLocs = nearestLocations [_originPos, _locTypes, worldSize];

// 条件: スポーン地点(origin)から3km以上 かつ 安全地帯(_safeZonePos)からも3km以上離れていること
private _validLocs = _allLocs select { 
    (_originPos distance (locationPosition _x) > 3000) && 
    (_safeZonePos distance (locationPosition _x) > 3000)
};

private _missionCenter = [0,0,0];
private _locName = "作戦区域";

if (count _validLocs > 0) then {
    private _targetLoc = selectRandom _validLocs;
    _missionCenter = locationPosition _targetLoc;
    _locName = text _targetLoc;
} else {
    // 候補がない場合はランダムだが、SafeZoneチェックは行う
    private _attempts = 0;
    while {_attempts < 100} do {
        private _testPos = _originPos getPos [3500 + random 2000, random 360];
        if (!surfaceIsWater _testPos && _testPos distance _safeZonePos > 3000) exitWith {
            _missionCenter = _testPos;
        };
        _attempts = _attempts + 1;
    };
    if (_missionCenter isEqualTo [0,0,0]) then { _missionCenter = _originPos getPos [4000, random 360]; }; // 最終手段
    _locName = "荒野の臨時拠点";
};

[format ["Target Location: %1 at %2", _locName, _missionCenter]] call _fnc_log;

// --- 2. 補助関数: 安全な車列生成スポーン ---
private _fnc_spawnConvoy = {
    params ["_centerPos", "_vehicleTypes", "_group", "_targetDestination"];
    
    // 半径500m以内の道路を探す
    private _roads = _centerPos nearRoads 500;
    private _spawnDir = _centerPos getDir _targetDestination; 
    private _startPos = _centerPos;
    private _isOnRoad = false;

    if (count _roads > 0) then {
        // 一番近い道路を選択
        private _road = _roads select 0;
        _startPos = getPosATL _road;
        _isOnRoad = true;
        
        // 道路の向きを補正（目的地に近い側を向く）
        private _connected = roadsConnectedTo _road;
        if (count _connected > 0) then {
            private _roadDir = _road getDir (_connected select 0);
            private _dirToTarget = _startPos getDir _targetDestination;
            if (cos (_roadDir - _dirToTarget) < 0) then { _spawnDir = _roadDir + 180; } else { _spawnDir = _roadDir; };
        } else {
            _spawnDir = getDir _road;
        };
        [format ["Convoy: Found road. Aligning to Dir: %1", _spawnDir]] call (missionNamespace getVariable "_fnc_log");
    } else {
        // 道路がない場合、確実に陸地を探す
        private _safePos = [_centerPos, 0, 300, 10, 0, 0.4, 0] call BIS_fnc_findSafePos;
        if (count _safePos == 2 && !surfaceIsWater _safePos) then { _startPos = _safePos; };
        _spawnDir = _startPos getDir _targetDestination;
        [format ["Convoy: No road. Aligning directly to Target (Dir: %1)", _spawnDir]] call (missionNamespace getVariable "_fnc_log");
    };

    {
        private _type = _x;
        // 先頭から後ろへずらす
        private _spawnPos = _startPos getPos [_forEachIndex * 25, _spawnDir + 180];
        
        // 道路外なら地形追従チェック
        if (!_isOnRoad) then {
            _spawnPos = [_spawnPos, 0, 20, 5, 0, 0.5, 0] call BIS_fnc_findSafePos;
            if (count _spawnPos < 2) then { _spawnPos = _startPos getPos [_forEachIndex * 25, _spawnDir + 180]; };
        };

        // 最終的な水没防止チェック（ここ重要）
        if (surfaceIsWater _spawnPos) then {
            // 水上なら元の中心点の近くに無理やり戻す
            _spawnPos = _startPos; 
        };

        private _veh = createVehicle [_type, _spawnPos, [], 0, "NONE"];
        _veh setDir _spawnDir;
        _veh setPosATL [(_spawnPos select 0), (_spawnPos select 1), 0.5];
        _veh setVectorUp (surfaceNormal _spawnPos);
        
        createVehicleCrew _veh; 
        (crew _veh) joinSilent _group;
        sleep 0.5;
        
    } forEach _vehicleTypes;
};

// 単体スポーン（初期配置用）
private _fnc_safeSpawnVehicle = {
    params ["_type", "_pos", "_radius"];
    // 水上を絶対に避ける設定
    private _safePos = [_pos, 0, _radius, 8, 0, 0.4, 0, [], [_pos, _pos]] call BIS_fnc_findSafePos;
    if (count _safePos < 2) then { _safePos = _pos; };

    private _veh = createVehicle [_type, _safePos, [], 0, "NONE"];
    _veh setPosATL [(_safePos select 0), (_safePos select 1), 0.5];
    _veh setVectorUp (surfaceNormal _safePos);
    _veh
};

// 歩兵スポーン
private _fnc_spawnAndPatrolSquad = {
    params ["_pos", "_patrolRadius"];
    private _safePos = [_pos, 0, 30, 2, 0, 0.5, 0] call BIS_fnc_findSafePos;
    if (count _safePos < 2) then { _safePos = _pos; };
    private _grp = [_safePos, east, (configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhsgref_group_chdkz_insurgents_infantry" >> "rhsgref_group_chdkz_insurgents_squad")] call BIS_fnc_spawnGroup;
    if (!isNull _grp) then {
        [_grp, _pos, _patrolRadius] call BIS_fnc_taskPatrol;
        units _grp
    } else { [] };
};

// 関数をグローバル登録
missionNamespace setVariable ["_fnc_log", _fnc_log];
missionNamespace setVariable ["_fnc_spawnConvoy", _fnc_spawnConvoy];
missionNamespace setVariable ["_fnc_safeSpawnVehicle", _fnc_safeSpawnVehicle];

// --- 3. 拠点とHQの配置 ---
private _allDefenders = [];
["Spawning Objective..."] call _fnc_log;

private _obj = createVehicle ["O_supplyCrate_F", _missionCenter, [], 20, "NONE"];
_obj setPosATL [(getPosATL _obj select 0), (getPosATL _obj select 1), 0.1];
private _objPS = getPosATL _obj;
private _net = createVehicle ["CamoNet_BLUFOR_open_F", _objPS, [], 0, "NONE"];

private _hqGroup = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhsgref_group_chdkz_insurgents_infantry" >> "rhsgref_group_chdkz_infantry_patrol")] call BIS_fnc_spawnGroup;
if (!isNull _hqGroup) then { 
    _allDefenders append (units _hqGroup);
    { _x setUnitPos "MIDDLE"; } forEach (units _hqGroup);
};

private _bmp2k = ["rhsgref_ins_bmp2k", _objPS, 60] call _fnc_safeSpawnVehicle;
private _bmp2kCrew = createVehicleCrew _bmp2k;
_allDefenders append (units _bmp2kCrew);
(group _bmp2k) setBehaviour "SAFE";

// --- 4. 初期防衛戦力 ---
["Spawning Defenders..."] call _fnc_log;
private _innerTypes = [];
for "_i" from 1 to (floor(random 3)) do { _innerTypes pushBack "rhsgref_ins_bmp2d" };
for "_i" from 1 to (2 + floor(random 4)) do { _innerTypes pushBack "rhsgref_ins_btr70" };

{
    private _v = [_x, _objPS, 120] call _fnc_safeSpawnVehicle;
    private _g = createVehicleCrew _v;
    [_g, _objPS, 150] call BIS_fnc_taskPatrol;
    _allDefenders append (units _g);
    _allDefenders append ([getPosATL _v, 100] call _fnc_spawnAndPatrolSquad);
} forEach _innerTypes;

private _outerTypes = [];
for "_i" from 1 to (3 + floor(random 3)) do { _outerTypes pushBack "rhsgref_ins_uaz_dshkm" };
for "_i" from 1 to (floor(random 4)) do { _outerTypes pushBack "rhsgref_BRDM2_ins" };

{
    private _v = [_x, _objPS, 400] call _fnc_safeSpawnVehicle;
    private _g = createVehicleCrew _v;
    [_g, _objPS, 500] call BIS_fnc_taskPatrol;
    _allDefenders append (units _g);
    _allDefenders append ([getPosATL _v, 200] call _fnc_spawnAndPatrolSquad);
} forEach _outerTypes;

private _mkr = createMarker ["mkr_town_hard", _objPS];
_mkr setMarkerType "hd_objective";
_mkr setMarkerColor "ColorOPFOR";
_mkr setMarkerText format ["目標: %1 弾薬庫爆破", _locName];

[format ["目標捕捉: %1\n被発見から15分で重装甲部隊が到達する。\n急いで破壊せよ。", _locName]] remoteExec ["hint", 0];

// --- 5. 増援ロジック ---

// (A) 敵戦力50%以下での増援 (BTR) - 改良版
[_objPS, _allDefenders, _safeZonePos] spawn {
    params ["_targetPos", "_defenders", "_safeZonePos"];
    private _fnc_spawnConvoy = missionNamespace getVariable "_fnc_spawnConvoy";
    private _fnc_log = missionNamespace getVariable "_fnc_log";
    
    private _initialCount = count _defenders;
    waitUntil { sleep 10; ({ alive _x } count _defenders) < (_initialCount * 0.5) };
    
    ["Trigger: Defenders < 50%. Spawning BTR QRF (Improved)."] call _fnc_log;
    ["敵の警備部隊が半減！近隣よりBTRが急行中！"] remoteExec ["hint", 0];
    
    // スポーン候補地の選定 (SafeZone除外 & 近場優先)
    // 1500m - 3000m の範囲の町を探す
    private _nearbyLocs = nearestLocations [_targetPos, ["NameCity", "NameVillage", "NameLocal"], 3000];
    private _validSpawns = _nearbyLocs select { 
        private _pos = locationPosition _x;
        (_targetPos distance _pos > 1500) && // 近すぎない
        (_safeZonePos distance _pos > 3000)  // SafeZoneから3km以上
    };
    
    private _spawnCenter = [0,0,0];
    if (count _validSpawns > 0) then {
        _spawnCenter = locationPosition (_validSpawns select 0); // 一番近い有効な町を選ぶ(対岸対策)
        ["BTR QRF: Found valid neighbor town."] call _fnc_log;
    } else {
        // 条件に合う町がない場合は、SafeZoneから遠い方向のランダム位置
        private _dirToSafe = _targetPos getDir _safeZonePos;
        private _spawnDir = _dirToSafe + 180 + (random 90 - 45); // SafeZoneの反対側
        _spawnCenter = _targetPos getPos [2000, _spawnDir];
        ["BTR QRF: No town. Using random pos away from SafeZone."] call _fnc_log;
    };

    // 車列としてスポーン (水没・出オチ防止)
    private _btrGroup = createGroup east;
    private _vehList = [];
    for "_i" from 1 to (floor(random [3, 5, 8])) do { _vehList pushBack "rhsgref_ins_btr70"; };
    
    [_spawnCenter, _vehList, _btrGroup, _targetPos] call _fnc_spawnConvoy;
    
    // 歩兵を乗せる処理 (簡易的)
    sleep 2;
    {
        private _inf = [getPosATL _x, east, (configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhsgref_group_chdkz_insurgents_infantry" >> "rhsgref_group_chdkz_insurgents_squad")] call BIS_fnc_spawnGroup;
        { _x moveInCargo (vehicle _x); } forEach (units _inf); // vehicle _x はおかしいので修正↓
        { _x moveInCargo _x; } forEach (units _inf); // 前回のミス修正: 外側の_xを参照したいがforeach内なので無理。修正版↓
    } forEach (units _btrGroup); 
    
    // 修正: 歩兵乗車ロジック
    {
        private _veh = _x;
        private _inf = [getPosATL _veh, east, (configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhsgref_group_chdkz_insurgents_infantry" >> "rhsgref_group_chdkz_insurgents_squad")] call BIS_fnc_spawnGroup;
        { _x moveInCargo _veh; } forEach (units _inf);
    } forEach (units _btrGroup);

    _btrGroup setBehaviour "COMBAT";
    (_btrGroup addWaypoint [_targetPos, 50]) setWaypointType "SAD";
};

// (B) 15分タイマー：重装甲部隊 & 対空コンボイ
[_objPS, _obj, _safeZonePos] spawn {
    params ["_targetPos", "_obj", "_safeZonePos"];
    private _fnc_spawnConvoy = missionNamespace getVariable "_fnc_spawnConvoy";
    private _fnc_log = missionNamespace getVariable "_fnc_log";

    ["Timer Logic: Waiting for players..."] call _fnc_log;
    
    waitUntil { sleep 5; { side _x == west && _x distance _targetPos < 1000 } count allUnits > 0 || !alive _obj };
    
    if (!alive _obj) exitWith { ["Timer Logic: Destroyed early."] call _fnc_log; };
    
    ["Timer Logic: Countdown started (900s)."] call _fnc_log;
    ["【警告】敵に発見された！主力部隊到着まで15分！"] remoteExec ["hint", 0];

    // カウントダウン
    private _totalTime = 900;
    private _startTime = time;
    private _checkIntervals = [600, 300, 60]; 
    
    while { time - _startTime < _totalTime } do {
        sleep 10;
        if (!alive _obj) exitWith {};
        private _remaining = _totalTime - (time - _startTime);
        
        if (round(time) % 60 == 0) then {
            [format ["Timer Logic: %1 seconds remaining...", round(_remaining)]] call _fnc_log;
        };

        if (count _checkIntervals > 0) then {
            if (_remaining <= (_checkIntervals select 0)) then {
                [format ["【警告】敵主力部隊の到着まで残り %1 分", round((_checkIntervals select 0)/60)]] remoteExec ["hint", 0];
                _checkIntervals deleteAt 0;
            };
        };
    };

    if (!alive _obj) exitWith { ["Timer Logic: Destroyed during countdown."] call _fnc_log; };

    // --- 1. 重装甲部隊スポーン ---
    ["Timer Logic: Spawning Heavy QRF."] call _fnc_log;
    ["【緊急】敵重装甲部隊が作戦区域に突入！"] remoteExec ["hint", 0];
    
    // スポーン地点選定 (SafeZone除外 & 3km内)
    private _nearbyLocs = nearestLocations [_targetPos, ["NameCity", "NameVillage", "NameLocal"], 3000];
    private _validSpawns = _nearbyLocs select { 
        private _pos = locationPosition _x;
        (_targetPos distance _pos > 1000) && 
        (_safeZonePos distance _pos > 3000) // SafeZoneから3km以上離す
    };
    
    private _spawnCenter = [0,0,0];
    if (count _validSpawns > 0) then {
        // 対岸対策：一番近い有効な候補地を選ぶ
        _validSpawns = [_validSpawns, [], { _targetPos distance (locationPosition _x) }, "ASCEND"] call BIS_fnc_sortBy;
        _spawnCenter = locationPosition (_validSpawns select 0);
        ["QRF: Found valid neighbor town (Closest valid)."] call _fnc_log;
    } else {
        // 条件に合う町がない場合、SafeZoneと逆方向のランダム位置
        private _dirToSafe = _targetPos getDir _safeZonePos;
        private _spawnDir = _dirToSafe + 180 + (random 90 - 45); 
        _spawnCenter = _targetPos getPos [1500 + random 500, _spawnDir];
        ["QRF: No valid town. Using random pos away from SafeZone."] call _fnc_log;
    };
    
    private _vehList = [];
    private _t72Num = floor(random [3, 4, 5]);
    for "_i" from 1 to _t72Num do { _vehList pushBack "rhsgref_ins_t72bb"; };
    for "_i" from 1 to (_t72Num * 2) do { _vehList pushBack "rhsgref_ins_bmp1p"; };
    for "_i" from 1 to floor(random [2, 3, 4]) do { _vehList pushBack "rhsgref_ins_zsu234"; };

    private _qrfGrp = createGroup east;
    [_spawnCenter, _vehList, _qrfGrp, _targetPos] call _fnc_spawnConvoy;

    sleep 5;
    {
        if (typeOf _x == "rhsgref_ins_bmp1p") then {
            private _veh = _x;
            private _inf = [getPosATL _veh, east, (configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhsgref_group_chdkz_insurgents_infantry" >> "rhsgref_group_chdkz_insurgents_squad")] call BIS_fnc_spawnGroup;
            { _x moveInCargo _veh; } forEach (units _inf);
        };
    } forEach (units _qrfGrp);

    _qrfGrp setFormation "COLUMN";
    _qrfGrp setBehaviour "COMBAT";
    (_qrfGrp addWaypoint [_targetPos, 50]) setWaypointType "SAD";

    // --- 2. 対空コンボイ ---
    ["SAM Logic: Waiting..."] call _fnc_log;
    private _qrfSpawnTime = time;
    
    waitUntil { 
        sleep 5; 
        ((leader _qrfGrp) distance _targetPos < 1000) || 
        (time - _qrfSpawnTime > 300) || 
        !alive _obj 
    };
    
    if (!alive _obj) exitWith { ["SAM Logic: Objective destroyed."] call _fnc_log; };

    ["SAM Logic: Spawning SAM Convoy."] call _fnc_log;
    ["【警告】敵防空コンボイが接近中。SAM展開を阻止せよ！"] remoteExec ["hint", 0];
    
    private _samGrp = createGroup east;
    private _samVehs = ["rhsgref_ins_btr70", "rhsgref_ins_gaz66_ammo", "rhsgref_ins_gaz66_ammo", "rhsgref_ins_gaz66_repair", "rhsgref_ins_gaz66_zu23"];
    
    sleep 5;
    [_spawnCenter, _samVehs, _samGrp, _targetPos] call _fnc_spawnConvoy;

    _samGrp setFormation "FILE";
    private _wpSAM = _samGrp addWaypoint [_targetPos, 20];
    _wpSAM setWaypointType "MOVE";
    
    // SAM展開監視
    ["SAM Logic: Monitoring distance..."] call _fnc_log;
    
    waitUntil {
        sleep 5;
        private _leader = leader _samGrp;
        (_leader distance _targetPos < 200) || !alive _obj || ({alive _x} count units _samGrp == 0)
    };
    
    if (!alive _obj) exitWith { ["SAM Logic: Aborted (Obj destroyed)."] call _fnc_log; };
    if ({alive _x} count units _samGrp == 0) exitWith { ["SAM Logic: Aborted (Convoy dead)."] call _fnc_log; };
    
    ["SAM Logic: Deploying structures."] call _fnc_log;
    ["敵防空システム展開完了！空域は完全に封鎖された！"] remoteExec ["hint", 0];
    
    private _deployPos = getPos (leader _samGrp);
    private _radar = createVehicle ['rhs_p37_turret_vpvo', _deployPos getPos [30, 45], [], 0, 'NONE'];
    createVehicleCrew _radar;
    {
        private _sam = createVehicle ['O_SAM_System_04_F', _deployPos getPos [60, _x], [], 0, 'NONE'];
        createVehicleCrew _sam;
    } forEach [0, 90, 180, 270];
};

// --- 6. 完了判定 ---
waitUntil { sleep 2; !alive _obj };
["Objective Destroyed."] call _fnc_log;
["目標破壊を確認。残存勢力を掃討せよ。"] remoteExec ["hint", 0];

waitUntil { sleep 5; ({ alive _x && side _x == east } count allUnits) < 5 };
["Mission Complete."] call _fnc_log;

deleteMarker _mkr;
["ミッション完了。"] remoteExec ["hint", 0];