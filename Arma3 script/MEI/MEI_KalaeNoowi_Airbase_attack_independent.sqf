if (isserver) then {
    _trigger = thisTrigger;
    _triggerPosATL = getPosATL _trigger;
    _triggerAreaSize = triggerArea _trigger;
    _triggerRadius = ((_triggerAreaSize select 0) + (_triggerAreaSize select 1)) / 2;

    _groupConfigs = [
        (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_RIF_01_Squad"),
        (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_RIF_02_Squad"),
        (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_RIF_03_Squad"),
        (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_RIF_01_FireTeam"),
        (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_RIF_02_FireTeam"),
        (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_RIF_03_FireTeam"),
        (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_RIF_04_FireTeam"),
        (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_RIF_05_FireTeam"),
        (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_RIF_06_FireTeam"),
        (configfile >> "CfgGroups" >> "Indep" >> "UK3CB_MEI_I" >> "Infantry" >> "UK3CB_MEI_I_AT_FireTeam")
    ];

    _markerNames = [
        "KalaeNoowi1",
        "KalaeNoowi2",
        "KalaeNoowi3",
        "KalaeNoowi4",
        "KalaeNoowi5",
        "KalaeNoowi6",
        "KalaeNoowi7",
        "KalaeNoowi8",
        "DefencePoint1",
        "DefencePoint10",
        "DefencePoint11",
        "DefencePoint12",
        "DefencePoint13",
        "DefencePoint14",
        "DefencePoint15",
        "DefencePoint16",
        "DefencePoint17",
        "DefencePoint18",
        "DefencePoint19",
        "DefencePoint2",
        "DefencePoint20",
        "DefencePoint21",
        "DefencePoint22",
        "DefencePoint23",
        "DefencePoint24",
        "DefencePoint25",
        "DefencePoint26",
        "DefencePoint27",
        "DefencePoint28",
        "DefencePoint29",
        "DefencePoint3",
        "DefencePoint30",
        "DefencePoint31",
        "DefencePoint4",
        "DefencePoint5",
        "DefencePoint6",
        "DefencePoint7",
        "DefencePoint8",
        "DefencePoint9"
    ];

    _baseVehicleConfigs = [
        "UK3CB_MEI_I_Hilux_Dshkm",
        "UK3CB_MEI_I_LR_M2",
        "UK3CB_MEI_I_V3S_Zu23"
    ];
    _t55Config = "UK3CB_MEI_I_T55";
    _v3sZu23Config = "UK3CB_MEI_I_V3S_Zu23";

    _turretConfigs = [
        "UK3CB_MEI_I_2b14_82mm",
        "UK3CB_MEI_I_Igla_AA_pod",
        "UK3CB_MEI_I_AGS",
        "UK3CB_MEI_I_DSHKM",
        "UK3CB_MEI_I_DSHkM_Mini_TriPod",
        "UK3CB_MEI_I_PKM_High",
        "UK3CB_MEI_I_PKM_Low",
        "UK3CB_MEI_I_PKM_nest",
        "UK3CB_MEI_I_SPG9",
        "UK3CB_MEE_I_ZU23"
    ];

    _totalUnitsSpawned = 0;
    _maxTotalUnits = 300;
    _maxTotalVehicles = 30;
    _totalVehiclesSpawned = 0;
    _maxT55Vehicles = 3;
    _totalT55Spawned = 0;
    _maxV3sZu23Vehicles = 5;
    _totalV3sZu23Spawned = 0;

    diag_log format ["トリガーの中心位置: %1, 半径: %2", _triggerPosATL, _triggerRadius];

    {
        if (_totalUnitsSpawned < _maxTotalUnits && {_groupConfigs isNotEqualTo []}) then {
            _spawnPositionMarker = getMarkerPos _x;
            _randomIndexGroup = floor random (count _groupConfigs);
            _selectedGroupConfig = _groupConfigs select _randomIndexGroup;

            if (isClass _selectedGroupConfig) then {
                _group = [_spawnPositionMarker, independent, _selectedGroupConfig] call BIS_fnc_spawnGroup;
                diag_log format ["マーカー '%1' にグループ '%2' をスポーン試行 (結果: %3)", _x, getText (_selectedGroupConfig >> "displayName"), _group];
                if (typeName _group == "GROUP") then {
                    _totalUnitsSpawned = _totalUnitsSpawned + (count units _group);

                    _waypointSentryPos = _spawnPositionMarker getPos [random 300, random 360];
                    _wpSentry = _group addWaypoint [_waypointSentryPos, 300];
                    _wpSentry setWaypointType "MOVE";
                    _wpSentry setWaypointBehaviour "COMBAT";
                    _wpSentry setWaypointSpeed "NORMAL";

                    _wpCycle = _group addWaypoint [_spawnPositionMarker, 0];
                    _wpCycle setWaypointType "CYCLE";
                    _wpCycle setWaypointBehaviour "SAFE";
                    _wpCycle setWaypointSpeed "LIMITED";
                } else {
                    diag_log format ["エラー: マーカー '%1' のグループ '%2' のスポーンに失敗しました。", _x, getText (_selectedGroupConfig >> "displayName")];
                    diag_log format ["エラー詳細: BIS_fnc_spawnGroup の戻り値は '%1' でした。", typeName _group];
                };
            } else {
                diag_log format ["エラー: グループ設定が見つかりません。", _selectedGroupConfig];
            };
        };
    } foreach _markerNames;

    while {_totalUnitsSpawned < _maxTotalUnits && _totalVehiclesSpawned < _maxTotalVehicles} do {
        _randomIndexMarker = floor random (count _markerNames);
        _selectedMarkerName = _markerNames select _randomIndexMarker;
        _spawnPositionVehicle = getMarkerPos _selectedMarkerName getPos [random 300, random 360];
        _spawnPositionVehicleWorld = [_spawnPositionVehicle select 0, _spawnPositionVehicle select 1, 0];
        _spawnDirectionVehicle = random 360;
        _selectedVehicleConfig = "";

        if (_totalT55Spawned < _maxT55Vehicles && random 1 < 0.3) then { 
            _selectedVehicleConfig = _t55Config;
        } else {
            if (_totalV3sZu23Spawned < _maxV3sZu23Vehicles && random 1 < 0.4 && {_x == _v3sZu23Config} count _baseVehicleConfigs > 0) then { 
                _selectedVehicleConfig = _v3sZu23Config;
            } else {
                if ({_x != _t55Config && _x != _v3sZu23Config} count _baseVehicleConfigs > 0) then {
                    _otherBaseVehicles = _baseVehicleConfigs - [_t55Config, _v3sZu23Config];
                    if (_otherBaseVehicles isNotEqualTo []) then {
                        _randomIndexBaseVehicle = floor random (count _otherBaseVehicles);
                        _selectedVehicleConfig = _otherBaseVehicles select _randomIndexBaseVehicle;
                    };
                } else {
                    if ({_x == _v3sZu23Config} count _baseVehicleConfigs > 0 && _totalV3sZu23Spawned < _maxV3sZu23Vehicles) then {
                        _selectedVehicleConfig = _v3sZu23Config;
                    };
                };
            };
        };

        if (_selectedVehicleConfig != "") then {
            _vehicle = createVehicle [_selectedVehicleConfig, _spawnPositionVehicleWorld, [], 300, "NONE"];
            if (typeName _vehicle == "OBJECT") then {
                _totalUnitsSpawned = _totalUnitsSpawned + 1;
                _totalVehiclesSpawned = _totalVehiclesSpawned + 1;
                if (_selectedVehicleConfig == _t55Config) then {
                    _totalT55Spawned = _totalT55Spawned + 1;
                };
                if (_selectedVehicleConfig == _v3sZu23Config) then {
                    _totalV3sZu23Spawned = _totalV3sZu23Spawned + 1;
                };
                _crew = createVehicleCrew _vehicle;
                _vehicleGroup = group _vehicle;

                _waypointVehicleSentryPos = _spawnPositionVehicle getPos [random 300, random 360];
                _wpVehicle = _vehicleGroup addWaypoint [_waypointVehicleSentryPos, 300];
                _wpVehicle setWaypointType "MOVE";
                _wpVehicle setWaypointBehaviour "COMBAT";
                _wpVehicle setWaypointSpeed "NORMAL";

                _wpCycleVehicle = _vehicleGroup addWaypoint [_spawnPositionVehicleWorld, 0];
                _wpCycleVehicle setWaypointType "CYCLE";
                _wpCycleVehicle setWaypointBehaviour "SAFE";
                _wpCycleVehicle setWaypointSpeed "LIMITED";
                diag_log format ["マーカー '%1' 付近にビークル '%2' をスポーンしました。", _selectedMarkerName, _selectedVehicleConfig];
            } else {
                diag_log format ["エラー: マーカー '%1' 付近へのビークル '%2' のスポーンに失敗しました。", _selectedMarkerName, _selectedVehicleConfig];
                diag_log format ["エラー詳細: ビークル '%1' の生成に失敗しました。createVehicle の戻り値: %2", _selectedVehicleConfig, _vehicle];
            };
        };
    };

    while {_totalUnitsSpawned < _maxTotalUnits && {_turretConfigs isNotEqualTo []}} do {
        _randomIndexTurret = floor random (count _turretConfigs);
        _selectedTurretConfig = _turretConfigs select _randomIndexTurret;
        _randomIndexMarkerTurret = floor random (count _markerNames);
        _selectedMarkerNameTurret = _markerNames select _randomIndexMarkerTurret;
        _spawnPositionTurret = getMarkerPos _selectedMarkerNameTurret; 
        _spawnDirectionTurret = random 360;

        _turret = createVehicle [_selectedTurretConfig, _spawnPositionTurret, [], 300, "NONE"]; 
        _turret setpos [getPos _turret select 0, getPos _turret select 1, (getPos _turret select 2) + 3 ];
        if (typeName _turret == "OBJECT") then {
            _totalUnitsSpawned = _totalUnitsSpawned + 1;
            diag_log format ["マーカー '%1' 付近にタレット '%2' をスポーンしました。", _selectedMarkerNameTurret, _selectedTurretConfig];
        } else {
            diag_log format ["エラー: マーカー '%1' 付近へのタレット '%2' のスポーンに失敗しました。", _selectedMarkerNameTurret, _selectedTurretConfig];
            diag_log format ["エラー詳細: タレット '%1' の生成に失敗しました。createVehicle の戻り値: %2", _selectedTurretConfig, _turret];
        };
    };

    diag_log format ["合計 %1 個の独立勢力ユニットをスポーンしました (最大 %2)。", _totalUnitsSpawned, _maxTotalUnits];
    diag_log format ["合計 %1 台のビークルをスポーンしました (最大 %2)。T-55: %3 台, V3S Zu23: %4 台", _totalVehiclesSpawned, _maxTotalVehicles, _totalT55Spawned, _totalV3sZu23Spawned];
};