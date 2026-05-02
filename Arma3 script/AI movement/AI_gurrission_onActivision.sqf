private _triggerArea = thisTrigger;
private _initialCount = _triggerArea getVariable "initialEastCount";
private _currentEastUnitsInArea = _triggerArea nearEntities ["East", 500];
private _currentCount = count _currentEastUnitsInArea;

diag_log format ["LAMBS: Trigger Activated! Initial: %1, Current: %2", _initialCount, _currentCount];

_triggerArea setVariable ["triggeredOnce", true];

{
    private _unit = _x;
    if (alive _unit && side _unit == east) then {
        private _lambsModule = nearestObjects [getPos _unit, ["LAMBS_Danger_Waypoint_Module"], 100] select 0;

        if (isNil "_lambsModule") then {
            diag_log "LAMBS: LAMBS Danger Waypoint Module not found near unit!";
        } else {
            private _buildings = nearestObjects [getPos _unit, ["House"], 200];
            private _targetBuilding = objNull;
            if (count _buildings > 0) then {
                _targetBuilding = _buildings select 0;
                diag_log format ["LAMBS: Found building for unit %1: %2", _unit, _targetBuilding];
            } else {
                diag_log format ["LAMBS: No suitable building found for unit %1, LAMBS module will use default behavior.", _unit];
            };
            if (!isNull _targetBuilding) then {
                [_unit, _targetBuilding, "LAMBS_Danger_StaticDefense"] call LAMBS_Danger_fnc_createDangerWaypoint;
                diag_log format ["LAMBS: %1 ordered to defend building %2", _unit, _targetBuilding];
            } else {
                [_unit, getPos _unit, "LAMBS_Danger_Defend"] call LAMBS_Danger_fnc_createDangerWaypoint;
                diag_log format ["LAMBS: %1 ordered to defend current position (no building found)", _unit];
            };
        };
    };
} forEach _currentEastUnitsInArea;