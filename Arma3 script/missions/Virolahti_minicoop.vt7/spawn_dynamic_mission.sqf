// サーバー側のみで実行を許可
if (!isServer) exitWith {};

params ["_args"];
_args params [["_target", objNull], ["_caller", objNull]];

private _originPos = if (!isNull _caller) then { getPosATL _caller } else { [worldSize/2, worldSize/2, 0] };

// --- 1. ロケーションの選定 ---
private _locTypes = ["NameCityCapital", "NameCity", "NameVillage", "NameLocal"];
private _allLocs = nearestLocations [[worldSize/2, worldSize/2, 0], _locTypes, worldSize];
private _validLocs = _allLocs select { (_originPos distance (locationPosition _x)) > 2000 };

private _missionCenter = [0,0,0];
private _locName = "作戦区域";

if (count _validLocs > 0) then {
    private _targetLoc = selectRandom _validLocs;
    _missionCenter = locationPosition _targetLoc;
    _locName = text _targetLoc;
} else {
    _missionCenter = _originPos getPos [3000, random 360];
};

// マーカー作成
private _mkrName = format ["mkr_dyn_%1_%2", round(time), round(random 1000)];
private _mkr = createMarker [_mkrName, _missionCenter];
_mkr setMarkerType "hd_objective";
_mkr setMarkerColor "ColorOPFOR";

// --- 2. ランダム数値の設定 ---
// ウェーブ数: 4〜7 の間でランダム
private _totalWaves = floor(random [4, 5.5, 7.9]);

[format ["作戦開始：%1 に敵影を確認。全 %2 ウェーブを殲滅せよ。", _locName, _totalWaves]] remoteExec ["hint", 0];

for "_w" from 1 to _totalWaves do {
    private _isFirstWave = (_w == 1);
    private _spawnPos = if (_isFirstWave) then { _missionCenter } else { _missionCenter getPos [200 + (random 150), random 360] };
    
    // 分隊数: 3〜5 の間でランダム
    private _groupCount = floor(random [3, 4, 5.9]);
    private _allGroups = [];

    for "_g" from 1 to _groupCount do {
        private _grp = [_spawnPos, east, (configfile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> "O_G_InfTeam_Light")] call BIS_fnc_spawnGroup;
        _allGroups pushBack _grp;

        if (_isFirstWave) then {
            [_grp, _missionCenter, 100] call BIS_fnc_taskPatrol;
        } else {
            private _wp = _grp addWaypoint [_missionCenter, 0];
            _wp setWaypointType "SAD";
            _wp setWaypointBehaviour "AGGRESSIVE";
        };
    };

    // --- 3. マーカーテキストによるリアルタイム更新 ---
    waitUntil {
        sleep 2;
        private _remainingGroups = { ({alive _x} count units _x) > 0 } count _allGroups;
        private _aliveUnits = 0;
        { _aliveUnits = _aliveUnits + ({alive _x} count units _x); } forEach _allGroups;

        // マーカーテキストを更新
        _mkr setMarkerText (format ["目標：%1 (W:%2/%3 残存:%4分隊)", _locName, _w, _totalWaves, _remainingGroups]);

        _aliveUnits < 2
    };

    if (_w < _totalWaves) then {
        _mkr setMarkerText (format ["目標：%1 (増援接近中...)", _locName]);
        ["敵を制圧。次の増援に備えろ！"] remoteExec ["hint", 0];
        sleep 20;
    };
};

deleteMarker _mkrName;
["ミッション完了。全エリアの安全を確保した。"] remoteExec ["hint", 0];