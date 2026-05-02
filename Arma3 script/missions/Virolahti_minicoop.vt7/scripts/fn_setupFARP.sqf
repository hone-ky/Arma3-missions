/* scripts/fn_setupFARP.sqf */

openMap true;
hint "マップをクリックしてFARP設営地点を指定してください。\n(できるだけ平らな場所を選んでください)";

onMapSingleClick {
    params ["_pos", "_units", "_shift", "_alt"];

    private _clsFuel    = "rhsusf_M978A4_BKIT_usarmy_wd";
    private _clsAmmo    = "rhsusf_M977A4_AMMO_BKIT_usarmy_wd";
    private _clsRepair  = "rhsusf_M977A4_REPAIR_BKIT_usarmy_wd";
    
    // 修正: 弾薬箱のタイプミス修正済み
    private _clsAntenna = "Land_Communication_F"; 
    private _clsAmmoBox = "VirtualReammoBox_camonet_F"; 
    // 追加: ヘリパッド
    private _clsPad     = "Land_HelipadCircle_F";

    diag_log text format ["[FARP] Setup initiated at Grid: %1", mapGridPosition _pos];
    hint "工兵隊: 整地・設営作業を開始します...";
    
    private _centerPos = [_pos, 0, 1000, 20, 0, 0.15, 0] call BIS_fnc_findSafePos;
    
    if (count _centerPos != 2 && { _centerPos distance2D [0,0] < 100 }) exitWith {
        diag_log text "[FARP] Error: No safe position found.";
        hint "エラー: 車両を展開できる平地が見つかりませんでした。\n別の場所を指定してください。";
    };

    fnc_safeSpawn = {
        params ["_class", "_pos", "_dir"];
        if (!(_class isEqualType "")) exitWith { objNull };
        private _obj = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
        if (!isNull _obj) then {
            _obj setDir _dir;
            _obj setPosATL [_pos select 0, _pos select 1, 0.1];
            _obj setVectorUp surfaceNormal _pos;
            _obj allowDamage false;
            [_obj] spawn { sleep 5; if (!isNull _0) then { _0 allowDamage true; _0 setDamage 0; }; };
        };
        _obj
    };

    // --- 0. ヘリパッド (中心) ---
    // 一番最初に置いて、ここを目印にする
    [_clsPad, _centerPos, 0] call fnc_safeSpawn;

    // --- 1. 指揮所 (少しずらす) ---
    diag_log text "[FARP] Deploying Command Post...";
    private _cpPos = _centerPos getPos [15, 0]; // ヘリパッドから北へ15m
    [_clsAntenna, _cpPos, 0] call fnc_safeSpawn;
    
    private _gen = ["Land_DieselGroundPowerUnit_01_F", _cpPos getPos [4, 180], 0] call fnc_safeSpawn;
    private _table = ["Land_CampingTable_F", _cpPos getPos [3, 90], 270] call fnc_safeSpawn;
    private _laptop = ["Land_Laptop_device_F", _cpPos getPos [3, 90], 270] call fnc_safeSpawn;
    if (!isNull _laptop && !isNull _table) then { _laptop attachTo [_table, [0, 0, 0.8]]; };

    // --- 2. 弾薬車エリア (右側) ---
    private _ammoBasePos = _centerPos getPos [25, 90]; 
    private _ammoTruck = [_clsAmmo, _ammoBasePos, 180] call fnc_safeSpawn;
    if (!isNull _ammoTruck) then {
        [_ammoTruck, 10000] call ace_rearm_fnc_setSupplyCount;
        ["Land_HBarrier_5_F", _ammoTruck getRelPos [9, 180], 180] call fnc_safeSpawn;
        ["Land_HBarrier_5_F", _ammoTruck getRelPos [8, 270], 270] call fnc_safeSpawn;
        ["Land_HBarrier_5_F", _ammoTruck getRelPos [8, 90], 90] call fnc_safeSpawn;
        [_clsAmmoBox, _ammoTruck getRelPos [5, 90], 180] call fnc_safeSpawn;
    };

    // --- 3. 燃料車エリア (左側) ---
    private _fuelBasePos = _centerPos getPos [25, 270];
    private _fuelTruck = [_clsFuel, _fuelBasePos, 180] call fnc_safeSpawn;
    if (!isNull _fuelTruck) then {
        _fuelTruck setVariable ["ACE_canRefuel", 1, true];
        ["Land_HBarrier_5_F", _fuelTruck getRelPos [9, 180], 180] call fnc_safeSpawn;
    };
    
    // --- 4. 修理車エリア (奥側) ---
    private _repairBasePos = _centerPos getPos [25, 180]; // 南側へ
    private _repairTruck = [_clsRepair, _repairBasePos, 0] call fnc_safeSpawn;
    if (!isNull _repairTruck) then {
        _repairTruck setVariable ["ACE_isRepairVehicle", 1, true];
    };
    
    // --- 5. 人員 ---
    private _grp = createGroup [west, true];
    private _officer = _grp createUnit ["rhsusf_army_ucp_squadleader", _cpPos getPos [2, 90], [], 0, "NONE"];
    _officer setUnitPos "UP";
    if (!isNull _laptop) then { _officer doWatch _laptop; };

    if (!isNull _ammoTruck) then {
        private _mech = _grp createUnit ["rhsusf_army_ucp_crewman", _ammoBasePos getPos [5, 0], [], 0, "NONE"];
        _mech doWatch _ammoTruck;
    };

    private _guard = _grp createUnit ["rhsusf_army_ucp_rifleman", _centerPos getPos [15, 180], [], 0, "NONE"];
    _guard setUnitPos "MIDDLE";

    _grp setBehaviour "SAFE";
    { doStop _x; _x disableAI "PATH"; } forEach units _grp;

    // --- 6. 完了 ---
    private _mkrName = format ["FARP_%1", floor(random 10000)];
    private _mkr = createMarker [_mkrName, _centerPos];
    _mkr setMarkerType "b_hq";
    _mkr setMarkerText "FARP Command";
    _mkr setMarkerColor "ColorBlue";
    
    "SmokeShellGreen" createVehicle _centerPos;

    diag_log text "[FARP] Setup Complete successfully.";
    hint "FARP設営完了。\nヘリパッドを目印に着陸してください。";
    
    onMapSingleClick "";
    openMap false;
    true
};