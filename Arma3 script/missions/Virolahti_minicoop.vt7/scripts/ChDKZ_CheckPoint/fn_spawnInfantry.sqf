params ["_centerPos", "_frontDir"];

private _allSpawnedUnits = [];
private _allSpawnedGroups = [];

private _fnc_registerGroup = {
    params ["_grp"];
    _allSpawnedGroups pushBack _grp;
    { _allSpawnedUnits pushBack _x; } forEach units _grp;
};

// 1. 指揮官の生成
private _grpCmd = createGroup east;
"rhsgref_ins_commander" createUnit [_centerPos, _grpCmd];
private _commander = (units _grpCmd) select 0;

_commander setSkill 0.8;
_commander allowFleeing 0;
_grpCmd setCombatMode "YELLOW";
[_grpCmd] call _fnc_registerGroup;

ChDKZ_CheckPoint_ActiveGroups pushBack _grpCmd;
ChDKZ_CheckPoint_ActiveObjs pushBack _commander;

[_commander] execVM "scripts\ChDKZ_CheckPoint\fn_commanderLogic.sqf";


// ★追加: 1.5 固定機関銃の射手
// 拠点周辺（半径30m以内）に配置された StaticWeapon（固定武器）を探す
private _staticWeapons = _centerPos nearObjects ["StaticWeapon", 30];
if (count _staticWeapons > 0) then {
    private _wpn = _staticWeapons select 0;
    
    // 射手用の独立したグループとユニットを作成
    private _grpGunner = createGroup east;
    "rhsgref_ins_rifleman" createUnit [_centerPos, _grpGunner];
    private _gunner = (units _grpGunner) select 0;
    
    // 射手を機関銃に強制搭乗させる
    _gunner moveInGunner _wpn;
    
    // 制圧射撃の脅威度を上げるため、少しスキルを高めに設定
    _gunner setSkill 0.7;
    _grpGunner setCombatMode "YELLOW";
    
    [_grpGunner] call _fnc_registerGroup;
};


// 2. 直掩部隊 (防衛からDISMISSへ変更)
private _defendSquadCount = floor(random 3) + 1; 
for "_i" from 1 to _defendSquadCount do {
    private _spawnPos = _centerPos getPos [10 + random 15, random 360];
    private _grpDef = [_spawnPos, east, configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhsgref_group_chdkz_insurgents_infantry" >> "rhsgref_group_chdkz_insurgents_squad"] call BIS_fnc_spawnGroup;
    
    private _wp = _grpDef addWaypoint [_centerPos, 0];
    _wp setWaypointType "DISMISS";
    _wp setWaypointCombatMode "YELLOW";
    _grpDef setBehaviour "SAFE";
    
    [_grpDef] call _fnc_registerGroup;
};


// 3. パトロール部隊
private _patrolSquadCount = floor(random 2) + 4;
for "_i" from 1 to _patrolSquadCount do {
    private _spawnPos = _centerPos getPos [100 + random 100, random 360];
    private _grpPatrol = [_spawnPos, east, configfile >> "CfgGroups" >> "East" >> "rhsgref_faction_chdkz" >> "rhsgref_group_chdkz_insurgents_infantry" >> "rhsgref_group_chdkz_infantry_patrol"] call BIS_fnc_spawnGroup;
    
    _grpPatrol setBehaviour "SAFE";
    [_grpPatrol, _centerPos, 250] call BIS_fnc_taskPatrol;
    
    [_grpPatrol] call _fnc_registerGroup;
};


// 4. スナイパー・スポッターのデュオ
if (random 100 < 20) then {
    private _sniperDir = _frontDir - 45 + random 90;
    private _sniperPos = _centerPos getPos [150 + random 100, _sniperDir];
    
    private _grpSniper = createGroup east;
    "rhsgref_ins_sniper" createUnit [_sniperPos, _grpSniper];
    "rhsgref_ins_spotter" createUnit [_sniperPos getPos [2, _sniperDir + 90], _grpSniper];
    
    {
        _x setSkill 0.9;
        _x setSkill ["aimingAccuracy", 0.7];
        _x setSkill ["spotDistance", 1.0];
        _x setUnitPos "DOWN";
    } forEach (units _grpSniper);
    
    _grpSniper setCombatMode "GREEN";
    _grpSniper setBehaviour "STEALTH";
    
    private _wp = _grpSniper addWaypoint [_centerPos, 0];
    _wp setWaypointType "GUARD";
    [_grpSniper] call _fnc_registerGroup;
};

{ ChDKZ_CheckPoint_ActiveGroups pushBack _x; } forEach _allSpawnedGroups;
{ ChDKZ_CheckPoint_ActiveObjs pushBack _x; } forEach _allSpawnedUnits;

true