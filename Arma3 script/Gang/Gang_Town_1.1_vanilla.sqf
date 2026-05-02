private _centerPos = getPosATL thistrigger;
private _side = east;
private _faction = "OPF_G_F";

private _locations = nearestLocations [_centerPos, ["NameCityCapital", "NameCity", "NameVillage"], 15000];
if (count _locations == 0) exitWith { hint "有効な街が見つかりませんでした"; };
private _targetLocation = locationPosition (selectRandom _locations);
_targetLocation set [2, 0];

private _obj = createVehicle ["Land_FoodSacks_01_cargo_brown_F", _targetLocation, [], 20, "NONE"];
private _objPos = getPosATL _obj;
private _deco = createVehicle ["O_CargoNet_01_ammo_F", _objPos, [], 2, "CAN_COLLIDE"];

[_obj, true, [0, 1, 0], 0] remoteExec ["ace_cargo_fnc_makeLoadable", 0, true];
[_deco, true, [0, 1, 0], 0] remoteExec ["ace_cargo_fnc_makeLoadable", 0, true];

private _hqGroup = [_objPos, _side, (configfile >> "CfgGroups" >> "East" >> _faction >> "Infantry" >> "O_G_InfSquad_Assault")] call BIS_fnc_spawnGroup;
[_hqGroup, _objPos] call BIS_fnc_taskAttack;

for "_i" from 0 to (round random 5) do {
    private _sentryGrp = [_objPos, _side, (configfile >> "CfgGroups" >> "East" >> _faction >> "Infantry" >> "O_G_InfTeam_Light")] call BIS_fnc_spawnGroup;
    [_sentryGrp, _objPos, 150] call BIS_fnc_taskPatrol;
};

for "_i" from 0 to (1 + round random 2) do {
    private _veh = createVehicle ["O_G_Offroad_01_armed_F", _objPos, [], 100, "NONE"];
    createVehicleCrew _veh; 
    [group driver _veh, _objPos, 400] call BIS_fnc_taskPatrol;
};

private _mkrName = format ["mkr_obj_%1", round(time)];
private _mkr = createMarker [_mkrName, _objPos];
_mkr setMarkerType "hd_objective";
_mkr setMarkerText "敵麻薬拠点";
_mkr setMarkerColor "ColorOPFOR";

[_obj, _mkrName, _objPos] spawn {
    params ["_target", "_mkr", "_originalPos"];
    
    waitUntil {
        sleep 5;
        !(isNull (objectParent _target)) || (_target distance _originalPos > 100)
    };
    hint "証拠品を確保。エリアから離脱せよ。";

    waitUntil {
        sleep 5;
        private _currentPos = if (!(isNull (objectParent _target))) then { getPosATL (objectParent _target) } else { getPosATL _target };
        (_currentPos distance _originalPos) > 5000
    };

    deleteMarker _mkr;
    hint "証拠品の回収に成功！任務完了。";
};

private _trgClear = createTrigger ["EmptyDetector", _objPos];
_trgClear setTriggerArea [300, 300, 0, false];
_trgClear setTriggerActivation ["EAST", "NOT PRESENT", false];
_trgClear setTriggerStatements ["this", "hint '地区の制圧を確認。証拠品を持ち去れ。';", ""];

for "_i" from 0 to (5 + random 5) do {
    private _civGrp = createGroup civilian;
    private _civ = _civGrp createUnit [selectRandom ["C_man_p_beggar_F", "C_man_1", "C_man_polo_1_F"], _objPos, [], 150, "NONE"];
    [_civGrp, _objPos, 200] call BIS_fnc_taskPatrol;
};