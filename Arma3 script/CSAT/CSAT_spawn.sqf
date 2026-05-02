// マップ上のオブジェクトタイプに基づいて戦略的地点を検出する関数
    // 戻り値: 検出された地点の座標の配列
    private _fnc_findStrategicPoints = {
        private _detectedPoints = [];
        private _centerPos = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"); // マップ中心

        diag_log "戦略的地点の自動検出を開始します...";

        // 橋の検出
        diag_log "橋を検索中...";
        private _bridges = nearestObjects [_centerPos, ["Bridge"], _searchRadius];
        {
            if (_x isKindOf "Bridge") then {
                _detectedPoints pushBack (getPos _x);
                diag_log format ["橋を検出: %1", getPos _x];
            };
        } forEach _bridges;

        // 港湾/町中の建物の検出
        diag_log "港湾/町中の建物を検索中...";
        private _urbanBuildingClasses = ["House", "Chapel", "Church", "Lighthouse", "FuelStation", "Factory", "Tower"];
        private _urbanBuildings = nearestObjects [_centerPos, _urbanBuildingClasses, _searchRadius];
        {
            private _objPos = getPos _x;
            // 港湾エリアの建物や、町中の主要な建物を優先
            private _nearestSupportResult = ([worldName, _objPos]) call BIS_fnc_nearestSupport; // ここを修正！
            if (("Dock" in getText (configFile >> "CfgVehicles" >> typeOf _x >> "scope")) ||
                ("Port" in getText (configFile >> "CfgVehicles" >> typeOf _x >> "scope")) ||
                (_nearestSupportResult isEqualType "") // 修正された変数を使用
            ) then {
                _detectedPoints pushBack _objPos;
                diag_log format ["主要な建物を検出: %1", _objPos];
            };
        } forEach _urbanBuildings;

        // 町が望める丘の上の検出 (簡易的なアプローチ)
        diag_log "丘の上の戦略的地点を検索中...";
        private _mapGridSize = (worldSize select 0) / 10; // マップグリッドを簡易的に分割
        for "_x" from 0 to (_mapGridSize - 1) do {
            for "_y" from 0 to (_mapGridSize - 1) do {
                private _checkPos = [(_x * 1000) + random 1000, (_y * 1000) + random 1000, 0];
                _checkPos set [2, (getTerrainHeightASL _checkPos) + 5];

                private _avgHeight = (getTerrainHeightASL _checkPos);
                // 周囲の平均高度を計算 (修正箇所)
                private _heights = [];
                {_heights pushBack (getTerrainHeightASL _x);} forEach _samplePoints;
                _avgHeight = _avgHeight + (call BIS_fnc_average _heights);

                if (((getTerrainHeightASL _checkPos) - _avgHeight) > _minHillHeightDifference) then {
                    private _nearbyBuildings = nearestObjects [_checkPos, ["House"], 500];
                    if !(_nearbyBuildings isEqualTo []) then {
                        _detectedPoints pushBack _checkPos;
                        diag_log format ["丘の上の地点を検出 (町に近い): %1", _checkPos];
                    };
                };
            };
        };

        // 重複する地点を削除 (近い地点はまとめる)
        private _uniquePoints = [];
        {
            private _isUnique = true;
            private _currentPoint = _x;
            {
                if ((_currentPoint distance _x) < 200) then {
                    _isUnique = false;
                    break; // 最適化: 見つかったらループを抜ける
                };
            } forEach _uniquePoints;
            if (_isUnique) then {
                _uniquePoints pushBack _currentPoint;
            };
        } forEach _detectedPoints;

        diag_log format ["検出された戦略的地点の総数: %1", count _uniquePoints];
        _uniquePoints
    };