if (isserver) then {

    _vehicleConfigs = [
        "Box_T_East_Ammo_F",
        "Box_T_East_Wps_F",
        "O_T_CargoNet_01_ammo_F",
        "Box_T_East_Equip_F",
        "Box_T_East_AmmoOrd_F",
        "Box_T_East_Grenades_F",
        "Box_T_East_WpsLaunch_F",
        "Box_T_East_WpsSpecial_F",
        "O_T_supplyCrate_F",
        "Box_T_East_Support_F",
        "Box_T_East_Uniforms_F"
    ];

    _markerConfigs = [
        "marker_0",
        "marker_1",
        "marker_10",
        "marker_11",
        "marker_12",
        "marker_13",
        "marker_2",
        "marker_3",
        "marker_4",
        "marker_5",
        "marker_6",
        "marker_7",
        "marker_8",
        "marker_9"
    ];

    _specialVehicles = ["O_T_CargoNet_01_ammo_F", "O_T_supplyCrate_F"];
    _normalVehicles = _vehicleConfigs - _specialVehicles;

    {
        _markerName = _x;
        _spawnPosition = getMarkerPos _markerName;

        if (random 1 > 0.33) then { 
            private _selectedVehicleType = "";

            if (random 1 < 0.25) then { 
                _selectedVehicleType = selectRandom _specialVehicles;
            } else { 
                _selectedVehicleType = selectRandom _normalVehicles;
            };

            if (_spawnPosition isNotEqualTo [0,0,0]) then { 
                _spawnedObject = createVehicle [_selectedVehicleType, _spawnPosition, [], 0, "CAN_COLLIDE"];
                _spawnedObject setDir (random 360); 

                diag_log format ["INFO: マーカー '%1' の位置 '%2' にオブジェクト '%3' をスポーンしました。", _markerName, _spawnPosition, _selectedVehicleType];
            } else {
                diag_log format ["WARNING: マーカー '%1' の位置が取得できませんでした。スポーンをスキップします。", _markerName];
            };
        } else {
            diag_log format ["INFO: マーカー '%1' にはオブジェクトをスポーンしませんでした (3分の1の確率)。", _markerName];
        };
    } forEach _markerConfigs;
};