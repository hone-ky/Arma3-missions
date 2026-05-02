if (isserver) then {
    // 設定
    _dummyObject = "Land_WaterBottle_01_cap_F";
    _eastFactionMSVInfantryCHQ = configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_chq";
    _eastFactionMSVInfantryFireteam = configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_fireteam";
    _eastFactionMSVInfantrySquad = configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad";
    _eastFactionTV90Platoon = configfile >> "CfgGroups" >> "East" >> "rhs_faction_tv" >> "rhs_group_rus_tv_90" >> "RHS_T90SMPlatoon";
    _minRFInfSquad = configfile >> "CfgGroups" >> "East" >> "min_rf" >> "Infantry" >> "min_rf_InfSquad";
    _defaultSpawnOffsetZ = 0.5;
    _supplyCheckInterval = 60; // 補給チェックの間隔 (秒)
    _supplyLocationTypes = ["NameCity", "NameVillage", "Namelocal"]; // 補給地点のロケーションタイプ

    // スポーンしたオブジェクトの Z 座標を微調整する関数 (埋まり込み防止)
    _fnc_adjustSpawnHeight = {
        params ["_object", "_offset"];
        if (isNull _object) exitWith {};
        _pos = getPos _object;
        _object setPos [_pos select 0, _pos select 1, (_pos select 2) + _offset];
    };

    // グループの巡回 Waypoint を設定する関数
    _fnc_setGroupPatrol = {
        params ["_group", "_position", "_radius"];
        if (isNull _group) exitWith {};
        for "_i" from 1 to 4 do {
            _wp = _group addWaypoint [_position, _radius];
            _wp setWaypointType "sentry";
            _wp setWaypointBehaviour "SAFE";
            _wp setWaypointSpeed "LIMITED";
        };
        _wp = _group addWaypoint [getWPPos _group, 0];
        _wp setWaypointType "cycle";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };

    // 車両の巡回 Waypoint を設定する関数
    _fnc_setVehiclePatrol = {
        params ["_vehicle", "_targetPosition", "_radius"];
        if (isNull _vehicle) exitWith {};
        _group = createVehicleCrew _vehicle;
        [_vehicle, _defaultSpawnOffsetZ] call _fnc_adjustSpawnHeight;
        for "_i" from 1 to 4 do {
            _wp = _group addWaypoint [_targetPosition, _radius];
            _wp setWaypointType "sentry";
            _wp setWaypointBehaviour "SAFE";
            _wp setWaypointSpeed "LIMITED";
        };
        _wp = _group addWaypoint [getPos _vehicle, 0]; // 現在の高度で巡回
        _wp setWaypointType "cycle";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };

    _triggerPosition = getPosATL thistrigger;

    // 主要な拠点オブジェクトを作成
    _hqObject = createVehicle [_dummyObject, _triggerPosition, [], 7000, "none"];
    _hqObjectASL = getPosASL _hqObject;

    // 拠点の近くの都市または村を取得
    _isCityHQ = (random 1) > 0.7;
    _landLocationHQ = locationPosition nearestLocation [_hqObjectASL, if (_isCityHQ) then {"NameCity"} else {"Namevillage"}];
    _landLocationHQ set [2, 0];

    _mainStructure = createVehicle [_dummyObject, _landLocationHQ, [], 2000, "none"];
    _mainStructureATL = getPosATL _mainStructure;
    _cargoHQ = createVehicle ["Land_Cargo_HQ_V1_F", _mainStructureATL, [], 500, "none"];
    [_cargoHQ, _defaultSpawnOffsetZ] call _fnc_adjustSpawnHeight;
    _communication = createVehicle ["Land_Communication_F", getPosATL _cargoHQ, [], 20, "none"];
    [_communication, _defaultSpawnOffsetZ] call _fnc_adjustSpawnHeight;
    _powerGenerator = createVehicle ["Land_PowerGenerator_F", getPosATL _communication, [], 5, "none"];
    [_powerGenerator, _defaultSpawnOffsetZ] call _fnc_adjustSpawnHeight;

    // 本部グループをスポーン
    _hqGroup = [_mainStructureATL, east, _eastFactionMSVInfantryCHQ] call BIS_fnc_spawnGroup;
    [_hqGroup, _mainStructureATL, 50] call _fnc_setGroupPatrol;

    // BTR-70 をランダムにスポーン
    for "_i" from 1 to (4 - (random 5)) do {
        _btr = createVehicle ["rhs_btr70_msv", getPosATL _cargoHQ, [], 300];
        [_btr, getPosATL _cargoHQ, 300] call _fnc_setVehiclePatrol;
    };

    // 哨戒兵グループをランダムにスポーン
    for "_i" from 0 to (random 5) do {
        _sentryGroup = [_mainStructureATL, east, _eastFactionMSVInfantryFireteam] call BIS_fnc_spawnGroup;
        [_sentryGroup, _mainStructureATL, 400] call _fnc_setGroupPatrol;
    };

    // QRF グループをランダムにスポーン
    for "_i" from 0 to (random 3) do {
        _qrfGroup = [_mainStructureATL, east, _eastFactionMSVInfantrySquad] call BIS_fnc_spawnGroup;
        [_qrfGroup, _mainStructureATL, 200] call _fnc_setGroupPatrol;
    };

    // ZSU-23-4 をランダムにスポーン
    for "_i" from 1 to (random 5) do {
        _zsu = createVehicle ["rhs_zsu234_aa", getPosATL _cargoHQ, [], 2000];
        [_zsu, getPosATL _cargoHQ, 2000] call _fnc_setVehiclePatrol;
    };

    // Mi-24 をランダムにスポーン
    for "_i" from 1 to (random 5) do {
        _mi24 = createVehicle ["RHS_Mi24Vt_vvsc", getPosATL _cargoHQ, [], 3000];
        [_mi24, getPosATL _cargoHQ, 10000] call _fnc_setVehiclePatrol;
    };

    // Ka-52 をランダムにスポーン (8～10 機)
    for "_i" from 8 to (random 10) do {
        _ka52 = createVehicle ["RHS_Ka52_vvsc", getPosATL _cargoHQ, [], 3000];
        [_ka52, getPosATL _cargoHQ, 10000] call _fnc_setVehiclePatrol;
    };

    // T-90SM 小隊をランダムな場所にスポーン
    for "_i" from 0 to (random 3) do {
        _randomLocationTank = createVehicle [_dummyObject, _triggerPosition, [], 4000, "none"];
        _randomLocationTankASL = getPosASL _randomLocationTank;
        _tankGroup = [_randomLocationTankASL, east, _eastFactionTV90Platoon] call BIS_fnc_spawnGroup;
        [_tankGroup, _randomLocationTankASL, 4000] call _fnc_setGroupPatrol;
        deleteVehicle _randomLocationTank;
    };

    // 複数の歩兵グループと車両をランダムな場所にスポーン
    for "_j" from 0 to (random 3) do {
        _randomLocationMultipleUnits = createVehicle [_dummyObject, _triggerPosition, [], 4000, "none"];
        _randomLocationMultipleUnitsASL = getPosASL _randomLocationMultipleUnits;
        _spawnCounter = 0;

        // 歩兵グループ (CHQ) をランダムな数スポーン
        for "_i" from 7 to (random 7) do {
            _infantryHQGroup = [_randomLocationMultipleUnitsASL, east, _eastFactionMSVInfantryCHQ] call BIS_fnc_spawnGroup;
            [_infantryHQGroup, _randomLocationMultipleUnitsASL, 50] call _fnc_setGroupPatrol;
            _spawnCounter = _spawnCounter + 1;
        };

        // 哨戒兵グループをランダムな数スポーン
        for "_i" from 0 to (random 5) do {
            _infantrySentryGroup = [_randomLocationMultipleUnitsASL, east, _eastFactionMSVInfantryFireteam] call BIS_fnc_spawnGroup;
            [_infantrySentryGroup, _randomLocationMultipleUnitsASL, 400] call _fnc_setGroupPatrol;
            _spawnCounter = _spawnCounter + 1;
        };

        // QRF グループをランダムな数スポーン
        for "_i" from 0 to (random 3) do {
            _infantryQRFGroup = [_randomLocationMultipleUnitsASL, east, _eastFactionMSVInfantrySquad] call BIS_fnc_spawnGroup;
            [_infantryQRFGroup, _randomLocationMultipleUnitsASL, 200] call _fnc_setGroupPatrol;
            _spawnCounter = _spawnCounter + 1;
        };

        // BTR をスポーン (歩兵グループ数の半分)
        for "_i" from 1 to floor (_spawnCounter / 2) do { // floor で整数化
            _btrMultiple = createVehicle ["rhs_btr70_msv", _randomLocationMultipleUnitsASL, [], 300];
            [_btrMultiple, _randomLocationMultipleUnitsASL, 300] call _fnc_setVehiclePatrol;
        };
        deleteVehicle _randomLocationMultipleUnits;
    };

    // 補給地点をランダムな場所に作成
    for "_i" from 0 to (random 3) do {
        _supplyLocationObject = createVehicle [_dummyObject, _triggerPosition, [], 4000, "none"];
        _supplyLocationObjectASL = getPosASL _supplyLocationObject;
        _landLocationSupply = locationPosition nearestLocation [_supplyLocationObjectASL, selectRandom _supplyLocationTypes];
        _landLocationSupply set [2, 0];

        _ammoBox = createVehicle ["BOX_min_rf_AmmoVeh", _landLocationSupply, [], 100, "none"];
        [_ammoBox, _defaultSpawnOffsetZ] call _fnc_adjustSpawnHeight;
        _camoNet = createVehicle ["CamoNet_BLUFOR_open_F", getPosATL _ammoBox, [], 0, "none"];
        [_camoNet, _defaultSpawnOffsetZ] call _fnc_adjustSpawnHeight;

        // 補給地点の警備兵をスポーン
        _hqGuardGroup = [getPosATL _ammoBox, east, _eastFactionMSVInfantryCHQ] call BIS_fnc_spawnGroup;
        [_hqGuardGroup, getPosATL _ammoBox, 50] call _fnc_setGroupPatrol;

        // BTR をランダムにスポーン
        for "_j" from 0 to (random 2) do {
            _btrGuard = createVehicle ["rhs_btr70_msv", getPosATL _camoNet, [], 300];
            [_btrGuard, getPosATL _camoNet, 300] call _fnc_setVehiclePatrol;
        };

        // 哨戒兵グループをランダムにスポーン
        for "_j" from 0 to (random 5) do {
            _sentryGuardGroup = [getPosATL _ammoBox, east, _eastFactionMSVInfantryFireteam] call BIS_fnc_spawnGroup;
            [_sentryGuardGroup, getPosATL _ammoBox, 400] call _fnc_setGroupPatrol;
        };

        // QRF グループをランダムにスポーン
        for "_j" from 0 to (random 3) do {
            _qrfGuardGroup = [getPosATL _ammoBox, east, _eastFactionMSVInfantrySquad] call BIS_fnc_spawnGroup;
            [_qrfGuardGroup, getPosATL _ammoBox, 200] call _fnc_setGroupPatrol;
        };
        deleteVehicle _supplyLocationObject;
    };

    // 小規模な拠点をランダムな場所に作成 (異なるグループを使用)
    for "_i" from 0 to (random 3) do {
        _smallOutpostObject = createVehicle [_dummyObject, _triggerPosition, [], 4000, "none"];
        _smallOutpostObjectASL = getPosASL _smallOutpostObject;
        _landLocationOutpost = locationPosition nearestLocation [_smallOutpostObjectASL, selectRandom ["NameCity", "Namevillage", "Namelocal"]];
        _landLocationOutpost set [2, 0];

        _smallStructure1 = createVehicle [_dummyObject, _landLocationOutpost, [], 2000, "none"];
        _smallStructure1ATL = getPosATL _smallStructure1;
        _smallStructure2 = createVehicle [_dummyObject, _smallStructure1ATL, [], 500, "none"];
        _smallStructure2ATL = getPosATL _smallStructure2;

        [_smallStructure1, _defaultSpawnOffsetZ] call _fnc_adjustSpawnHeight;
        [_smallStructure2, _defaultSpawnOffsetZ] call _fnc_adjustSpawnHeight;

        // 守備兵グループをスポーン (異なるグループ)
        _guardGroup = [_smallStructure2ATL, east, _minRFInfSquad] call BIS_fnc_spawnGroup;
        [_guardGroup, _smallStructure2ATL, 50] call _fnc_setGroupPatrol;

        // BTR をランダムにスポーン
        for "_j" from 1 to (random 3) do {
            _btrOutpost = createVehicle ["rhs_btr70_msv", _smallStructure2ATL, [], 300];
            [_btrOutpost, _smallStructure2ATL, 300] call _fnc_setVehiclePatrol;
        };
        _samSystem = createVehicle ["O_R_SAM_System_04_F", _smallStructure2ATL, [], 30];
        [_samSystem, _defaultSpawnOffsetZ] call _fnc_adjustSpawnHeight;
        createVehicleCrew _samSystem;
        _radarSystem = createVehicle ["O_R_Radar_System_02_F", _smallStructure2ATL, [], 30];
        [_radarSystem, _defaultSpawnOffsetZ] call _fnc_adjustSpawnHeight;
        createVehicleCrew _radarSystem;
        deleteVehicle _smallOutpostObject;
        deleteVehicle _smallStructure1;
        deleteVehicle _smallStructure2;
    };

    _supplyTruckTrigger = createTrigger ["EmptyDetector", _trigger, false];
    _supplyTruckTrigger setTriggerArea [12000, 12000, -1, false];
    _supplyTruckTrigger setTriggerActivation ["EAST", "PRESENT", false];
    _supplyTruckTrigger setTriggerStatements ["this && round (time % _supplyCheckInterval) == 0", {
        {
            if (side _x == east && isKindOf _x "Car") then { // 東陣営の車両（Car クラス）
                _ammoTruckLocation = locationPosition nearestLocation [getPos _x, selectRandom _supplyLocationTypes];
                if (_ammoTruckLocation isEqualTo []) then {
                    _ammoTruckLocation = _triggerPosition; // 見つからなければトリガーの位置へ
                };
                _waypointPosition = getWPPos _x;
                _magazinesAmmo = magazinesAmmo [_x, false];
                _magazinesCount = count _magazinesAmmo;
                if (_magazinesCount <= 2 && str _waypointPosition != str _ammoTruckLocation) then {
                    _x move _ammoTruckLocation;
                };
            };
        } forEach thislist;
    }, ""];

    _mortarLocationObject = createVehicle [_dummyObject, _triggerPosition, [], 4000, "none"];
    _mortarLocationObjectASL = getPosASL _mortarLocationObject;
    for "_i" from 0 to (random 5) do {
        _mortar = createVehicle ["rhs_D30_msv", _mortarLocationObjectASL, [], 30];
        [_mortar, _defaultSpawnOffsetZ] call _fnc_adjustSpawnHeight;
        createVehicleCrew _mortar;
    };
    deleteVehicle _mortarLocationObject;
};