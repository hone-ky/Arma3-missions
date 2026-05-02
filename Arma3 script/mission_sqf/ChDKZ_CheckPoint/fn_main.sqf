if (!isServer) exitWith {};
params ["_caller"];

if (ChDKZ_CheckPoint_IsRunning) exitWith { ["すでに作戦が稼働中です"] remoteExec ["hint", remoteExecutedOwner]; };
ChDKZ_CheckPoint_IsRunning = true;
publicVariable "ChDKZ_CheckPoint_IsRunning";

diag_log format ["[ChDKZ_CP] ----- Mission Generation Started -----"];

private _centerPos = getPos _caller;
private _searchPos = [];
private _isValidPos = false;
private _attempts = 0;
private _edgeMargin = 1000; // マップ端からの除外距離（1km = 1000m）

// 条件に合う場所を見つけるまで最大20回ループ
while {!_isValidPos && _attempts < 20} do {
    // 1500m ~ 4000m の範囲で安全な場所を検索
    _searchPos = [_centerPos, 1500, 10000, 5, 0, 0.5, 0] call BIS_fnc_findSafePos;

    // 取得した座標のXとYがマップ端から1km以上内側に収まっているか判定
    private _posX = _searchPos select 0;
    private _posY = _searchPos select 1;
    
    if (_posX > _edgeMargin && {_posX < (worldSize - _edgeMargin)} && {_posY > _edgeMargin} && {_posY < (worldSize - _edgeMargin)}) then {
        _isValidPos = true;
    };
    
    _attempts = _attempts + 1;
};

// 規定回数探しても見つからなかった場合は作戦をキャンセルし、フラグを下ろす
if (!_isValidPos) exitWith {
    ["エラー: マップ端から1km以上内側に適切な生成場所が見つかりませんでした。場所を変えて再度お試しください。"] remoteExec ["hint", remoteExecutedOwner];
    ChDKZ_CheckPoint_IsRunning = false;
    publicVariable "ChDKZ_CheckPoint_IsRunning";
    diag_log "[ChDKZ_CP] Mission Generation Canceled: Safe position not found within 1km margin from map edge.";
};

private _nearRoads = _searchPos nearRoads 300;
private _spawnPos = _searchPos;
private _roadDir = random 360; 

if (count _nearRoads > 0) then {
    private _road = _nearRoads select 0;
    _spawnPos = getPos _road;
    _roadDir = getDir _road;
};

// 構造物生成
private _baseData = [_spawnPos, _roadDir] call compile preprocessFileLineNumbers "scripts\ChDKZ_CheckPoint\fn_spawnBase.sqf";
private _spawnedObjs = _baseData select 0;
private _frontDir = _baseData select 1;
ChDKZ_CheckPoint_ActiveObjs append _spawnedObjs;

// AI生成
[_spawnPos, _frontDir] call compile preprocessFileLineNumbers "scripts\ChDKZ_CheckPoint\fn_spawnInfantry.sqf";

// マーカー初期化
if (getMarkerColor "ChDKZ_CP_Main" != "") then { deleteMarker "ChDKZ_CP_Main"; };
if (getMarkerColor "ChDKZ_CP_Front" != "") then { deleteMarker "ChDKZ_CP_Front"; };

// Vanillaの「o_installation（敵基地）」を使用
private _markerCP = createMarker ["ChDKZ_CP_Main", _spawnPos];
_markerCP setMarkerType "o_installation"; 
_markerCP setMarkerColor "ColorEast";
_markerCP setMarkerText "ChDKZ Checkpoint";

private _frontPos = _spawnPos getPos [50, _frontDir];
private _markerFront = createMarker ["ChDKZ_CP_Front", _frontPos];
_markerFront setMarkerType "hd_arrow";
_markerFront setMarkerDir (_frontDir + 180);
_markerFront setMarkerColor "ColorRed";
_markerFront setMarkerText "FRONT";

ChDKZ_CheckPoint_ActiveMarkers = ["ChDKZ_CP_Main", "ChDKZ_CP_Front"];
publicVariable "ChDKZ_CheckPoint_ActiveMarkers";

["チェックポイントを特定"] remoteExec ["hint", 0];