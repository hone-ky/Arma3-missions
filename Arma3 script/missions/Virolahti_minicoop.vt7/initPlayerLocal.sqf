// プレイヤー初期化待ち
waitUntil {!isNull player && player == player};

// initPlayerLocal.sqf の中身
// setupMission.sqf をコンパイルして実行する
[] execVM "setupMission.sqf";

/* initPlayerLocal.sqf */

// --- A. 設営アクション (歩兵用) ---
private _actionSetup = ["Request_FARP", "FARP設営を要請", "", {
    [] execVM "scripts\fn_setupFARP.sqf"; 
}, {true}] call ace_interact_menu_fnc_createAction;

[player, 1, ["ACE_SelfActions", "ACE_Equipment"], _actionSetup] call ace_interact_menu_fnc_addActionToObject;


// --- B. 補給アクション (ヘリ搭乗時) ---

Check_FARP_Condition = {
    params ["_target", "_player"];
    
    // 1. 接地チェック
    if !(isTouchingGround _target) exitWith {false};
    
    // 2. エンジンチェック (テスト用: コメントアウト推奨)
    // if (isEngineOn _target) exitWith {false};
    
    // 3. 近く(100m以内)にRHSの弾薬車があるか？
    // 半径を50m -> 100m に拡大
    private _nearAmmo = nearestObjects [_target, ["rhsusf_M977A4_AMMO_BKIT_usarmy_wd"], 100];
    
    (count _nearAmmo > 0)
};

private _actionService = ["FARP_Service", "<t color='#00FF00'>[FARP] 補給・換装メニュー</t>", "\A3\ui_f\data\igui\cfg\simpletasks\types\rearm_ca.paa", {
    params ["_target", "_caller"];

    // ACEのパイルン画面を開く
    [_target] call ace_pylons_fnc_showDialog;
    hint "整備班: 補給作業を開始します。";

}, {call Check_FARP_Condition}] call ace_interact_menu_fnc_createAction;

// ★重要: 両方に登録して確実に出す
// 1. 自己インタラクション (Ctrl + Win)
["Air", 1, ["ACE_SelfActions"], _actionService] call ace_interact_menu_fnc_addActionToClass;

// 2. メインインタラクション (Win)
["Air", 0, ["ACE_MainActions"], _actionService] call ace_interact_menu_fnc_addActionToClass;

// --- 初期設定 ---
if (isNil "HONE_Tac_Transport") then { HONE_Tac_Transport = "GROUND"; };
if (isNil "HONE_Tac_UseArmor") then { HONE_Tac_UseArmor = false; };
if (isNil "HONE_Tac_UseCAS") then { HONE_Tac_UseCAS = false; };
if (isNil "HONE_Tac_Objective") then { HONE_Tac_Objective = "CLEAR"; };

// --- 設定表示更新関数 (ヒント & マップマーカー) ---
hone_fnc_updateStatus = {
    private _transStr = if (HONE_Tac_Transport == "GROUND") then { "地上車両" } else { "ヘリコプター" };
    private _armorStr = if (HONE_Tac_UseArmor) then { "ON" } else { "OFF" };
    private _casStr = if (HONE_Tac_UseCAS) then { "ON" } else { "OFF" };
    private _objStr = if (HONE_Tac_Objective == "CLEAR") then { "制圧" } else { "破壊" };

    private _statusText = format ["現在の設定 | 輸送: %1 | 機甲: %2 | CAS: %3 | 目標: %4", _transStr, _armorStr, _casStr, _objStr];

    // 1. ヒントで通知
    hint _statusText;

    // 2. マップ左下にマーカーで表示 (初回変更時に作成)
    private _mkrName = "hone_tac_status_board";
    if (getMarkerColor _mkrName == "") then {
        createMarkerLocal [_mkrName, [100, 100]];
        _mkrName setMarkerTypeLocal "mil_flag";
        _mkrName setMarkerColorLocal "ColorBlue";
    };
    _mkrName setMarkerTextLocal _statusText;
};

// ★修正点: 初回表示 (call hone_fnc_updateStatus) を削除しました。


// --- 共通関数: 戦術プラン描画 (変更なし) ---
hone_fnc_drawTacticalPlan = {
    params ["_id", "_routeIn", "_routeOut", "_reconPos", "_basePos", "_dismountPos", "_pickupPos", "_exfilPos", "_method"];
    
    // 既存削除
    private _markers = [
        format["m_s_%1",_id], format["m_t_%1",_id], format["m_e_%1",_id], 
        format["m_r_%1",_id], format["m_b_%1",_id], format["m_p_%1",_id], format["m_d_%1",_id]
    ];
    { deleteMarkerLocal _x; } forEach _markers;
    for "_i" from 0 to 30 do { deleteMarkerLocal format["m_a_%1_%2", _id, _i]; };
    for "_i" from 0 to 30 do { deleteMarkerLocal format["m_w_%1_%2", _id, _i]; };

    // マーカー作成
    private _mb = createMarkerLocal [format["m_b_%1",_id], _basePos];
    _mb setMarkerTypeLocal "b_hq";
    _mb setMarkerColorLocal "ColorBlue";
    _mb setMarkerTextLocal "CP/BASE";

    if (!isNil "_dismountPos" && {count _dismountPos > 0}) then {
        private _md = createMarkerLocal [format["m_d_%1",_id], _dismountPos];
        _md setMarkerTypeLocal "hd_join";
        _md setMarkerColorLocal "ColorGreen";
        _md setMarkerTextLocal format["【降車/LZ】(%1)", _method];
    };

    private _targetPos = _routeIn select (count _routeIn - 1);
    private _mt = createMarkerLocal [format["m_t_%1",_id], _targetPos];
    _mt setMarkerTypeLocal "hd_objective";
    _mt setMarkerColorLocal "ColorRed";
    _mt setMarkerTextLocal "【目標】";

    if (!isNil "_pickupPos" && {count _pickupPos > 0}) then {
        private _mp = createMarkerLocal [format["m_p_%1",_id], _pickupPos];
        _mp setMarkerTypeLocal "hd_pickup";
        _mp setMarkerColorLocal "ColorGreen";
        _mp setMarkerTextLocal "【回収/RV】";
    };

    if (!isNil "_reconPos" && {count _reconPos > 0}) then {
        private _mr = createMarkerLocal [format["m_r_%1",_id], _reconPos];
        _mr setMarkerTypeLocal "mil_triangle";
        _mr setMarkerColorLocal "ColorOrange";
        _mr setMarkerTextLocal "偵察候補";
    };
    
    private _drawArrow = {
        params ["_points", "_color", "_prefix"];
        for "_i" from 0 to (count _points - 2) do {
            private _p1 = _points select _i;
            private _p2 = _points select (_i + 1);
            private _dir = _p1 getDir _p2;
            private _dist = _p1 distance _p2;
            private _mid = _p1 vectorAdd ((_p2 vectorDiff _p1) vectorMultiply 0.5);

            private _arr = createMarkerLocal [format["%1_a_%2_%3", _prefix, _id, _i], _mid];
            _arr setMarkerShapeLocal "RECTANGLE";
            _arr setMarkerBrushLocal "Vertical";
            _arr setMarkerColorLocal _color;
            _arr setMarkerDirLocal _dir;
            _arr setMarkerSizeLocal [10, _dist / 2];
            
            if (_i > 0) then {
                private _wp = createMarkerLocal [format["%1_w_%2_%3", _prefix, _id, _i], _p1];
                _wp setMarkerTypeLocal "mil_dot";
                _wp setMarkerColorLocal "ColorBlack";
                _wp setMarkerTextLocal format["WP%1", _i];
                _wp setMarkerSizeLocal [0.5, 0.5];
            };
        };
    };

    [_routeIn, "ColorRed", "m"] call _drawArrow;
    [_routeOut, "ColorGreen", "m_out"] call _drawArrow;
};

// 共通関数: 削除
hone_fnc_clearTacticalPlan = {
    params ["_id"];
    private _markers = allMapMarkers select { 
        ([format["_%1", _id], _x] call BIS_fnc_inString) && 
        (["m_", _x] call BIS_fnc_inString) 
    };
    { deleteMarkerLocal _x; } forEach _markers;
};


// --- ACEメニュー登録 ---
private _baseAction = ["TacticalSupport", "AI参謀: 作戦立案", "", {true}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _baseAction] call ace_interact_menu_fnc_addActionToObject;

// 1. 設定メニュー親
private _configAction = ["TacConfig", "作戦設定...", "", {true}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "TacticalSupport"], _configAction] call ace_interact_menu_fnc_addActionToObject;

// 設定: 輸送手段
private _actTrans = ["SetTrans", "輸送: 切替 (ヘリ/車両)", "", {
    if (HONE_Tac_Transport == "GROUND") then { HONE_Tac_Transport = "HELI"; } else { HONE_Tac_Transport = "GROUND"; };
    call hone_fnc_updateStatus; 
}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "TacticalSupport", "TacConfig"], _actTrans] call ace_interact_menu_fnc_addActionToObject;

// 設定: 機甲戦力
private _actArmor = ["SetArmor", "支援: 機甲戦力 (ON/OFF)", "", {
    HONE_Tac_UseArmor = !HONE_Tac_UseArmor;
    call hone_fnc_updateStatus;
}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "TacticalSupport", "TacConfig"], _actArmor] call ace_interact_menu_fnc_addActionToObject;

// 設定: CAS
private _actCAS = ["SetCAS", "支援: CAS (ON/OFF)", "", {
    HONE_Tac_UseCAS = !HONE_Tac_UseCAS;
    call hone_fnc_updateStatus;
}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "TacticalSupport", "TacConfig"], _actCAS] call ace_interact_menu_fnc_addActionToObject;

// 設定: 目標
private _actObj = ["SetObj", "目標: 切替 (制圧/破壊)", "", {
    if (HONE_Tac_Objective == "CLEAR") then { HONE_Tac_Objective = "DESTROY"; } else { HONE_Tac_Objective = "CLEAR"; };
    call hone_fnc_updateStatus;
}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "TacticalSupport", "TacConfig"], _actObj] call ace_interact_menu_fnc_addActionToObject;


// 2. 作戦生成実行
private _genAction = ["GeneratePlan", ">> 作戦案を生成 (マップクリック)", "", {
    call hone_fnc_updateStatus; 
    [] execVM "scripts\generate_plan.sqf";
}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "TacticalSupport"], _genAction] call ace_interact_menu_fnc_addActionToObject;

// 3. キャンセル
private _cancelAction = ["CancelPlan", "全マーカー消去", "", {
    {
        if (["m_", _x] call BIS_fnc_inString || ["tac_", _x] call BIS_fnc_inString) then {
            deleteMarker _x;
            [_x] remoteExec ["deleteMarkerLocal", 0];
        };
    } forEach allMapMarkers;
    hint "参謀：すべての作戦表示を破棄しました。";
}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "TacticalSupport"], _cancelAction] call ace_interact_menu_fnc_addActionToObject;

// ========================================================
// 1. ダイナミックミッション メニュー定義
// ========================================================

// --- 親メニュー ---
private _dynamicMenuAction = [
    "dynamic_mission_root",
    "ダイナミックミッション",
    "\a3\ui_f\data\igui\cfg\simpleTasks\types\map_ca.paa",
    {},
    {true}
] call ace_interact_menu_fnc_createAction;

// 中間メニュー
private _easyMenuAction = [
    "easy_mission_root",
    "Eazy",
    "\a3\ui_f\data\igui\cfg\simpletasks\letters\e_ca.paa",
    {},
    {true}
] call ace_interact_menu_fnc_createAction;

private _nomalMenuAction = [
    "nomal_mission_root",
    "nomal",
    "\a3\ui_f\data\igui\cfg\simpletasks\types\rifle_ca.paa",
    {},
    {true}
] call ace_interact_menu_fnc_createAction;

private _hardMenuAction = [
    "hard_mission_root",
    "hard",
    "\a3\Ui_F_Curator\Data\CfgMarkers\kia_ca.paa",
    {},
    {true}
] call ace_interact_menu_fnc_createAction;

// --- 子メニュー定義 ---

// 1. Gang Weed (基地攻撃)
private _spawnBaseAction = [
    "spawn_enemy_base",
    "Gang Weed",
    "\a3\ui_f\data\igui\cfg\simpleTasks\types\attack_ca.paa",
    { [ [player, player], "spawn_base_v3.sqf" ] remoteExec ["execVM", 2]; },
    { true }
] call ace_interact_menu_fnc_createAction;

// 2. Wave防衛
private _spawnWaveAction = [
    "spawn_wave_mission",
    "ChDKZ Town Inf wave",
    "\a3\ui_f\data\igui\cfg\simpleTasks\types\defend_ca.paa",
    { [ [player, player], "spawn_dynamic_mission.sqf" ] remoteExec ["execVM", 2]; },
    { true }
] call ace_interact_menu_fnc_createAction;

// 4. RHS Hard (発展版)
private _spawnHardTownAction = [
    "spawn_town_hard_v2",
    "ChDKZ Town RHS Hard (発展版)",
    "\a3\ui_f\data\igui\cfg\simpleTasks\types\destroy_ca.paa",
    { [ [player, player], "spawn_town_rhs_hard_v2.sqf" ] remoteExec ["execVM", 2]; },
    { true }
] call ace_interact_menu_fnc_createAction;

// 5. RHS Insane (今回作成した凶悪版)
private _spawnInsaneTownAction = [
    "spawn_town_rhs_insane",
    "ChDKZ Town RHS Insane",
    "\a3\ui_f\data\igui\cfg\simpleTasks\types\danger_ca.paa", // 危険アイコン
    { [ [player, player], "ChDKZ_Town_RHS_insane.sqf" ] remoteExec ["execVM", 2]; },
    { true }
] call ace_interact_menu_fnc_createAction;

// 6. ChDKZ Checkpoint (生成)
private _spawnCPAction = [
    "spawn_chdkz_cp",
    "ChDKZ Checkpoint",
    "\a3\ui_f\data\igui\cfg\simpleTasks\types\target_ca.paa",
    { [ [player, player], "scripts\ChDKZ_CheckPoint\fn_main.sqf" ] remoteExec ["execVM", 2]; },
    { true }
] call ace_interact_menu_fnc_createAction;

// 7. ChDKZ Checkpoint (中断・消去)
private _cleanupCPAction = [
    "cleanup_chdkz_cp",
    "ChDKZ Checkpoint 中断・消去",
    "\a3\ui_f\data\igui\cfg\simpleTasks\types\exit_ca.paa",
    { [ [player, player], "scripts\ChDKZ_CheckPoint\fn_cleanup.sqf" ] remoteExec ["execVM", 2]; },
    { true }
] call ace_interact_menu_fnc_createAction;

// --- メニューの登録処理 ---

// 1. まず大元である「ダイナミックミッション」メニューをプレイヤーのアクションに登録
[player, 1, ["ACE_SelfActions"], _dynamicMenuAction] call ace_interact_menu_fnc_addActionToObject;

// 2. その直下に、分類用の子メニュー（Easy, Normal）を登録
{
    [player, 1, ["ACE_SelfActions", "dynamic_mission_root"], _x] call ace_interact_menu_fnc_addActionToObject;
} forEach [
    _easyMenuAction,
    _nomalMenuAction,
    _hardMenuAction
];

// 3. 各子メニューの中に、実際のミッションアクションを登録していく
// 【重要】パスは必ず "ACE_SelfActions" から順番に全て記述します。

// --- Easy メニューの中身 ---
{
    [player, 1, ["ACE_SelfActions", "dynamic_mission_root", "easy_mission_root"], _x] call ace_interact_menu_fnc_addActionToObject;
} forEach [
    _spawnBaseAction,
    _spawnWaveAction
];

// --- Normal メニューの中身 ---
{
    [player, 1, ["ACE_SelfActions", "dynamic_mission_root", "nomal_mission_root"], _x] call ace_interact_menu_fnc_addActionToObject;
} forEach [
    _spawnHardTownAction,
    _spawnCPAction,
    _cleanupCPAction
];

// --- Hard メニューの中身 ---
{
    [player, 1, ["ACE_SelfActions", "dynamic_mission_root", "hard_mission_root"], _x] call ace_interact_menu_fnc_addActionToObject;
} forEach [
    _spawnInsaneTownAction
];

// --- 分類に属さないもの（親メニューの直下に置く場合） ---
{
    [player, 1, ["ACE_SelfActions", "dynamic_mission_root"], _x] call ace_interact_menu_fnc_addActionToObject;
} forEach [
    
];

// ========================================================
// 2. Ace Role Changer (by kur0den) - DO NOT TOUCH
// ========================================================

private _mainAction = [
  "kur0denAceRoleChanger",
  "Ace Role Changer",
  "\a3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa",
  {},
  {true}
] call ace_interact_menu_fnc_createAction;

private _medic = [
  "changeMedicRole",
  "Change Medic Role",
  "\a3\ui_f\data\igui\cfg\actions\heal_ca.paa",
  {
    private _currentRank = player getVariable ["ace_medical_medicClass", 0];
    private _newRank = if (_currentRank >= 2) then { 0 } else { _currentRank + 1 };
    private _newRankText = switch (_newRank) do {
      case 0: {"Not a Medic"};
      case 1: {"a Combat Medic"};
      case 2: {"a Doctor"};
    };
    player setVariable ["ace_medical_medicClass", _newRank, true];
    private _msg = format ["%1 is %2", name player, _newRankText];
    ["RoleChanged", ["Role Updated", _msg]] remoteExec ["BIS_fnc_showNotification", 0];
  },
  {true}
] call ace_interact_menu_fnc_createAction;

private _engineer = [
  "changeEngineerRole",
  "Change Engineer Role",
  "\a3\ui_f\data\igui\cfg\actions\repair_ca.paa",  {
    private _currentRank = player getVariable ["ace_repair_engineer", 0];
    private _newRank = if (_currentRank >= 2) then { 0 } else { _currentRank + 1 };
    private _newRankText = switch (_newRank) do {
      case 0: {"Not an Engineer"};
      case 1: {"an Engineer"};
      case 2: {"an Advanced Engineer"};
    };
    player setVariable ["ace_repair_engineer", _newRank, true];
    private _msg = format ["%1 is %2", name player, _newRankText];
    ["RoleChanged", ["Role Updated", _msg]] remoteExec ["BIS_fnc_showNotification", 0];
  },
  {true}
] call ace_interact_menu_fnc_createAction;

[
  player,
  1,
  ["ACE_SelfActions"],
  _mainAction
] call ace_interact_menu_fnc_addActionToObject;

[
  player,
  1,
  ["ACE_SelfActions", "kur0denAceRoleChanger"],
  _medic
] call ace_interact_menu_fnc_addActionToObject;

[
  player,
  1,
  ["ACE_SelfActions", "kur0denAceRoleChanger"],
  _engineer
] call ace_interact_menu_fnc_addActionToObject;

