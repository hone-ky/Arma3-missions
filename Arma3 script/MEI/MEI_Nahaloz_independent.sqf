if (isserver) then {
    _trigger = thisTrigger;

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

    _markerConfigs = [
        "Bushlurker_drom1",
        "Bushlurker_drom2",
        "Bushlurker_drom3",
        "Bushlurker_helipad",
        "Bushlurker_HQ",
        "Bushlurker_Warehouse"
    ];

    _totalUnitsSpawned = 0;
    _targetUnitCount = 60;

    while {_totalUnitsSpawned < _targetUnitCount && {_markerConfigs isNotEqualTo []}} do {
        _randomIndexMarker = floor random (count _markerConfigs);
        _selectedMarker = _markerConfigs select _randomIndexMarker;

        _randomIndexGroup = floor random (count _groupConfigs);
        _selectedGroupConfig = _groupConfigs select _randomIndexGroup;

        if (isClass _selectedGroupConfig) then {
            _spawnPosition = getMarkerPos _selectedMarker;
            diag_log format ["確認: マーカー '%1' の位置 = %2", _selectedMarker, _spawnPosition];
            _group = [_spawnPosition, independent, _selectedGroupConfig] call BIS_fnc_spawnGroup;

            diag_log format ["スポーン試行: マーカー = %1, グループ = %2, 結果 = %3", _selectedMarker, getText (_selectedGroupConfig >> "displayName"), _group];

            if (typeName _group == "GROUP") then {
                _totalUnitsSpawned = _totalUnitsSpawned + (count units _group);

                if (count _spawnPosition == 3) then {
                    for "_i" from 1 to 3 do {
                        _wpSentry = _group addWaypoint [_spawnPosition, 20];
                        _wpSentry setWaypointType "SENTRY";
                        _wpSentry setWaypointBehaviour "COMBAT";
                        _wpSentry setWaypointSpeed "NORMAL";
                    };

                    _wpCycle = _group addWaypoint [_spawnPosition, 0];
                    _wpCycle setWaypointType "CYCLE";
                    _wpCycle setWaypointBehaviour "SAFE";
                    _wpCycle setWaypointSpeed "LIMITED";
                } else {
                    diag_log format ["エラー: _spawnPosition の要素数が不正です: %1", _spawnPosition];
                };

                _markerConfigs = _markerConfigs - [_selectedMarker];
            } else {
                diag_log format ["エラー: グループ '%1' のスポーンに失敗しました (グループオブジェクトではありません)。", getText (_selectedGroupConfig >> "displayName")];
            };
        } else {
            diag_log format ["エラー: グループ設定が見つかりません。", _selectedGroupPath];
            diag_log format ["確認: '%1' は有効なコンフィグパスではありません。", getText (_selectedGroupConfig)];
        };
    };
};