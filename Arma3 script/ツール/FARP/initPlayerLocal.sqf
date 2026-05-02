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