if (isNil "bluforGroupsWithRetreatLogic")) then {
    bluforGroupsWithRetreatLogic = [];
};
if (isNil "opforGroupsWithRetreatLogic")) then {
    opforGroupsWithRetreatLogic = [];
};

_bluforSupplyPointMarkerName = "supplyPoint_blufor";
_opforSupplyPointMarkerName = "supplyPoint_opfor";

_handleGroupRetreat = {
    params ["_group", "_supplyPointMarkerName"];
    _allUnits = units _group;
    _initialCount = count _allUnits;

    _mainWeaponMagazineCount = {
        params ["_unit"];
        _mainWeapon = primaryWeapon _unit;
        if (_mainWeapon != "") then {
            _magazines = magazines _unit;
            _mainWeaponMagazines = _magazines select { _x isKindOf _mainWeapon };
            count _mainWeaponMagazines;
        } else {
            0;
        };
    };

    _isRetreating = false;

    while {alive _group && !_isRetreating} do {
        _currentCount = count (units _group);

        _healthyUnits = _allUnits select {
            alive _x &&
            !(_x getVariable ["BIS_fnc_medical_isUnconscious", false]) &&
            (_x getVariable ["ace_medical_status", ""] != "UNCONSCIOUS")
        };
        _healthyCount = count _healthyUnits;

        _lowAmmo = { (_x call _mainWeaponMagazineCount ) <= 1 } count units _group > 0;

        if (_currentCount <= floor (_initialCount * (2/3)) || _healthyCount <= floor (_initialCount * 0.5) || _lowAmmo) then {
            _isRetreating = true;
            diag_Log format ["分隊 '%1' は撤退を開始します。生存者数: %2/%3, 負傷者なし: %4/%3, 残弾数わずか: %5", groupId _group, _currentCount, _initialCount, _healthyCount, _lowAmmo];

            _supplyPointMarkers = allMissionObjects _supplyPointMarkerName;
            if (count _supplyPointMarkers > 0) then {
                _supplyPointMarker = selectRandom _supplyPointMarkers;
                _supplyPointPos = getMarkerPos _supplyPointMarker;
                {
                    _x doMove _supplyPointPos;
                    _x setSpeedMode "FULL";
                } forEach units _group;

                waitUntil {
                    _currentUnits = units _group;
                    ({ _x distance _supplyPointPos < 5 } count _currentUnits == count _currentUnits) || !alive _group;
                };

                if (alive _group) then {
                    diag_Log format ["分隊 '%1' は補給地点に到着しました。", groupId _group];
                };
            } else {
                diag_Log format ["Error: 補給地点マーカー '%1' が見つかりません。", _supplyPointMarkerName];
                _isRetreating = true;
            };
        };

        sleep 5;
    };

    diag_Log format ["分隊 '%1' の撤退スクリプトを終了します。", groupId _group];
};

{
    _group = _x;
    if (side _group == west && _group in bluforGroupsWithRetreatLogic) then {
        [_group, _bluforSupplyPointMarkerName] spawn _handleGroupRetreat;
    };
} forEach allGroups;

{
    _group = _x;
    if (side _group == east && _group in opforGroupsWithRetreatLogic) then {
        [_group, _opforSupplyPointMarkerName] spawn _handleGroupRetreat;
    };
} forEach allGroups;

if (isServer) then {
    {
        if (side _x == west) then {
            bluforGroupsWithRetreatLogic pushBackUnique group _x;
        } else if (side _x == east) then {
            opforGroupsWithRetreatLogic pushBackUnique group _x;
        };
    } forEach allUnits;
};