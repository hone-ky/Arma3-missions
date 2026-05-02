/*
    動的拠点奪還ミッション生成スクリプト (Step 1: 定義と検索)
*/

// ==========================================
// 1. コンフィグ設定エリア (後で変更しやすいようにグローバル変数化)
// ==========================================

// --- ユニット設定 (RHS ChDKZベース) ---
// スペルミスらしきものもご提示いただいたままにしています。必要に応じて修正してください。
MISSION_cfg_EnemyFaction = "rhsgref_faction_chdkz";

MISSION_cfg_HQ_Squad    = ["rhsgref_ins_commander", "rhsgref_ins_squadleader", "rhsgref_ins_rifleman"];
MISSION_cfg_HQ_IFV      = "rhsgref_ins_bmp1k";

MISSION_cfg_Main_Squad  = ["rhsgref_ins_grenadier", "rhsgref_ins_machinegunner", "rhsgref_ins_grenadier_rpg", "rhsgref_ins_rifleman_akm"];
MISSION_cfg_Main_APC    = "rhsgref_ins_btr60";

MISSION_cfg_Sentry_Inf  = ["rhsgref_ins_rifleman_akm", "rhsgref_ins_rifleman"]; // 本隊から抽出した軽装構成
MISSION_cfg_Sentry_Veh  = "rhsgref_ins_uaz_dshkm";

// --- オブジェクト設定 ---
MISSION_cfg_Obj_HQ_Bldg = ["Land_Cargo_HQ_V1_F", "Land_DeconTent_01_NATO_F"];
MISSION_cfg_Obj_Antenna = "Land_communication_F";
MISSION_cfg_Obj_Table   = "Land_CampingTable_F";
MISSION_cfg_Obj_Laptop  = "Land_Laptop_02_unfolded_F";
MISSION_cfg_Obj_HBarrier = "Land_HBarrier_Big_F";
MISSION_cfg_Obj_Sandbag = ["Land_BagFence_Long_F", "Land_BagFence_Round_F"];

MISSION_cfg_Obj_FOB_Tent = "Land_TentA_F";
MISSION_cfg_Obj_FOB_Fire = "Campfire_burning_F";
MISSION_cfg_Obj_FOB_Ammo = "Land_PortableCabinet_01_closed_olive_F";

// --- 拠点判定用オブジェクト設定 ---
// 1つでもあれば軍事施設とみなすもの（部分一致で検索するため小文字推奨）
MISSION_cfg_MilBldgs = ["cargo_hq", "cargo_tower", "cargo_house", "cargo_patrol"];
// 5つ以上密集で拠点とみなすもの
MISSION_cfg_MilWalls = ["hbarrier"];


// ==========================================
// 2. ログ出力用関数
// ==========================================
MISSION_fnc_Log = {
    params ["_msg"];
    private _time = systemTime;
    private _logStr = format ["[MISSION_GEN] %1:%2:%3 - %4", _time#3, _time#4, _time#5, _msg];
    diag_log _logStr;
    systemChat _logStr; // テスト用。本番では消してOK
};

// ==========================================
// 3. 拠点検索ロジック関数
// ==========================================
MISSION_fnc_FindMilitaryBase = {
    params ["_originPos", "_minDist", "_maxDist"];
    
    ["拠点検索を開始します..."] call MISSION_fnc_Log;
    
    private _searchRadius = _maxDist;
    // 指定範囲内のすべての建物を取得
    private _allObjects = nearestObjects [_originPos, ["Building", "House", "Strategic"], _searchRadius];
    private _potentialBases = [];
    
    {
        private _obj = _x;
        private _objPos = getPos _obj;
        private _dist = _originPos distance _objPos;
        
        if (_dist >= _minDist && _dist <= _maxDist) then {
            private _classStr = toLower (typeOf _obj);
            private _isMilBase = false;
            
            // 1つでもあれば確定のオブジェクトチェック (部分一致)
            {
                if (_classStr find _x >= 0) exitWith { _isMilBase = true; };
            } forEach MISSION_cfg_MilBldgs;
            
            // Hbarrier等の密集度チェック
            if (!_isMilBase) then {
                {
                    if (_classStr find _x >= 0) exitWith {
                        // 周辺50m以内に同じ種類の壁が5つ以上あるかチェック
                        private _walls = nearestObjects [_objPos, [typeOf _obj], 50];
                        if (count _walls >= 5) then { _isMilBase = true; };
                    };
                } forEach MISSION_cfg_MilWalls;
            };
            
            if (_isMilBase) then {
                _potentialBases pushBack _objPos;
            };
        };
    } forEach _allObjects;
    
    if (count _potentialBases == 0) exitWith {
        ["エラー: 条件に合致する軍事施設が1km〜5km圏内に見つかりませんでした。"] call MISSION_fnc_Log;
        [0,0,0] // エラー値
    };
    
    // 見つかった候補の中からランダムに1つ選定
    private _selectedPos = selectRandom _potentialBases;
    [format ["軍事施設を発見。中心座標: %1", _selectedPos]] call MISSION_fnc_Log;
    
    _selectedPos
};

// ==========================================
// 4. メイン処理 (ACEメニューから呼ばれる関数)
// ==========================================
MISSION_fnc_StartMission = {
    ["ミッション生成要求を受信。"] call MISSION_fnc_Log;
    
    private _playerPos = getPos player;
    private _targetPos = [_playerPos, 1000, 5000] call MISSION_fnc_FindMilitaryBase;
    
    if (_targetPos isEqualTo [0,0,0]) exitWith {
        hint "ミッション生成失敗: 周辺に適切な軍事施設がありません。";
    };
    
    hint format ["ターゲット拠点決定！\n座標: %1\n\nここからHQ生成・敵配置へ移行します...", mapGridPosition _targetPos];
    
    // --- ここに次のフェーズ（HQ構築、AIスポーン）の関数を呼び出す処理が入ります ---
    // [_targetPos] spawn MISSION_fnc_BuildHQ;
    // [_targetPos] spawn MISSION_fnc_SpawnEnemies;

    // ==========================================
    // 8. メイン処理（前回の StartMission 関数を拡張）
    // ==========================================
    // 前回の MISSION_fnc_StartMission 内のコメントアウト部分を以下のように書き換えます。


    // --- 前回の StartMission の続き ---
    
    // HQオブジェクトの構築
    private _hqPos = [_targetPos] call MISSION_fnc_BuildHQ;
    
    // FOB（敵キャンプ）の構築
    private _fobPos = [_playerPos, _targetPos] call MISSION_fnc_BuildFOB;
    
    // --- 敵のスポーン処理 ---
    ["全敵部隊の展開を開始します..."] call MISSION_fnc_Log;
    
    // 1. HQ分隊の生成（IFV付き）
    private _grp_HQ = [_hqPos, MISSION_cfg_HQ_Squad, MISSION_cfg_HQ_IFV, east, "HQ"] call MISSION_fnc_SpawnMechanizedSquad;
    
    // 2. 本隊の生成（3分隊、APC付き）
    private _mainSquads = [];
    for "_i" from 1 to 3 do {
        private _spawnPos = [_targetPos, 20, 150, 5, 0, 0.3, 0] call BIS_fnc_findSafePos;
        private _grp = [_spawnPos, MISSION_cfg_Main_Squad, MISSION_cfg_Main_APC, east, "MAIN"] call MISSION_fnc_SpawnMechanizedSquad;
        _mainSquads pushBack _grp;
    };
    
    // 3. 歩哨の生成（8分隊、テクニカル付き）
    private _sentrySquads = [];
    for "_i" from 1 to 8 do {
        // 拠点から1km〜2kmの範囲に散らして配置
        private _spawnPos = [_targetPos, 1000, 2000, 5, 0, 0.3, 0] call BIS_fnc_findSafePos;
        private _grp = [_spawnPos, MISSION_cfg_Sentry_Inf, MISSION_cfg_Sentry_Veh, east, "SENTRY"] call MISSION_fnc_SpawnMechanizedSquad;
        _sentrySquads pushBack _grp;
    };
    
    ["全敵部隊の展開完了。タスク作成へ移行します。"] call MISSION_fnc_Log;
    
    // ==========================================
    // 11. メイン処理の拡張（前回のコードの続きに組み込み）
    // ==========================================

    // --- StartMission 関数の敵展開直後の処理 ---
    
    missionNamespace setVariable ["MISSION_Global_CombatFlag", false, true];
    
    // 1. HQのタスク割り当て
    [_grp_HQ, _hqPos] call MISSION_fnc_TaskHQ;
    
    // 2. 本隊のタスク割り当て（1分隊は防衛、残り2分隊は迎撃待機）
    {
        private _isDefender = (_forEachIndex == 0); // 最初の1部隊だけ防衛
        [_x, _targetPos, _isDefender] call MISSION_fnc_TaskMain;
    } forEach _mainSquads;
    
    // 3. 歩哨のタスク割り当て（重要地点を探してそこに配置）
    private _tacticalPositions = [_targetPos, 2500, 8] call MISSION_fnc_FindTacticalPositions;
    {
        private _patrolCenter = _targetPos;
        // 重要地点が取得できていればそこを哨戒の起点にする
        if (count _tacticalPositions > _forEachIndex) then {
            _patrolCenter = _tacticalPositions select _forEachIndex;
        } else {
            // 足りなければ拠点から1.5km付近のランダムな場所
            _patrolCenter = [_targetPos, 1000, 2000, 5, 0, 0.2, 0] call BIS_fnc_findSafePos; 
        };
        
        // 配置場所を _patrolCenter 周辺に再設定してタスク付与
        [_x, _patrolCenter] call MISSION_fnc_TaskSentry;
        
    } forEach _sentrySquads;

};

// ==========================================
// 5. ACE3 セルフインタラクションメニューへの追加
// ==========================================
if (isClass(configFile >> "CfgPatches" >> "ace_interact_menu")) then {
    private _action = [
        "Generate_Mission", 
        "軍事施設 奪還ミッション生成", 
        "", 
        { [] spawn MISSION_fnc_StartMission; }, 
        { true } // 実行条件 (常に表示。ミッション中かどうかのフラグを後で追加可能)
    ] call ace_interact_menu_fnc_createAction;
    
    [player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    ["ACEメニューにミッション生成を追加しました。"] call MISSION_fnc_Log;
};

/*
    動的拠点奪還ミッション生成スクリプト (Step 2: オブジェクト構築とAIスポーン)
*/

// ==========================================
// 6. オブジェクト構築関数 (HQ & FOB)
// ==========================================

// HQ（指揮所）の構築
MISSION_fnc_BuildHQ = {
    params ["_centerPos"];
    ["HQ構築を開始します...", format ["座標: %1", _centerPos]] call MISSION_fnc_Log;
    
    // 拠点の中心から半径50m以内で、平坦で空いている場所を探す
    private _hqPos = [_centerPos, 0, 50, 10, 0, 0.2, 0] call BIS_fnc_findSafePos;
    
    // 平坦な場所が見つからなかった場合のフォールバック（中心にそのまま置く）
    if (count _hqPos == 2) then { _hqPos pushBack 0; };
    if (_hqPos isEqualTo [0,0,0]) then { _hqPos = _centerPos; };

    // メイン建物の生成（コンフィグからランダム選択）
    private _bldgClass = selectRandom MISSION_cfg_Obj_HQ_Bldg;
    private _hqBldg = createVehicle [_bldgClass, _hqPos, [], 0, "NONE"];
    _hqBldg setDir (random 360);
    
    // 通信アンテナの配置（建物の近くに配置）
    private _antennaPos = _hqBldg getRelPos [10, 45]; // 建物の右斜め前10m
    private _antenna = createVehicle [MISSION_cfg_Obj_Antenna, _antennaPos, [], 0, "NONE"];
    
    // 机とPCの配置（建物の近く。※本来は建物の中に入れたいですが、動的生成の建物内に確実に入れるのは複雑なので一旦外にテントっぽく配置します）
    private _tablePos = _hqBldg getRelPos [5, 180];
    private _table = createVehicle [MISSION_cfg_Obj_Table, _tablePos, [], 0, "NONE"];
    private _laptop = createVehicle [MISSION_cfg_Obj_Laptop, _tablePos, [], 0, "CAN_COLLIDE"];
    _laptop setPosASL (getPosASL _table vectorAdd [0, 0, 0.8]); // 机の上にのせる

    ["HQのオブジェクト構築完了。"] call MISSION_fnc_Log;
    
    // 戻り値としてHQの正確な位置を返す（後でHQ分隊を配置するため）
    _hqPos
};

// FOB（敵キャンプ/増援の出どころ）の構築
MISSION_fnc_BuildFOB = {
    params ["_playerPos", "_targetPos"];
    ["FOB（敵前進基地）の構築を開始します..."] call MISSION_fnc_Log;
    
    // プレイヤーから1km以上離れていて、ターゲット拠点からも離れた場所を探す
    // ここでは簡易的に、ターゲット拠点からさらに1.5km〜2.5km離れたランダムな場所とします
    private _fobPos = [_targetPos, 1500, 2500, 10, 0, 0.3, 0] call BIS_fnc_findSafePos;
    
    if (count _fobPos == 2) then { _fobPos pushBack 0; };
    
    // FOBオブジェクトの生成
    private _tent = createVehicle [MISSION_cfg_Obj_FOB_Tent, _fobPos, [], 0, "NONE"];
    private _firePos = _tent getRelPos [5, 0];
    createVehicle [MISSION_cfg_Obj_FOB_Fire, _firePos, [], 0, "NONE"];
    private _ammoPos = _tent getRelPos [4, 90];
    createVehicle [MISSION_cfg_Obj_FOB_Ammo, _ammoPos, [], 0, "NONE"];
    
    [format ["FOB構築完了。座標: %1", _fobPos]] call MISSION_fnc_Log;
    
    _fobPos
};


// ==========================================
// 7. AIマニュアル生成関数（乗降バグ対策版）
// ==========================================

// 指定された構成で分隊と車両を生成し、リンクさせる汎用関数
MISSION_fnc_SpawnMechanizedSquad = {
    params ["_spawnPos", "_infantryClasses", "_vehicleClass", "_side", "_type"];
    // _type はログや後々の挙動指定用 ("HQ", "MAIN", "SENTRY")
    
    [format ["%1 分隊の生成を開始... 車両: %2", _type, _vehicleClass]] call MISSION_fnc_Log;

    // 1. グループの作成
    private _grp = createGroup _side;
    
    // 2. 車両の生成（少しずらして生成）
    private _vehPos = _spawnPos findEmptyPosition [0, 50, _vehicleClass];
    if (_vehPos isEqualTo []) then { _vehPos = _spawnPos; };
    private _vehicle = createVehicle [_vehicleClass, _vehPos, [], 0, "NONE"];
    
    // 3. 歩兵の生成
    {
        private _unit = _grp createUnit [_x, _spawnPos, [], 5, "FORM"];
        // 必要に応じてスキルなどをここで設定可能
    } forEach _infantryClasses;
    
    // 4. 乗車処理（マニュアルで割り当て）
    // グループのリーダーを車長/運転手に、その他をカーゴに乗せるなどの指示を出す
    // ※今回は「拠点でリラックス」か「哨戒」かで乗車状態を変えるため、一旦車両を変数としてグループに持たせておきます。
    _grp setVariable ["MISSION_AssignedVehicle", _vehicle];
    
    // 運転手だけは最初から乗せておく（移動をスムーズにするため）
    private _driver = leader _grp; // 簡易的にリーダーを運転手に
    if (count units _grp > 1) then {
        _driver = (units _grp) select ((count units _grp) - 1); // 一番下っ端を運転手に
    };
    _driver moveInDriver _vehicle;

    [format ["%1 分隊の生成完了。人数: %2", _type, count units _grp]] call MISSION_fnc_Log;
    
    _grp
};
/*
    動的拠点奪還ミッション生成スクリプト (Step 3: AIの戦術挙動とタスク)
*/

// ==========================================
// 9. 戦術的に重要な地点（高地など）を探す関数
// ==========================================
MISSION_fnc_FindTacticalPositions = {
    params ["_center", "_radius", "_count"];
    // selectBestPlaces を使い、見晴らしの良い高地(hills)や森林(trees)を優先して抽出
    private _places = selectBestPlaces [_center, _radius, "hills + trees", 50, _count];
    private _tacticalPosList = [];
    {
        _tacticalPosList pushBack (_x select 0); // 座標だけを抽出
    } forEach _places;
    
    _tacticalPosList
};

// ==========================================
// 10. AIタスク割り当て関数群
// ==========================================

// --- A. HQ分隊の挙動（指揮所に立てこもる） ---
MISSION_fnc_TaskHQ = {
    params ["_group", "_hqBldgPos"];
    ["HQ分隊に防衛タスクを割り当てます。"] call MISSION_fnc_Log;
    
    _group setBehaviour "AWARE";
    _group setCombatMode "YELLOW"; // 自由に発砲許可
    
    // 指揮所の近くにホールド（移動しない）
    private _wp = _group addWaypoint [_hqBldgPos, 0];
    _wp setWaypointType "HOLD";
    
    // 各ユニットをしゃがみ/伏せ状態にさせ、持ち場を守らせる
    {
        _x setUnitPos "MIDDLE"; // 中腰
        doStop _x;
    } forEach units _group;
};

// --- B. 本隊の挙動（リラックス状態 ＆ 防衛/迎撃） ---
MISSION_fnc_TaskMain = {
    params ["_group", "_targetPos", "_isDefender"];
    ["本隊にタスクを割り当てます。", format ["防衛部隊か: %1", _isDefender]] call MISSION_fnc_Log;
    
    // 初期状態はリラックス
    _group setBehaviour "SAFE";
    _group setSpeedMode "LIMITED";
    
    if (_isDefender) then {
        // --- 拠点防衛組（1分隊想定） ---
        // 拠点の周辺を狭い範囲でウロウロさせる
        for "_i" from 1 to 4 do {
            private _wpPos = [_targetPos, 10, 50, 2, 0, 0.2, 0] call BIS_fnc_findSafePos;
            private _wp = _group addWaypoint [_wpPos, 0];
            _wp setWaypointType "MOVE";
            _wp setWaypointTimeout [10, 30, 60]; // 立ち止まりながらパトロール
        };
        private _wpLoop = _group addWaypoint [getPos (leader _group), 0];
        _wpLoop setWaypointType "CYCLE";
    } else {
        // --- 迎撃組（2分隊想定） ---
        // 拠点内で待機。交戦フラグが立ったらAPCに乗って向かうロジックを待機
        private _wp = _group addWaypoint [_targetPos, 30];
        _wp setWaypointType "DISMISS"; // リラックスしてその辺をたむろする
        
        // 監視スクリプトを走らせる
        [_group, _targetPos] spawn {
            params ["_grp", "_homePos"];
            private _vehicle = _grp getVariable ["MISSION_AssignedVehicle", objNull];
            
            waitUntil {
                sleep 5;
                // グローバル変数 MISSION_Global_CombatFlag が true になるのを待つ
                missionNamespace getVariable ["MISSION_Global_CombatFlag", false] || {behaviour leader _grp == "COMBAT"}
            };
            
            ["本隊迎撃組、交戦状態を確認！迎撃行動に移行！"] call MISSION_fnc_Log;
            
            _grp setBehaviour "AWARE";
            _grp setSpeedMode "NORMAL";
            
            // 全員APCに乗車させる
            if (!isNull _vehicle && canMove _vehicle) then {
                { _x assignAsCargo _vehicle; [_x] orderGetIn true; } forEach units _grp;
            };
            
            // 敵が発見された座標（ MISSION_Global_KnownEnemyPos ）へ向かう
            waitUntil { sleep 3; {vehicle _x == _x} count units _grp == 0 }; // 全員乗るまで少し待つ
            
            private _enemyPos = missionNamespace getVariable ["MISSION_Global_KnownEnemyPos", _homePos];
            private _wpAttack = _grp addWaypoint [_enemyPos, 50];
            _wpAttack setWaypointType "SAD"; // 索敵殲滅
        };
    };
};

// --- C. 歩哨の挙動（遅滞戦闘・報告） ---
MISSION_fnc_TaskSentry = {
    params ["_group", "_patrolCenter"];
    ["歩哨分隊に哨戒・遅滞戦闘タスクを割り当てます。"] call MISSION_fnc_Log;
    
    _group setBehaviour "SAFE";
    _group setSpeedMode "LIMITED";
    // 敵を見つけても勝手に深追いしないように設定
    _group setCombatMode "GREEN"; // 自衛発砲のみ（本隊が来るまで耐えるため）
    
    // 哨戒ルートの設定
    for "_i" from 1 to 3 do {
        private _wpPos = [_patrolCenter, 100, 300, 5, 0, 0.2, 0] call BIS_fnc_findSafePos;
        private _wp = _group addWaypoint [_wpPos, 0];
        _wp setWaypointType "MOVE";
        _wp setWaypointTimeout [20, 45, 90];
    };
    private _wpLoop = _group addWaypoint [_patrolCenter, 0];
    _wpLoop setWaypointType "CYCLE";
    
    // 監視スクリプト：プレイヤー発見時の報告と遅滞戦闘への移行
    [_group] spawn {
        params ["_grp"];
        private _leader = leader _grp;
        
        // 敵（西側陣営など）を認識するまで待機
        waitUntil {
            sleep 2;
            private _target = _leader findNearestEnemy _leader;
            (!isNull _target && {(_leader knowsAbout _target) > 1.5})
        };
        
        // --- 敵発見・遅滞戦闘フェーズ ---
        private _enemy = _leader findNearestEnemy _leader;
        private _enemyPos = getPos _enemy;
        
        [format ["歩哨が敵を発見！座標: %1。本隊へ報告！", mapGridPosition _enemyPos]] call MISSION_fnc_Log;
        
        // グローバル変数で本隊に敵の位置を知らせる
        missionNamespace setVariable ["MISSION_Global_CombatFlag", true, true];
        missionNamespace setVariable ["MISSION_Global_KnownEnemyPos", _enemyPos, true];
        
        // 現在のウェイポイントを全て削除して前進を止める（停滞させる）
        while {(count (waypoints _grp)) > 0} do { deleteWaypoint ((waypoints _grp) select 0); };
        
        // 防衛線を張る（しゃがむ、伏せる）
        {
            doStop _x;
            _x setUnitPos (selectRandom ["MIDDLE", "DOWN"]);
        } forEach units _grp;
        
        // 本隊の到着を待つためにしばらく耐える（CombatMode GREENを維持）
        sleep 60; 
        
        // 1分後、本格的に交戦開始（発砲許可・前線維持）
        ["歩哨、自由交戦を開始！"] call MISSION_fnc_Log;
        _grp setCombatMode "YELLOW";
        _grp setBehaviour "COMBAT";
    };
};

/*
    動的拠点奪還ミッション生成スクリプト (Step 4: APC降車戦術とタスク・ACEメニュー)
*/

// ==========================================
// 12. 本隊の迎撃挙動のアップデート（APC降車と援護）
// ==========================================
// 前回の MISSION_fnc_TaskMain 内の「監視スクリプト」を以下のように書き換えます。

MISSION_fnc_TaskMain_QRF = {
    params ["_grp", "_homePos"];
    private _vehicle = _grp getVariable ["MISSION_AssignedVehicle", objNull];
    
    // 交戦フラグを待つ
    waitUntil {
        sleep 5;
        missionNamespace getVariable ["MISSION_Global_CombatFlag", false] || {behaviour leader _grp == "COMBAT"}
    };
    
    ["本隊迎撃組、交戦状態を確認！APCに搭乗し出撃します！"] call MISSION_fnc_Log;
    _grp setBehaviour "AWARE";
    
    // 全員APCに乗車
    if (!isNull _vehicle && canMove _vehicle) then {
        { _x assignAsCargo _vehicle; [_x] orderGetIn true; } forEach units _grp;
    };
    waitUntil { sleep 3; {vehicle _x == _x} count units _grp == 0 }; // 乗車完了待ち
    
    private _enemyPos = missionNamespace getVariable ["MISSION_Global_KnownEnemyPos", _homePos];
    
    // 一旦、敵の方向へ向かわせる（SADではなくMOVEで向かう）
    private _wpApproach = _grp addWaypoint [_enemyPos, 0];
    _wpApproach setWaypointType "MOVE";
    _wpApproach setWaypointSpeed "NORMAL";

    // --- 【追加】目標手前での降車とAPCの援護ロジック ---
    [_grp, _vehicle, _enemyPos] spawn {
        params ["_grp", "_veh", "_targetPos"];
        
        // 敵から400m以内に入るか、車両が動けなくなるまで待機
        waitUntil {
            sleep 2;
            (!isNull _veh && {(_veh distance _targetPos) < 400}) || !canMove _veh
        };
        
        ["APCが交戦距離に到達。歩兵を展開させ、APCは援護に回ります！"] call MISSION_fnc_Log;
        
        // 歩兵を下車させる
        {
            if (group _x == _grp && _x != driver _veh && _x != gunner _veh) then {
                unassignVehicle _x;
                doGetOut _x;
            };
        } forEach units _grp;
        
        // 歩兵（降車組）の突撃ウェイポイント
        private _wpInfAttack = _grp addWaypoint [_targetPos, 50];
        _wpInfAttack setWaypointType "SAD";
        _grp setBehaviour "COMBAT";
        
        // APC（運転手・砲手）の挙動：その場で停止して援護射撃
        if (alive driver _veh) then {
            private _vehGrp = group driver _veh;
            // 現在のウェイポイントを消去
            while {(count (waypoints _vehGrp)) > 0} do { deleteWaypoint ((waypoints _vehGrp) select 0); };
            
            // 少しだけ後退するか、その場で待機して射撃
            doStop (driver _veh);
            _vehGrp setCombatMode "YELLOW"; // 自由射撃
            _vehGrp setBehaviour "COMBAT";
        };
    };
};

// ==========================================
// 13. タスク（目標）の作成とクリア判定
// ==========================================
MISSION_fnc_CreateAndMonitorTask = {
    params ["_targetPos"];
    
    // ユニークなタスクIDを生成
    private _taskID = format ["MISSION_Capture_%1", round(random 100000)];
    
    // Arma 3の標準タスクシステムで画面に目標を表示
    [
        true, 
        _taskID, 
        ["指定された軍事施設に展開している敵部隊を排除し、拠点を奪還せよ。", "拠点奪還", ""], 
        _targetPos, 
        "ASSIGNED", 
        1, 
        true, 
        "attack"
    ] call BIS_fnc_taskCreate;
    
    // クリア判定監視スクリプト
    [_targetPos, _taskID] spawn {
        params ["_pos", "_taskID"];
        
        waitUntil {
            sleep 5;
            // 拠点の半径150m以内にいる、生きた敵（東側）の数をカウント
            private _enemyCount = { side _x == east && _x distance _pos < 150 && alive _x } count allUnits;
            
            // 敵が3人未満になったら（HQや本隊がほぼ壊滅したら）クリアとみなす
            _enemyCount < 3
        };
        
        // タスクを「成功」に変更
        [_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
        ["奪還任務完了！拠点の制圧を確認しました。"] call MISSION_fnc_Log;
        
        // ※必要に応じて、ここにミッション完了時の報酬や次のミッションへの移行処理を書けます
    };
};

// ==========================================
// 14. ACEメニューの階層化（親カテゴリの追加）
// ==========================================
// 前回のACEメニュー登録部分を以下のように書き換えます。

if (isClass(configFile >> "CfgPatches" >> "ace_interact_menu")) then {
    
    // 1. 親カテゴリ「ダイナミックミッション」の作成
    // すでに同じ名前(ActionID)が存在する場合は上書き/統合されるため、エラーにはなりません。
    private _parentAction = [
        "Dynamic_Mission_Root", // Action ID
        "ダイナミックミッション", // メニューに表示される名前
        "", // アイコン（空白でOK）
        {}, 
        { true }
    ] call ace_interact_menu_fnc_createAction;
    
    // プレイヤーのSelfActionsに親カテゴリを追加
    [player, 1, ["ACE_SelfActions"], _parentAction] call ace_interact_menu_fnc_addActionToObject;

    // 2. 子アクション「奪還ミッション生成」の作成
    private _childAction = [
        "Generate_Capture_Mission", 
        "軍事施設 奪還ミッション生成", 
        "", 
        { [] spawn MISSION_fnc_StartMission; }, 
        { true }
    ] call ace_interact_menu_fnc_createAction;
    
    // 親カテゴリ(Dynamic_Mission_Root)の中に子アクションを追加
    [player, 1, ["ACE_SelfActions", "Dynamic_Mission_Root"], _childAction] call ace_interact_menu_fnc_addActionToObject;
    
    ["ACEメニューにダイナミックミッション項目を登録しました。"] call MISSION_fnc_Log;
};