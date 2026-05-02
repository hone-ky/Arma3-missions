if (isserver) then {
_retreatPoints = ["retreat_point_1", "retreat_point_2", "retreat_point_3", "retreat_point_4"];

{
    _unit = _x;
    _unitPos = getPos _unit;
    _nearestRetreat = "";
    _minDistance = 999999;

    {
        _retreatPos = getMarkerPos _x;
        _distance = _unitPos distance _retreatPos;
        if (_distance < _minDistance) then {
            _minDistance = _distance;
            _nearestRetreat = _x;
        };
    } forEach _retreatPoints;

    if (_nearestRetreat != "") then {
        _unit doMove (getMarkerPos _nearestRetreat);
    };
} forEach thislist;
};