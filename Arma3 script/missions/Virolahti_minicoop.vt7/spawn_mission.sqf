if (!isServer) exitWith {};

diag_log "LOG: [SERVER] Trigger activated. Spawning mission...";

private _allPlayers = allPlayers select {alive _x};
if (count _allPlayers == 0) exitWith { diag_log "LOG: [SERVER] No players found."; };

private _refPos = getPosATL (selectRandom _allPlayers);

private _locTypes = ["NameCityCapital", "NameCity", "NameVillage"];
private _potentialLocs = nearestLocations [_refPos, _locTypes, 15000]; 

if (count _potentialLocs == 0) exitWith { diag_log "LOG: [SERVER] No suitable locations found."; };

private _targetLoc = selectRandom _potentialLocs;

private _spawnPos = locationPosition _targetLoc;
private _finalPos = [_spawnPos, 0, 300, 5, 0, 20, 0] call BIS_fnc_findSafePos;

private _uniqueID = str(floor(time) + floor(random 1000));
private _taskID = "Task_" + _uniqueID;
private _markerName = "Marker_" + _uniqueID;

private _groupCount = 6 + (round random 4); 
for "_i" from 1 to _groupCount do {
    private _group = [_finalPos, east, (configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhsgref_group_chdkz_insurgents_infantry" >> "rhsgref_group_chdkz_insurgents_squad")] call BIS_fnc_spawnGroup;
    [_group, _finalPos, 250] call BIS_fnc_taskPatrol;
};

private _m = createMarker [_markerName, _finalPos];
_m setMarkerType "hd_objective";
_m setMarkerColor "ColorEast";
_m setMarkerText ("目標: " + (text _targetLoc));

[west, [_taskID], ["敵を掃討せよ", "拠点掃討", ""], _finalPos, "CREATED", 1, false, "kill", false] call BIS_fnc_taskCreate;
["新しい目標が指定されました。マップを確認してください。"] remoteExec ["systemChat", 0];

private _trg = createTrigger ["EmptyDetector", _finalPos, false];
_trg setTriggerArea [400, 400, 0, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements [
    "this", 
    format ["
        deleteMarker '%1'; 
        ['%2', 'SUCCEEDED', false] call BIS_fnc_taskSetState; 
        ['作戦完了。次の指示を待て。'] remoteExec ['systemChat', 0];
        diag_log 'LOG: [SERVER] Mission Complete.';
    ", _markerName, _taskID], 
    ""
];