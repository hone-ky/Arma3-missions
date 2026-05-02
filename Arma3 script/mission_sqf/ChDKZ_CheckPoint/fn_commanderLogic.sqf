/*
    fn_commanderLogic.sqf
    指揮官の生死監視とパニック・撤退ロジック (ACE3 降伏バグ修正版)
*/
params ["_commander"];

_commander addEventHandler ["Killed", {
    params ["_unit", "_killer", "_instigator", "_useEffects"];

    diag_log format ["[ChDKZ_CP] Commander Killed by %1. Triggering panic phase.", name _killer];

    [_unit] spawn {
        params ["_deadCommander"];

        ["ChDKZの指揮官が排除された！敵部隊が統制を失っている！"] remoteExec ["hint", 0];
        sleep (3 + random 5);

        {
            private _grp = _x;

            if (!isNull _grp && { ({alive _x} count units _grp) > 0 }) then {
                
                while {(count (waypoints _grp)) > 0} do {
                    deleteWaypoint ((waypoints _grp) select 0);
                };
                
                _grp setVariable ["VCM_Disable", true, true]; 

                private _actionRoll = random 100;

                if (_actionRoll < 30) then {
                    // --- 【降伏フェーズ】 ---
                    diag_log format ["[ChDKZ_CP] Group %1 Surrendered.", _grp];
                    {
                        if (alive _x) then {
                            // ★修正: ACEのゾンビ降伏バグを防止するための分岐処理
                            if (isClass (configFile >> "CfgPatches" >> "ace_captives")) then {
                                // ACE3が導入されている場合、ACEの関数でシステム的に降伏させる
                                [_x, true] call ace_captives_fnc_setSurrendered;
                                removeAllWeapons _x; // 念のため武装解除
                            } else {
                                // バニラ環境の場合（フォールバック）
                                _x setCaptive true;
                                removeAllWeapons _x;
                                _x playActionNow "Surrender";
                                _x disableAI "MOVE";
                            };
                        };
                    } forEach units _grp;

                } else {
                    // --- 【撤退・立てこもりフェーズ】 ---
                    private _nearTowns = nearestLocations [getPos _deadCommander, ["NameCity", "NameVillage", "NameLocal"], 2000];
                    
                    if (count _nearTowns > 0) then {
                        private _targetTown = _nearTowns select 0;
                        private _townPos = locationPosition _targetTown;

                        diag_log format ["[ChDKZ_CP] Group %1 retreating to town: %2", _grp, text _targetTown];

                        private _wpMove = _grp addWaypoint [_townPos, 0];
                        _wpMove setWaypointType "MOVE";
                        _wpMove setWaypointSpeed "FULL"; 
                        _wpMove setWaypointBehaviour "AWARE";
                        
                        _wpMove setWaypointStatements ["true", "private _g = group this; private _bldgs = nearestObjects [getPos this, ['House', 'Building'], 150]; if (count _bldgs > 0) then { private _bPosArr = (_bldgs select 0) buildingPos -1; { if (alive _x && _forEachIndex < count _bPosArr) then { _x doMove (_bPosArr select _forEachIndex); _x spawn { waitUntil { sleep 2; unitReady _this || !alive _this }; if (alive _this) then { _this disableAI 'PATH'; _this setUnitPos 'UP'; }; }; }; } forEach units _g; };"];
                    };
                };
            };
        } forEach ChDKZ_CheckPoint_ActiveGroups;
    };
}];