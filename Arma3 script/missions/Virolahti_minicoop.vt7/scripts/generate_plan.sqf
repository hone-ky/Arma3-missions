hint "マップで【作戦目標】をクリックしてください";
openMap true;

if (!isNil "hone_map_click_eh") then {
    removeMissionEventHandler ["MapSingleClick", hone_map_click_eh];
    hone_map_click_eh = nil;
};

hone_map_click_eh = addMissionEventHandler ["MapSingleClick", {
    params ["_units", "_pos", "_alt", "_shift"];

    removeMissionEventHandler ["MapSingleClick", hone_map_click_eh];
    hone_map_click_eh = nil;
    openMap false;

    // 設定取得
    private _trans = missionNamespace getVariable ["HONE_Tac_Transport", "GROUND"];
    private _useArmor = missionNamespace getVariable ["HONE_Tac_UseArmor", false];
    private _useCAS = missionNamespace getVariable ["HONE_Tac_UseCAS", false];
    private _obj = missionNamespace getVariable ["HONE_Tac_Objective", "CLEAR"];

    [_pos, _trans, _useArmor, _useCAS, _obj] spawn {
        params ["_targetPos", "_trans", "_useArmor", "_useCAS", "_obj"];
        
        hint "参謀：地形解析中... 稜線と射線遮蔽(Masking)を確認します。";
        uiSleep 1;
        
        // --- 1. CP(基地)の設定 ---
        private _attackDir = random 360; 
        private _baseDist = 3000;
        private _cpPos = _targetPos vectorAdd [(sin (_attackDir+180) * _baseDist), (cos (_attackDir+180) * _baseDist), 0];
        
        if (_trans == "GROUND") then {
            private _roads = _cpPos nearRoads 500;
            if (count _roads > 0) then { _cpPos = getPos (_roads select 0); };
        };

        // --- 2. 降車地点 (Dismount / LZ) ---
        private _dismountPos = [];
        
        // 地形遮蔽チェック
        private _foundMask = false;
        private _scanStartDist = 400; 
        private _scanEndDist = 1500;
        
        if (_trans == "GROUND" && _useArmor) then {
            _scanStartDist = 200; 
            _scanEndDist = 500;
        };
        
        for "_d" from _scanStartDist to _scanEndDist step 50 do {
            private _checkPos = _targetPos vectorAdd [(sin (_attackDir+180) * _d), (cos (_attackDir+180) * _d), 0];
            _checkPos set [2, 1.5];
            private _blocked = terrainIntersect [_targetPos vectorAdd [0,0,1.5], _checkPos];
            
            if (_blocked) then {
                _dismountPos = _checkPos;
                _foundMask = true;
                _dismountPos = _targetPos vectorAdd [(sin (_attackDir+180) * (_d + 50)), (cos (_attackDir+180) * (_d + 50)), 0];
                break;
            };
        };

        if (!_foundMask) then {
            private _defaultDist = if (_trans == "HELI") then { 2000 } else { 800 };
            if (_useArmor) then { _defaultDist = 250; };
            _dismountPos = _targetPos vectorAdd [(sin (_attackDir+180) * _defaultDist), (cos (_attackDir+180) * _defaultDist), 0];
        };

        private _terrainPref = if (_trans == "HELI") then { "(1-forest)*(1-houses)" } else { "(1-seaLevel)" };
        if (_useArmor) then { _terrainPref = "(1-forest)"; };
        
        private _betterDismount = selectBestPlaces [_dismountPos, 100, _terrainPref, 50, 1];
        if (count _betterDismount > 0) then { _dismountPos = (_betterDismount select 0) select 0; };
        
        if (_trans == "GROUND" && !_useArmor) then {
            private _roads = _dismountPos nearRoads 200;
            if (count _roads > 0) then { _dismountPos = getPos (_roads select 0); };
        };

        // --- 3. 攻撃ルート ---
        private _routeIn = [_dismountPos];
        private _wpCount = 0;
        
        if ((_dismountPos distance _targetPos) > 400) then { _wpCount = 2; };
        if (_useArmor) then { _wpCount = 0; };

        if (_wpCount > 0) then {
            private _seg = (_dismountPos distance _targetPos) / (_wpCount + 1);
            private _dir = _dismountPos getDir _targetPos;
            
            for "_i" from 1 to _wpCount do {
                private _ref = _dismountPos vectorAdd [sin _dir * (_seg*_i), cos _dir * (_seg*_i), 0];
                private _best = selectBestPlaces [_ref, 150, "forest+trees", 50, 1];
                if (count _best > 0) then { 
                    _routeIn pushBack ((_best select 0) select 0); 
                } else { 
                    _routeIn pushBack _ref; 
                };
            };
        };
        _routeIn pushBack _targetPos;

        // --- 4. 回収地点 ---
        private _pickupDist = 400;
        if (_trans == "HELI") then { _pickupDist = 600; };
        private _pickupPos = _targetPos vectorAdd [(sin (_attackDir+180) * _pickupDist), (cos (_attackDir+180) * _pickupDist), 0];

        private _prefP = if (_trans == "HELI") then { "(1-forest)*(1-houses)" } else { "(1-seaLevel)" };
        private _betterP = selectBestPlaces [_pickupPos, 150, _prefP, 50, 1];
        if (count _betterP > 0) then { _pickupPos = (_betterP select 0) select 0; };
        
        if (_trans == "GROUND") then {
             private _roads = _pickupPos nearRoads 200;
             if (count _roads > 0) then { _pickupPos = getPos (_roads select 0); };
        };

        // --- 5. 復路ルート ---
        private _routeOut = [_targetPos, _pickupPos, _cpPos];

        // --- 6. 偵察地点 ---
        private _reconPos = [];
        private _reconSearchPos = _targetPos vectorAdd [(sin (_attackDir+180) * 500), (cos (_attackDir+180) * 500), 0];
        private _bestRecon = selectBestPlaces [_reconSearchPos, 300, "hills", 50, 1];
        if (count _bestRecon > 0) then { _reconPos = (_bestRecon select 0) select 0; };

        // --- 7. 送信 ---
        private _mkrID = floor(random 99999);
        private _methodStr = format["%1%2", _trans, if(_foundMask)then{"/地形遮蔽"}else{"/距離確保"}];
        
        [_mkrID, _routeIn, _routeOut, _reconPos, _cpPos, _dismountPos, _pickupPos, _cpPos, _methodStr] remoteExecCall ["hone_fnc_drawTacticalPlan", 0, true];

        // --- 8. タスク ---
        private _tID = format["task_%1", _mkrID];
        private _suppText = [];
        if (_useArmor) then { _suppText pushBack "機甲戦力"; };
        if (_useCAS) then { _suppText pushBack "航空支援"; };
        if (count _suppText == 0) then { _suppText pushBack "なし"; };

        // ★修正点: <br/> を使用
        private _desc = format["目標: %1<br/>輸送: %2<br/>戦術: %3<br/>支援: %4<br/><br/>1. %5へ展開<br/>2. 目標を攻略<br/>3. RVへ後退しCPへ帰還せよ。", 
            _obj, _trans, if(_foundMask)then{"稜線裏からの展開"}else{"標準距離からの展開"}, _suppText joinString " + ", if(_foundMask)then{"遮蔽地点(Masked)"}else{"指定座標"}];
        
        [west, [_tID], [_desc, format["作戦実行: %1", _methodStr], ""], _targetPos, "ASSIGNED", 1, false, "attack"] call BIS_fnc_taskCreate;

        hint "参謀：作戦プランを作成しました。\nマップのマーカーとタスクを確認してください。";
    };
}];