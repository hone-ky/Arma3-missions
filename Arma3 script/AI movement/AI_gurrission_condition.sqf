private _triggerArea = thisTrigger;
if (isNil {_triggerArea getVariable "initialEastCount"}) then {
    private _eastUnitsInArea = _triggerArea nearEntities ["East", 500];
    private _initialCount = count _eastUnitsInArea;
    _triggerArea setVariable ["initialEastCount", _initialCount];
    _triggerArea setVariable ["triggeredOnce", false];
    diag_log format ["LAMBS: Initial East Count set to: %1", _initialCount];
};

private _currentEastUnitsInArea = _triggerArea nearEntities ["East", 500];
private _currentCount = count _currentEastUnitsInArea;
private _initialCount = _triggerArea getVariable "initialEastCount";
private _triggeredOnce = _triggerArea getVariable "triggeredOnce";

_currentCount <= (_initialCount * 0.5) && !_triggeredOnce