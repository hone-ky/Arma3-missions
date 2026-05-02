/*
    動的拠点奪還ミッション生成スクリプト (Ver 1.11 - メニュー重複バグ修正版)
*/

// ==========================================
// 1. コンフィグ設定エリア
// ==========================================

MISSION_cfg_EnemyFaction = "rhsgref_faction_chdkz";

// --- HQ（指揮所）分隊 ---
MISSION_cfg_HQ_Squad    = ["rhsgref_ins_commander", "rhsgref_ins_squadleader", "rhsgref_ins_rifleman"];
MISSION_cfg_HQ_IFV      = "rhsgref_ins_bmp1k";

// --- MAIN（本隊）: BTRの限界(14名)まで増員した特大分隊 ---
MISSION_cfg_Main_Squad  = [
    "rhsgref_ins_squadleader",     
    "rhsgref_ins_machinegunner",   
    "rhsgref_ins_machinegunner",   
    "rhsgref_ins_grenadier_rpg",   
    "rhsgref_ins_grenadier_rpg",   
    "rhsgref_ins_grenadier",       
    "rhsgref_ins_grenadier",       
    "rhsgref_ins_medic",           
    "rhsgref_ins_sniper",          
    "rhsgref_ins_rifleman_akm",    
    "rhsgref_ins_rifleman_akm",    
    "rhsgref_ins_rifleman_akm",    
    "rhsgref_ins_rifleman",        
    "rhsgref_ins_rifleman"         
];
MISSION_cfg_Main_APC    = "rhsgref_ins_btr60";

// --- SENTRY（歩哨）: リアルなソ連式4名編成 ---
MISSION_cfg_Sentry_Inf  = [
    "rhsgref_ins_squadleader",     
    "rhsgref_ins_machinegunner",   
    "rhsgref_ins_grenadier_rpg",   
    "rhsgref_ins_rifleman_akm"     
];
MISSION_cfg_Sentry_Veh  = "rhsgref_ins_uaz_dshkm";

// --- オブジェクト関連 ---
MISSION_cfg_Obj_HQ_Bldg = ["Land_Cargo_HQ_V1_F", "Land_DeconTent_01_NATO_F"];
MISSION_cfg_Obj_Antenna = "Land_communication_F";
MISSION_cfg_Obj_Table   = "Land_CampingTable_F";
MISSION_cfg_Obj_Laptop  = "Land_Laptop_02_unfolded_F";
MISSION_cfg_Obj_FOB_Tent = "Land_TentA_F";
MISSION_cfg_Obj_FOB_Fire = "Campfire_burning_F";
MISSION_cfg_Obj_FOB_Ammo = "Land_PortableCabinet_01_closed_olive_F";
MISSION_cfg_MilBldgs = ["cargo_hq", "cargo_tower", "cargo_house", "cargo_patrol"];
MISSION_cfg_MilWalls = ["hbarrier"];


// ==========================================
// 2. ユーティリティ・管理変数群
// ==========================================

MISSION_fnc_Log = {
    params ["_msg"];
    private _time = systemTime;
    private _logStr = format ["[MISSION_GEN] %1:%2:%3 - %4", _time#3, _time#4, _time#5, _msg];
    diag_log _logStr;
};

if (isNil "MISSION_GeneratedObjects") then { missionNamespace setVariable ["MISSION_GeneratedObjects", [], true]; };
if (isNil "MISSION_GeneratedGroups") then { missionNamespace setVariable ["MISSION_GeneratedGroups", [], true]; };
if (isNil "MISSION_CurrentTaskID") then { missionNamespace setVariable ["MISSION_CurrentTaskID", "", true]; };


// ==========================================
// 3. 拠点検索ロジック
// ==========================================

MISSION_fnc_FindMilitaryBase = {
    params ["_originPos", "_minDist", "_maxDist"];
    ["拠点検索を開始します..."] call MISSION_fnc_Log;
    
    private _allObjects = nearestObjects [_originPos, ["Building", "House", "Strategic"], _maxDist];
    private _potentialBases = [];
    
    {
        private _targetObj = _x; 
        private _objPos = getPos _targetObj;
        private _dist = _originPos distance _objPos;
        
        if (_dist >= _minDist && _dist <= _maxDist) then {
            private _classStr = toLower (typeOf _targetObj);
            private _isMilBase = false;
            
            { if (_classStr find _x >= 0) exitWith { _isMilBase = true; }; } forEach MISSION_cfg_MilBldgs;
            
            if (!_isMilBase) then {
                {
                    if (_classStr find _x >= 0) exitWith {
                        private _walls = nearestObjects [_objPos, [typeOf _targetObj], 50];
                        if (count _walls >= 5) then { _isMilBase = true; };
                    };
                } forEach MISSION_cfg_MilWalls;
            };
            
            if (_isMilBase) then { _potentialBases pushBack _objPos; };
        };
    } forEach _allObjects;
    
    if (count _potentialBases == 0) exitWith {
        ["エラー: 条件に合致する軍事施設が見つかりません。"] call MISSION_fnc_Log;
        [0,0,0]
    };
    
    private _selectedPos = selectRandom _potentialBases;
    [format ["軍事施設を発見。中心座標: %1", _selectedPos]] call MISSION_fnc_Log;
    _selectedPos
};


// ==========================================
// 4. オブジェクト構築関数
// ==========================================

MISSION_fnc_BuildHQ = {
    params ["_centerPos"];
    ["HQ構築を開始します..."] call MISSION_fnc_Log;
    
    private _hqPos = _centerPos findEmptyPosition [0, 50, MISSION_cfg_Obj_HQ_Bldg select 0];
    if (_hqPos isEqualTo []) then { _hqPos = _centerPos; }; 

    private _bldgClass = selectRandom MISSION_cfg_Obj_HQ_Bldg;
    private _hqBldg = createVehicle [_bldgClass, _hqPos, [], 0, "CAN_COLLIDE"];
    _hqBldg setDir (random 360);
    _hqBldg setPos _hqPos;
    _hqBldg setVectorUp [0,0,1]; 
    
    private _antennaPos = _hqBldg getRelPos [10, 45];
    private _antenna = createVehicle [MISSION_cfg_Obj_Antenna, _antennaPos, [], 0, "CAN_COLLIDE"];
    _antenna setPos _antennaPos;
    
    private _tablePos = _hqBldg getRelPos [5, 180];
    private _table = createVehicle [MISSION_cfg_Obj_Table, _tablePos, [], 0, "CAN_COLLIDE"];
    _table setPos _tablePos;
    private _laptop = createVehicle [MISSION_cfg_Obj_Laptop, _tablePos, [], 0, "CAN_COLLIDE"];
    _laptop setPosASL (getPosASL _table vectorAdd [0, 0, 0.8]);

    private _currentObjs = missionNamespace getVariable ["MISSION_GeneratedObjects", []];
    _currentObjs append [_hqBldg, _antenna, _table, _laptop];
    missionNamespace setVariable ["MISSION_GeneratedObjects", _currentObjs, true];

    _hqPos
};

MISSION_fnc_BuildFOB = {
    params ["_targetPos"];
    ["FOB構築を開始します..."] call MISSION_fnc_Log;
    
    private _fobPos = _targetPos getPos [1500 + random 1000, random 360];
    
    private _tent = createVehicle [MISSION_cfg_Obj_FOB_Tent, _fobPos, [], 0, "NONE"];
    private _firePos = _tent getRelPos [5, 0];
    private _fire = createVehicle [MISSION_cfg_Obj_FOB_Fire, _firePos, [], 0, "NONE"];
    private _ammoPos = _tent getRelPos [4, 90];
    private _ammo = createVehicle [MISSION_cfg_Obj_FOB_Ammo, _ammoPos, [], 0, "NONE"];
    
    private _currentObjs = missionNamespace getVariable ["MISSION_GeneratedObjects", []];
    _currentObjs append [_tent, _fire, _ammo];
    missionNamespace setVariable ["MISSION_GeneratedObjects", _currentObjs, true];

    _fobPos
};


// ==========================================
// 5. AI生成関数
// ==========================================

MISSION_fnc_SpawnMechanizedSquad = {
    params ["_spawnPos", "_infantryClasses", "_vehicleClass", "_side", "_type"];
    [format ["%1 分隊の生成を開始...", _type]] call MISSION_fnc_Log;

    private _grp = createGroup _side;
    
    private _vehPos = _spawnPos findEmptyPosition [5, 150, _vehicleClass];
    if (_vehPos isEqualTo []) then { _vehPos = _spawnPos; };
    private _vehicle = createVehicle [_vehicleClass, _vehPos, [], 0, "NONE"];
    
    createVehicleCrew _vehicle;
    (crew _vehicle) joinSilent _grp;
    
    { _grp createUnit [_x, _spawnPos, [], 5, "FORM"]; } forEach _infantryClasses;
    
    _grp setVariable ["MISSION_AssignedVehicle", _vehicle];

    private _currentObjs = missionNamespace getVariable ["MISSION_GeneratedObjects", []];
    _currentObjs pushBack _vehicle;
    missionNamespace setVariable ["MISSION_GeneratedObjects", _currentObjs, true];

    private _currentGrps = missionNamespace getVariable ["MISSION_GeneratedGroups", []];
    _currentGrps pushBack _grp;
    missionNamespace setVariable ["MISSION_GeneratedGroups", _currentGrps, true];

    _grp
};


// ==========================================
// 6. AI戦術タスク関数群
// ==========================================

MISSION_fnc_FindTacticalPositions = {
    params ["_center", "_radius", "_count"];
    private _places = selectBestPlaces [_center, _radius, "hills + trees", 50, _count];
    private _tacticalPosList = [];
    { _tacticalPosList pushBack (_x select 0); } forEach _places;
    _tacticalPosList
};

MISSION_fnc_TaskHQ = {
    params ["_group", "_hqBldgPos"];
    _group setBehaviour "AWARE";
    _group setCombatMode "YELLOW";
    private _wp = _group addWaypoint [_hqBldgPos, 0];
    _wp setWaypointType "HOLD";
    
    private _vehicle = _group getVariable ["MISSION_AssignedVehicle", objNull];
    { 
        if (_x != driver _vehicle && _x != gunner _vehicle && _x != commander _vehicle) then {
            _x setUnitPos "MIDDLE"; doStop _x; 
        };
    } forEach units _group;
};

MISSION_fnc_TaskMain = {
    params ["_group", "_targetPos", "_isDefender"];
    
    if (_isDefender) then {
        [_group, _targetPos] spawn {
            params ["_grp", "_homePos"];
            while { missionNamespace getVariable ["MISSION_IsActive", false] } do {
                while {(count (waypoints _grp)) > 0} do { deleteWaypoint ((waypoints _grp) select 0); };
                _grp setBehaviour "SAFE";
                _grp setSpeedMode "LIMITED";
                for "_i" from 1 to 4 do {
                    private _wpPos = _homePos getPos [10 + random 40, random 360];
                    private _wp = _grp addWaypoint [_wpPos, 0];
                    _wp setWaypointType "MOVE";
                    _wp setWaypointTimeout [10, 30, 60];
                };
                private _wpLoop = _grp addWaypoint [_homePos, 0];
                _wpLoop setWaypointType "CYCLE";

                waitUntil { sleep 5; missionNamespace getVariable ["MISSION_Global_CombatFlag", false] || ({alive _x} count units _grp == 0) || !(missionNamespace getVariable ["MISSION_IsActive", false]) };
                if ({alive _x} count units _grp == 0 || !(missionNamespace getVariable ["MISSION_IsActive", false])) exitWith {};
                
                ["拠点防衛組、前線の交戦報告を受信。拠点周辺の警戒パトロールへ移行！"] call MISSION_fnc_Log;
                
                while {(count (waypoints _grp)) > 0} do { deleteWaypoint ((waypoints _grp) select 0); };
                _grp setBehaviour "AWARE";
                _grp setCombatMode "YELLOW";
                _grp setSpeedMode "NORMAL";
                for "_i" from 1 to 4 do {
                    private _wpPos = _homePos getPos [30 + random 70, random 360];
                    private _wp = _grp addWaypoint [_wpPos, 0];
                    _wp setWaypointType "MOVE";
                    _wp setWaypointTimeout [5, 10, 20];
                };
                private _wpLoop2 = _grp addWaypoint [_homePos, 0];
                _wpLoop2 setWaypointType "CYCLE";

                waitUntil { sleep 5; !(missionNamespace getVariable ["MISSION_Global_CombatFlag", false]) || ({alive _x} count units _grp == 0) || !(missionNamespace getVariable ["MISSION_IsActive", false]) };
                if ({alive _x} count units _grp == 0 || !(missionNamespace getVariable ["MISSION_IsActive", false])) exitWith {};
                
                ["拠点防衛組、交戦状態の解除を確認。通常哨戒に戻ります。"] call MISSION_fnc_Log;
            };
        };
    } else {
        _group setBehaviour "SAFE";
        _group setSpeedMode "LIMITED";
        
        for "_i" from 1 to 3 do {
            private _wpPos = _targetPos getPos [5 + random 25, random 360];
            private _wp = _group addWaypoint [_wpPos, 0];
            _wp setWaypointType "MOVE";
            _wp setWaypointTimeout [15, 30, 45]; 
        };
        private _wpLoop = _group addWaypoint [_targetPos, 0];
        _wpLoop setWaypointType "CYCLE";
        
        [_group, _targetPos] spawn {
            params ["_grp", "_homePos"];
            
            while { missionNamespace getVariable ["MISSION_IsActive", false] } do {
                private _vehicle = _grp getVariable ["MISSION_AssignedVehicle", objNull];
                
                waitUntil {
                    sleep 5;
                    missionNamespace getVariable ["MISSION_Global_CombatFlag", false] || {behaviour leader _grp == "COMBAT"} || !(missionNamespace getVariable ["MISSION_IsActive", false])
                };
                
                if ({alive _x} count units _grp == 0 || !(missionNamespace getVariable ["MISSION_IsActive", false])) exitWith {}; 
                
                ["本隊迎撃組、交戦を確認！APCに搭乗し出撃！"] call MISSION_fnc_Log;
                _grp setBehaviour "AWARE";
                
                while {(count (waypoints _grp)) > 0} do { deleteWaypoint ((waypoints _grp) select 0); };
                
                if (!isNull _vehicle && canMove _vehicle) then {
                    { 
                        if (vehicle _x == _x) then { 
                            _x assignAsCargo _vehicle; [_x] orderGetIn true; 
                        };
                    } forEach units _grp;
                    
                    private _timeoutBoarding = time + 60;
                    waitUntil { sleep 3; ({alive _x && vehicle _x == _x} count units _grp == 0) || time > _timeoutBoarding };
                };
                
                private _enemyPos = missionNamespace getVariable ["MISSION_Global_KnownEnemyPos", _homePos];
                private _wpApproach = _grp addWaypoint [_enemyPos, 0];
                _wpApproach setWaypointType "MOVE";
                _wpApproach setWaypointSpeed "NORMAL";
                
                waitUntil {
                    sleep 2;
                    (!isNull _vehicle && {(_vehicle distance _enemyPos) < 400}) || !canMove _vehicle || (leader _grp distance _enemyPos < 400) || !(missionNamespace getVariable ["MISSION_IsActive", false])
                };
                if !(missionNamespace getVariable ["MISSION_IsActive", false]) exitWith {};
                
                ["APCが交戦距離に到達。歩兵を降車展開します！"] call MISSION_fnc_Log;
                {
                    if (_x != driver _vehicle && _x != gunner _vehicle && _x != commander _vehicle) then {
                        unassignVehicle _x; doGetOut _x;
                    };
                } forEach units _grp;
                
                private _wpInfAttack = _grp addWaypoint [_enemyPos, 50];
                _wpInfAttack setWaypointType "SAD";
                _grp setBehaviour "COMBAT";
                
                if (alive driver _vehicle) then {
                    private _vehGrp = group driver _vehicle;
                    while {(count (waypoints _vehGrp)) > 0} do { deleteWaypoint ((waypoints _vehGrp) select 0); };
                    doStop (driver _vehicle);
                    _vehGrp setCombatMode "YELLOW";
                    _vehGrp setBehaviour "COMBAT";
                };
                
                sleep 60; 
                waitUntil { sleep 10; !(missionNamespace getVariable ["MISSION_Global_CombatFlag", false]) || ({alive _x} count units _grp == 0) || !(missionNamespace getVariable ["MISSION_IsActive", false]) };
                if ({alive _x} count units _grp == 0 || !(missionNamespace getVariable ["MISSION_IsActive", false])) exitWith {};
                
                ["本隊迎撃組、対象エリアの沈黙を確認。APCに再搭乗し拠点へ帰還(RTB)します。"] call MISSION_fnc_Log;
                
                while {(count (waypoints _grp)) > 0} do { deleteWaypoint ((waypoints _grp) select 0); };
                _grp setBehaviour "AWARE";
                
                if (!isNull _vehicle && canMove _vehicle) then {
                    { 
                        if (_x != driver _vehicle && _x != gunner _vehicle && _x != commander _vehicle) then {
                            _x assignAsCargo _vehicle; [_x] orderGetIn true; 
                        };
                    } forEach units _grp;
                    
                    private _timeoutRTB = time + 60;
                    waitUntil { sleep 3; ({alive _x && vehicle _x == _x} count units _grp == 0) || time > _timeoutRTB };
                };
                
                private _wpRTB = _grp addWaypoint [_homePos, 0];
                _wpRTB setWaypointType "MOVE";
                _wpRTB setWaypointSpeed "NORMAL";
                
                waitUntil { sleep 5; (leader _grp distance _homePos < 100) || (!canMove _vehicle && leader _grp distance _homePos < 50) || !(missionNamespace getVariable ["MISSION_IsActive", false]) };
                if !(missionNamespace getVariable ["MISSION_IsActive", false]) exitWith {};
                
                ["本隊迎撃組、拠点に帰還。周辺の警戒掃討（CQB）を実施します。"] call MISSION_fnc_Log;
                
                if (!isNull _vehicle) then {
                    {
                        if (_x != driver _vehicle && _x != gunner _vehicle && _x != commander _vehicle) then {
                            unassignVehicle _x; doGetOut _x;
                        };
                    } forEach units _grp;
                };
                
                _grp setBehaviour "AWARE";
                _grp setCombatMode "YELLOW";
                _grp setSpeedMode "NORMAL";
                
                for "_i" from 1 to 4 do {
                    private _wpPos = _homePos getPos [20 + random 50, random 360];
                    private _wpCQB = _grp addWaypoint [_wpPos, 0];
                    _wpCQB setWaypointType "MOVE";
                    _wpCQB setWaypointTimeout [10, 20, 30]; 
                };
                
                private _wpRelax = _grp addWaypoint [_homePos, 0];
                _wpRelax setWaypointType "MOVE";
                _wpRelax setWaypointStatements ["true", "group this setBehaviour 'SAFE'; group this setSpeedMode 'LIMITED';"];
                
                private _wpLoop2 = _grp addWaypoint [_homePos, 0];
                _wpLoop2 setWaypointType "CYCLE";
                
                ["本隊迎撃組、掃討完了。通常待機に戻ります。"] call MISSION_fnc_Log;
                sleep 5;
            };
        };
    };
};

MISSION_fnc_TaskSentry = {
    params ["_group", "_patrolCenter"];
    _group setBehaviour "SAFE";
    _group setSpeedMode "LIMITED";
    _group setCombatMode "GREEN"; 
    
    for "_i" from 1 to 3 do {
        private _wpPos = _patrolCenter getPos [100 + random 200, random 360];
        private _wp = _group addWaypoint [_wpPos, 0];
        _wp setWaypointType "MOVE";
        _wp setWaypointTimeout [20, 45, 90];
    };
    private _wpLoop = _group addWaypoint [_patrolCenter, 0];
    _wpLoop setWaypointType "CYCLE";
    
    [_group] spawn {
        params ["_grp"];
        private _leader = leader _grp;
        private _vehicle = _grp getVariable ["MISSION_AssignedVehicle", objNull];
        
        waitUntil {
            sleep 2;
            private _target = _leader findNearestEnemy _leader;
            (!isNull _target && {(_leader knowsAbout _target) > 1.5}) || !(missionNamespace getVariable ["MISSION_IsActive", false])
        };
        if !(missionNamespace getVariable ["MISSION_IsActive", false]) exitWith {};
        
        private _enemy = _leader findNearestEnemy _leader;
        private _enemyPos = getPos _enemy;
        [format ["歩哨が敵を発見！遮蔽へ移動し遅滞戦闘へ移行。座標: %1", mapGridPosition _enemyPos]] call MISSION_fnc_Log;
        
        missionNamespace setVariable ["MISSION_Global_CombatFlag", true, true];
        missionNamespace setVariable ["MISSION_Global_KnownEnemyPos", _enemyPos, true];
        
        while {(count (waypoints _grp)) > 0} do { deleteWaypoint ((waypoints _grp) select 0); };
        
        { 
            if (_x == driver _vehicle || _x == gunner _vehicle || _x == commander _vehicle) then {
                doStop (vehicle _x);
            } else {
                unassignVehicle _x; doGetOut _x;
                _x setUnitPos "UP"; 
                
                private _coverObjs = nearestTerrainObjects [_x, ["TREE", "SMALL TREE", "BUSH", "ROCK", "RUIN", "WALL", "FENCE"], 50, false, true];
                
                if (count _coverObjs > 0) then {
                    private _cover = _coverObjs select 0;
                    private _dirFromEnemy = _enemyPos getDir (getPos _cover);
                    private _hidePos = (getPos _cover) getPos [2, _dirFromEnemy]; 
                    
                    _x doMove _hidePos;
                    
                    [_x, _hidePos] spawn {
                        params ["_unit", "_pos"];
                        private _timeout = time + 15;
                        waitUntil { sleep 1; (_unit distance _pos < 3) || time > _timeout || !alive _unit };
                        doStop _unit;
                        _unit setUnitPos (selectRandom ["MIDDLE", "DOWN"]);
                    };
                } else {
                    doStop _x; _x setUnitPos (selectRandom ["MIDDLE", "DOWN"]); 
                };
            };
        } forEach units _grp;
        
        sleep 60; 
        ["歩哨、自由交戦を開始！"] call MISSION_fnc_Log;
        _grp setCombatMode "YELLOW";
        _grp setBehaviour "COMBAT";
    };
};


// ==========================================
// 7. タスク生成と監視
// ==========================================

MISSION_fnc_CreateAndMonitorTask = {
    params ["_targetPos"];
    private _taskID = format ["MISSION_Capture_%1", round(random 100000)];
    missionNamespace setVariable ["MISSION_CurrentTaskID", _taskID, true];
    
    [true, _taskID, ["指定された軍事施設に展開している敵部隊を排除せよ。", "拠点奪還", ""], _targetPos, "ASSIGNED", 1, true, "attack"] call BIS_fnc_taskCreate;
    
    [_targetPos, _taskID] spawn {
        params ["_pos", "_taskID"];
        waitUntil {
            sleep 5;
            private _enemyCount = { side _x == east && _x distance _pos < 150 && alive _x } count allUnits;
            (_enemyCount < 3) || !(missionNamespace getVariable ["MISSION_IsActive", false])
        };
        
        if (missionNamespace getVariable ["MISSION_IsActive", false]) then {
            [_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
            ["奪還任務完了！拠点の制圧を確認しました。"] call MISSION_fnc_Log;
            missionNamespace setVariable ["MISSION_IsActive", false, true];
            
            missionNamespace setVariable ["MISSION_GeneratedGroups", [], true];
            missionNamespace setVariable ["MISSION_GeneratedObjects", [], true];
            missionNamespace setVariable ["MISSION_CurrentTaskID", "", true];
        };
    };
};


// ==========================================
// 8. メイン実行関数 & 中断（リセット）関数
// ==========================================

MISSION_fnc_CancelMission = {
    params [["_caller", objNull]];

    // 1. タスクの削除
    private _taskID = missionNamespace getVariable ["MISSION_CurrentTaskID", ""];
    if (_taskID != "") then {
        [_taskID] call BIS_fnc_deleteTask;
        missionNamespace setVariable ["MISSION_CurrentTaskID", "", true];
    };

    // 2. ユニット（AI）の削除
    {
        if (!isNull _x) then {
            private _grp = _x;
            { deleteVehicle _x; } forEach units _grp;
            deleteGroup _grp;
        };
    } forEach (missionNamespace getVariable ["MISSION_GeneratedGroups", []]);

    // 3. オブジェクト・車両の削除
    {
        if (!isNull _x) then { deleteVehicle _x; };
    } forEach (missionNamespace getVariable ["MISSION_GeneratedObjects", []]);

    // 4. 管理変数の初期化
    missionNamespace setVariable ["MISSION_GeneratedGroups", [], true];
    missionNamespace setVariable ["MISSION_GeneratedObjects", [], true];
    missionNamespace setVariable ["MISSION_IsActive", false, true];
    missionNamespace setVariable ["MISSION_Global_CombatFlag", false, true];
    missionNamespace setVariable ["MISSION_Global_KnownEnemyPos", [0,0,0], true];

    "ミッションを中断し、対象物をすべて削除しました。再生成が可能です。" remoteExec ["hint", _caller];
};

MISSION_fnc_StartMission = {
    params [["_caller", objNull]]; 

    if (missionNamespace getVariable ["MISSION_IsActive", false]) exitWith { 
        "すでにミッションが進行中です！" remoteExec ["hint", _caller]; 
    };
    
    missionNamespace setVariable ["MISSION_GeneratedGroups", [], true];
    missionNamespace setVariable ["MISSION_GeneratedObjects", [], true];

    missionNamespace setVariable ["MISSION_IsActive", true, true];
    missionNamespace setVariable ["MISSION_Global_CombatFlag", false, true];
    missionNamespace setVariable ["MISSION_Global_KnownEnemyPos", [0,0,0], true];

    private _playerPos = if (!isNull _caller) then { getPos _caller } else { [0,0,0] };
    private _targetPos = [_playerPos, 1000, 5000] call MISSION_fnc_FindMilitaryBase;
    
    if (_targetPos isEqualTo [0,0,0]) exitWith {
        "ミッション生成失敗: 条件に合う拠点が見つかりません。" remoteExec ["hint", _caller];
        missionNamespace setVariable ["MISSION_IsActive", false, true];
    };
    
    (format ["ターゲット拠点決定！\n座標: %1\n敵部隊を展開中...", mapGridPosition _targetPos]) remoteExec ["hint", _caller];
    
    private _hqPos = [_targetPos] call MISSION_fnc_BuildHQ;
    private _fobPos = [_targetPos] call MISSION_fnc_BuildFOB;
    
    private _grp_HQ = [_hqPos, MISSION_cfg_HQ_Squad, MISSION_cfg_HQ_IFV, east, "HQ"] call MISSION_fnc_SpawnMechanizedSquad;
    
    private _mainSquads = [];
    for "_i" from 1 to 3 do {
        private _spawnPos = _targetPos getPos [20 + random 80, random 360];
        private _grp = [_spawnPos, MISSION_cfg_Main_Squad, MISSION_cfg_Main_APC, east, "MAIN"] call MISSION_fnc_SpawnMechanizedSquad;
        _mainSquads pushBack _grp;
    };
    
    private _sentrySquads = [];
    for "_i" from 1 to 8 do {
        private _spawnPos = _targetPos getPos [700 + random 800, random 360];
        private _grp = [_spawnPos, MISSION_cfg_Sentry_Inf, MISSION_cfg_Sentry_Veh, east, "SENTRY"] call MISSION_fnc_SpawnMechanizedSquad;
        _sentrySquads pushBack _grp;
    };
    
    [_grp_HQ, _hqPos] call MISSION_fnc_TaskHQ;
    
    {
        private _isDefender = (_forEachIndex == 0);
        [_x, _targetPos, _isDefender] call MISSION_fnc_TaskMain;
    } forEach _mainSquads;
    
    private _tacticalPositions = [_targetPos, 1500, 8] call MISSION_fnc_FindTacticalPositions;
    {
        private _patrolCenter = _targetPos;
        if (count _tacticalPositions > _forEachIndex) then {
            _patrolCenter = _tacticalPositions select _forEachIndex;
        } else {
            _patrolCenter = _targetPos getPos [700 + random 800, random 360];
        };
        [_x, _patrolCenter] call MISSION_fnc_TaskSentry;
    } forEach _sentrySquads;
    
    [_targetPos] call MISSION_fnc_CreateAndMonitorTask;
    
    [] spawn {
        while {missionNamespace getVariable ["MISSION_IsActive", false]} do {
            if (missionNamespace getVariable ["MISSION_Global_CombatFlag", false]) then {
                sleep 60; 
                private _isClear = true;
                {
                    if (side _x == east && alive _x) then {
                        if (count ((leader group _x targets [true, 600]) select {alive _x}) > 0) then {
                            _isClear = false;
                        };
                    };
                } forEach allUnits;
                
                if (_isClear) then {
                    sleep 60;
                    _isClear = true;
                    {
                        if (side _x == east && alive _x) then {
                            if (count ((leader group _x targets [true, 600]) select {alive _x}) > 0) then {
                                _isClear = false;
                            };
                        };
                    } forEach allUnits;
                    
                    if (_isClear) then {
                        missionNamespace setVariable ["MISSION_Global_CombatFlag", false, true];
                        ["[司令部] 敵影ロスト。全軍、警戒を解き通常任務に戻れ。"] call MISSION_fnc_Log;
                    };
                };
            };
            sleep 10;
        };
    };
    
    ["全セットアップ完了。戦闘を開始します。"] call MISSION_fnc_Log;
};


// ==========================================
// 9. ACEメニューへの登録 (トグル式 & 重複防止)
// ==========================================

if (hasInterface) then {
    [] spawn {
        waitUntil { !isNull player };
        waitUntil { !isNil "ace_interact_menu_fnc_createAction" };
        sleep 2; 

        // ★追加：重複登録防止フラグ
        if (player getVariable ["MISSION_MenuAdded", false]) exitWith {};
        player setVariable ["MISSION_MenuAdded", true, false];

        if (isClass(configFile >> "CfgPatches" >> "ace_interact_menu")) then {
            
            // アクション①：ミッション生成
            private _actionStart = [
                "Generate_Capture_Mission", 
                "ChDKZ 拠点奪還ミッション生成", 
                "\a3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa", 
                { 
                    params ["_target", "_player", "_params"];
                    [_player] remoteExec ["MISSION_fnc_StartMission", 2]; 
                }, 
                { !(missionNamespace getVariable ["MISSION_IsActive", false]) }
            ] call ace_interact_menu_fnc_createAction;
            
            [player, 1, ["ACE_SelfActions", "dynamic_mission_root"], _actionStart] call ace_interact_menu_fnc_addActionToObject;

            // アクション②：ミッション中断・消去
            private _actionCancel = [
                "Cancel_Capture_Mission", 
                "拠点奪還ミッションを中断・削除", 
                "\a3\ui_f\data\igui\cfg\simpleTasks\types\exit_ca.paa", 
                { 
                    params ["_target", "_player", "_params"];
                    [_player] remoteExec ["MISSION_fnc_CancelMission", 2]; 
                }, 
                { (missionNamespace getVariable ["MISSION_IsActive", false]) }
            ] call ace_interact_menu_fnc_createAction;
            
            [player, 1, ["ACE_SelfActions", "dynamic_mission_root"], _actionCancel] call ace_interact_menu_fnc_addActionToObject;
        };
    };
};