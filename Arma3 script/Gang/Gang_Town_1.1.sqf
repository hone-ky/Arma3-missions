private _centerPos = getPosATL thistrigger;
private _side = east;
private _faction = "UK3CB_MEI_O"; 

private _locations = nearestLocations [_centerPos, ["NameCityCapital", "NameCity"], 15000];
if (count _locations == 0) exitWith { hint "有効な街が見つかりませんでした"; };

private _targetLocation = locationPosition (selectRandom _locations);
_targetLocation set [2, 0];

private _obj = createVehicle ["UK3CB_Cocaine_Pallet_Wrapped", _targetLocation, [], 20, "NONE"];
private _objPos = getPosATL _obj;
private _deco = createVehicle ["UK3CB_BAF_Vehicles_Servicing_Ground_Point", _objPos, [], 0, "CAN_COLLIDE"];
_obj setVehicleVarName "evidence";

private _hqGroup = [_objPos, _side, (configfile >> "CfgGroups" >> "East" >> _faction >> "Infantry" >> "UK3CB_MEI_O_RIF_01_FireTeam")] call BIS_fnc_spawnGroup;
[_hqGroup, _objPos] call BIS_fnc_taskAttack;

for "_i" from 0 to (round random 10) do {
    private _sentryGrp = [_objPos, _side, (configfile >> "CfgGroups" >> "East" >> _faction >> "Infantry" >> "UK3CB_MEI_O_RIF_01_Squad")] call BIS_fnc_spawnGroup;
    [_sentryGrp, _objPos, 150] call BIS_fnc_taskPatrol;
};

private _supportCfgs = [
    (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Support" >> "UK3CB_MEI_I_Support_AGS30"),
    (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Support" >> "UK3CB_MEI_I_Support_DSHKM_HIGH"),
    (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Support" >> "UK3CB_MEI_I_Support_KORD"),
    (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Support" >> "UK3CB_MEI_I_Support_PKM_HIGH"),
    (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Support" >> "UK3CB_MEI_I_Support_SPG9")
];

for "_i" from 0 to (1 + round random 2) do {
    private _spawnPos = [_objPos, 20, 50, 3, 0, 20, 0] call BIS_fnc_findSafePos;
    private _stGrp = [_spawnPos, _side, selectRandom _supportCfgs] call BIS_fnc_spawnGroup;
    _stGrp setBehaviour "COMBAT";
};

for "_i" from 0 to (round random 5) do {
    private _veh = createVehicle ["UK3CB_MEI_O_Hilux_Pkm", _objPos, [], 100, "NONE"];
    createVehicleCrew _veh; 
    [group driver _veh, _objPos, 400] call BIS_fnc_taskPatrol;
};

private _mkrName = format ["mkr_obj_%1", round(time)];
private _mkr = createMarker [_mkrName, _objPos];
_mkr setMarkerType "hd_objective";
_mkr setMarkerText "敵麻薬拠点";
_mkr setMarkerColor "ColorOPFOR";

private _trgClear = createTrigger ["EmptyDetector", _objPos];
_trgClear setTriggerArea [300, 300, 0, false];
_trgClear setTriggerActivation ["EAST", "NOT PRESENT", false];
_trgClear setTriggerStatements [
    "this", 
    format ["deleteMarker '%1'; hint '地区の制圧に成功。証拠品を確保せよ。';", _mkrName], 
    ""
];

for "_i" from 0 to (10 + random 10) do {
    private _civGrp = createGroup civilian;
    private _civ = _civGrp createUnit [selectRandom ["C_man_p_beggar_F", "C_man_1"], _objPos, [], 150, "NONE"];
    [_civGrp, _objPos, 200] call BIS_fnc_taskPatrol;
};