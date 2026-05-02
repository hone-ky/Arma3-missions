if (!isServer) exitWith {};
params ["_caller"];

if (ChDKZ_CheckPoint_IsRunning) exitWith { ["すでに作戦が稼働中です"] remoteExec ["hint", remoteExecutedOwner]; };
ChDKZ_CheckPoint_IsRunning = true;
publicVariable "ChDKZ_CheckPoint_IsRunning";

diag_log format ["[ChDKZ_CP] ----- Mission Generation Started -----"];

private _centerPos = getPos _caller;
private _searchPos = [_centerPos, 1500, 4000, 5, 0, 0.5, 0] call BIS_fnc_findSafePos;
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

// ★修正: RHS専用マーカーを廃止し、Vanillaの「o_installation（敵基地）」を使用
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