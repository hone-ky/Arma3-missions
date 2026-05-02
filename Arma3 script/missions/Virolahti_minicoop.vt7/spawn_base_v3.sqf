if (!isServer) exitWith {};

// 引数の受け取り（呼び出し側が引数を渡さなくてもエラーにならないよう設定）
params [["_target", objNull], ["_caller", objNull]];

// 基準となるプレイヤー（呼び出し主）の座標を取得
private _originPos = if (!isNull _caller) then {getPosATL _caller} else {[0,0,0]};
if (_originPos isEqualTo [0,0,0]) exitWith {diag_log "Error: No caller position found for spawn script."};

// --- 1. 拠点位置の選定 (最低2km、最大3.5km離れた場所) ---
// getPos [距離, 方角] でプレイヤーから離れた地点を計算
private _spawnCenter = _originPos getPos [2000 + (random 1500), random 360];

// 海の上や急斜面を避け、平地（SafePos）を検索
private _finalPos = [_spawnCenter, 0, 500, 8, 0, 0.4, 0] call BIS_fnc_findSafePos;
_finalPos set [2, 0];

// --- 2. オブジェクト生成 ---
private _baseAnchor = createVehicle ["Land_FoodSacks_01_cargo_brown_F", _finalPos, [], 0, "NONE"];
private _actualPos = getPosATL _baseAnchor;
createVehicle ["O_Cargonet_01_ammo_F", _actualPos, [], 5, "NONE"];

// --- 3. 敵歩兵の生成 (1～3グループ) ---
private _groupCount = floor(random [1, 2, 4]);
for "_g" from 1 to _groupCount do {
    private _grp = [_actualPos, east, (configfile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfTeam_Light")] call BIS_fnc_spawnGroup;
    for "_i" from 1 to 4 do {
        private _wp = _grp addWaypoint [_actualPos, 50 + (random 50)];
        _wp setWaypointType "MOVE";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    (_grp addWaypoint [_actualPos, 0]) setWaypointType "CYCLE";
};

// --- 4. 車両の生成 (0～2台) ---
private _vehCount = floor(random 3);
for "_v" from 1 to _vehCount do {
    private _hilux = createVehicle ["O_G_Offroad_01_armed_F", _actualPos, [], 150, "NONE"];
    createVehicleCrew _hilux;
    private _vGrp = group (driver _hilux);
    for "_i" from 1 to 4 do {
        private _wp = _vGrp addWaypoint [_actualPos, 300];
        _wp setWaypointType "MOVE";
        _wp setWaypointBehaviour "SAFE";
    };
    (_vGrp addWaypoint [getPosATL _hilux, 0]) setWaypointType "CYCLE";
};

// --- 5. マーカーと判定 ---
private _mkrName = format ["mkr_base_%1_%2", round(time), round(random 1000)];
private _mkr = createMarker [_mkrName, _actualPos];
_mkr setMarkerType "hd_objective";
_mkr setMarkerColor "ColorOPFOR";
_mkr setMarkerText (format ["敵キャンプ (%1個小隊)", _groupCount]);

// トリガーの作成
private _trg = createTrigger ["EmptyDetector", _actualPos, false];
_trg setTriggerArea [600, 600, 0, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];

// 【修正箇所】hint を確実に全プレイヤーに表示させるための記法
private _winMsg = "拠点を制圧しました。";
_trg setTriggerStatements [
    "this", 
    format ["deleteMarker '%1'; ['%2'] remoteExec ['hint', 0];", _mkrName, _winMsg], 
    ""
];

// 【修正箇所】開始時のヒント通知
private _startMsg = format ["偵察情報：新たな敵拠点の反応を確認 (%1件)", _groupCount];
[_startMsg] remoteExec ["hint", 0];