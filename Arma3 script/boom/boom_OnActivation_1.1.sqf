[thisTrigger, wreck_1, target_container_1] spawn {
    params ["_trig", "_wreck", "_container"];
    _pos = getPosATL _container;
    _dir = getDir _container;  

    systemChat "--- SENSOR DETECTED EXPLOSION ---";

    "SmallSecondary" createVehicle _pos;
    "SmokeShell" createVehicle _pos;

    _nearObjs = nearestObjects [_pos, ["All"], 2];
    {
        if (!isPlayer _x && _x != _wreck && _x != _trig) then {
            deleteVehicle _x;
        };
    } forEach _nearObjs;

    if (!isNull _wreck) then {
        _wreck setDir _dir;    
        _wreck setPosATL _pos;
        [_wreck, false] remoteExec ["hideObjectGlobal", 2];
    };

    [_pos, 2, 300, false, false] remoteExec ["BIS_fnc_fire", 0];
    systemChat "--- ALL TARGETS CLEARED ---";
};