if (isserver) then {
    _spawner = Mafaraz_spawner;

    if (isNil "_spawner" || isNull _spawner) then {
        diag_log "エラー: Mafaraz_spawner が存在しないか、オブジェクトではありません。";
        return;
    };

    _spawnerPos = getPosATL _spawner;
    diag_log format ["確認: _spawnerPos (getPosATL直後) = %1", _spawnerPos];

    if (count _spawnerPos != 3) then {
        diag_log format ["エラー: _spawner の位置情報が不正です (要素数): %1", _spawnerPos];
        return;
    };

    _spawnRadius = 250;

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

    _totalUnitsSpawned = 0;
    _targetUnitCount = 60;

    while {_totalUnitsSpawned < _targetUnitCount} do {
        _randomIndexGroup = floor random (count _groupConfigs);
        _selectedGroupConfig = _groupConfigs select _randomIndexGroup;

        if (isClass _selectedGroupConfig) then {
            if (!isClass _selectedGroupConfig) then {
                diag_log format ["エラー: 無効なグループコンフィグが選択されました: %1", _selectedGroupConfig];
                continue;
            };

            _randomAngle = random 360;
            _randomDistance = _spawnRadius * sqrt random 1;
            _spawnOffsetX = _randomDistance * cos _randomAngle;
            _spawnOffsetY = _randomDistance * sin _randomAngle;

            diag_log format ["確認: _spawnerPos (計算直前) = %1", _spawnerPos];

            _spawnPosition = [(_spawnerPos select 0) + _spawnOffsetX, (_spawnerPos select 1) + _spawnOffsetY, _spawnerPos select 2];

            diag_log format ["確認: スポーン位置 = %1", _spawnPosition];
            _group = [_spawnPosition, independent, _selectedGroupConfig] call BIS_fnc_spawnGroup;

            diag_log format ["スポーン試行: グループコンフィグ = %1, 結果 = %2 (Type: %3)", getText _selectedGroupConfig, _group, typeName _group];

            if (typeName _group == "GROUP") then {
                _totalUnitsSpawned = _totalUnitsSpawned + (count units _group);

                if (count _spawnPosition == 3) then {
                    for "_i" from 1 to 3 do {
                        _wpSentry = _group addWaypoint [_spawnerPos, 250];
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
            } else {
                diag_log format ["エラー: グループ '%1' のスポーンに失敗しました (グループオブジェクトではありません)。結果: %2", getText (_selectedGroupConfig >> "displayName"), _group];
            };
        } else {
            diag_log format ["エラー: グループ設定が見つかりません。", _selectedGroupConfig];
        };
    };
};