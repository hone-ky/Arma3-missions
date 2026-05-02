params ["_centerPos", "_roadDir"];

private _spawnedObjs = [];
private _frontDir = if (random 1 > 0.5) then { _roadDir } else { _roadDir - 180 };
if (_frontDir < 0) then { _frontDir = _frontDir + 360; };

private _fnc_createObj = {
    params ["_class", "_pos", "_dir"];
    private _obj = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
    _obj setDir _dir;
    _obj setVectorUp surfaceNormal _pos; 
    _obj
};

// 1. バンカー
private _bunkerClass = selectRandom ["Land_BagBunker_Small_F", "Land_BagBunker_Tower_F"];
private _sideOffsetDir = if (random 1 > 0.5) then { 90 } else { -90 };
private _bunkerPos = _centerPos getPos [8, _roadDir + _sideOffsetDir];

// スモールもタワーも、常に入り口が後ろになるように180度反転
private _bunkerDir = (_frontDir + 180) % 360;
private _bunker = [_bunkerClass, _bunkerPos, _bunkerDir] call _fnc_createObj;
_spawnedObjs pushBack _bunker;


// 2. 固定武器 (バンカー内部 / 2階に設置)
private _wpnClass = selectRandom ["rhsgref_ins_NSV_TriPod", "rhsgref_ins_AGS30_TriPod", "rhsgref_ins_DSHKM"];
private _wpnPosATL = getPosATL _bunker;

if (_bunkerClass == "Land_BagBunker_Tower_F") then {
    // タワー型: 2階部分 (高さ約2.8m)
    // 中心から防衛線方向（正面）に0.8mずらし、銃眼に寄せる
    private _offset2D = _bunkerPos getPos [0.8, _frontDir];
    _wpnPosATL = [_offset2D select 0, _offset2D select 1, (_wpnPosATL select 2) + 2.8];
} else {
    // スモール型: バンカー内部 (地面)
    // ★修正: 三脚の転倒を防ぐため、中心から「後方（入り口側）」に0.8mずらして配置する
    private _offset2D = _bunkerPos getPos [0.8, _frontDir + 180];
    _wpnPosATL = [_offset2D select 0, _offset2D select 1, (_wpnPosATL select 2)];
};

private _wpn = createVehicle [_wpnClass, [0,0,0], [], 0, "CAN_COLLIDE"];
_wpn disableCollisionWith _bunker; 

_wpn setDir _frontDir;
_wpn setPosATL _wpnPosATL;
_wpn setVectorUp [0,0,1];
_spawnedObjs pushBack _wpn;


// 3. 竜の歯
for "_i" from 1 to 3 do {
    private _dist = 8 + (_i * 12);
    private _teeth1 = ["Land_DragonsTeeth_01_4x2_new_F", _centerPos getPos [_dist, _roadDir + 90], _roadDir] call _fnc_createObj;
    _spawnedObjs pushBack _teeth1;
    private _teeth2 = ["Land_DragonsTeeth_01_4x2_new_F", _centerPos getPos [_dist, _roadDir - 90], _roadDir] call _fnc_createObj;
    _spawnedObjs pushBack _teeth2;
};

// 4. コンクリート壁
for "_i" from 0 to 1 do {
    private _side = if (_i == 0) then { 1 } else { -1 };
    private _wallPos = _bunkerPos getPos [6, _frontDir - (30 * _side)];
    private _wall = ["Land_CncBarrierMedium_F", _wallPos, _frontDir + (20 * _side)] call _fnc_createObj;
    _spawnedObjs pushBack _wall;
};

// 5. ハリネズミ
for "_i" from 0 to 2 do {
    private _hPos = _centerPos getPos [15 + (random 5), _frontDir + (-15 + (_i * 15))];
    private _hedge = ["Land_CzechHedgehog_01_new_F", _hPos, random 360] call _fnc_createObj;
    _spawnedObjs pushBack _hedge;
};

// 6. 有刺鉄線
private _wirePosL = _bunkerPos getPos [5, _frontDir - 90];
private _wireL = ["Land_Razorwire_F", _wirePosL, _frontDir + 90] call _fnc_createObj;
_spawnedObjs pushBack _wireL;

private _wirePosR = _bunkerPos getPos [5, _frontDir + 90];
private _wireR = ["Land_Razorwire_F", _wirePosR, _frontDir + 90] call _fnc_createObj;
_spawnedObjs pushBack _wireR;

// 7. カーゴハウス
if (random 1 < 0.5) then {
    private _housePos = _bunkerPos getPos [12, _frontDir + 180];
    private _house = ["Land_Cargo_House_V1_F", _housePos, _frontDir] call _fnc_createObj;
    _spawnedObjs pushBack _house;
};

[_spawnedObjs, _frontDir]