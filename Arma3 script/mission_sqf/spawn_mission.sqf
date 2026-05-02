if (!isServer) exitWith {};

private _triggerPos = getPosATL player;
private _searchRadius = 15000; 
private _enemySide = east;

private _uniqueID = str(floor(time) + floor(random 1000));
private _markerName = format ["ChDKZ_Obj_%1", _uniqueID];
private _taskID = format ["Task_%1", _uniqueID];

private _locationTypes = ["NameCityCapital", "NameCity", "NameVillage"];
private _targetLocation = nearestLocation [_triggerPos, selectRandom _locationTypes];
private _spawnPos = locationPosition _targetLocation;
_spawnPos set [2, 0];

private _anchor = createVehicle ["Land_WaterBottle_01_cap_F", _spawnPos, [], 100, "NONE"];
private _finalPos = getPosATL _anchor;

private _groupCount = floor(random 6) + 5;
for "_i" from 1 to _groupCount do {
    private _group = [_finalPos, _enemySide, (configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhsgref_group_chdkz_insurgents_infantry" >> "rhsgref_group_chdkz_insurgents_squad")] call BIS_fnc_spawnGroup;
    
    for "_j" from 1 to 4 do {
        private _wp = _group addWaypoint [_finalPos, 150];
        _wp setWaypointType "MOVE";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    private _cycle = _group addWaypoint [_finalPos, 0];
    _cycle setWaypointType "CYCLE";
};

private _marker = createMarker [_markerName, _finalPos];
_marker setMarkerType "hd_objective";
_marker setMarkerColor "ColorEast";
_marker setMarkerText (text _targetLocation + " 掃討作戦");

[west, [_taskID], ["指定地域の敵を掃討してください。", "拠点掃討", ""], _finalPos, "CREATED", 1, true, "kill", true] call BIS_fnc_taskCreate;
systemChat format ["ミッション生成: %1 に敵部隊を確認。", text _targetLocation];

private _trg = createTrigger ["EmptyDetector", _finalPos, false];
_trg setTriggerArea [400, 400, 0, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];

_trg setTriggerStatements [
    "this", 
    format ["
        deleteMarker '%1'; 
        ['%2', 'SUCCEEDED'] call BIS_fnc_taskSetState;
        systemChat '作戦完了: 指定地域の敵を全滅させました。';
    ", _markerName, _taskID], 
    ""
];

deleteVehicle _anchor;