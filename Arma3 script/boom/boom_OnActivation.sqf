[thisTrigger, wreck_1] spawn {
    params ["_trig", "_wreck"];
    
    diag_log "--- ARMA3 DEBUG: Destruction Process Started ---";
    _pos = getPosATL _trig;
    
    _targets = nearestObjects [_pos, ["AllVehicles", "House", "Thing"], 5];

    _dir = 0;
    {
        if (_x isKindOf "Container" || _x isKindOf "Thing") exitWith { _dir = getDir _x; };
    } forEach _targets;

    "SmallSecondary" createVehicle _pos;
    _dust = "ParticleSmokeWhite01_24metres" createVehicle _pos;
    diag_log "ARMA3 DEBUG: Visual effects created.";

    sleep 0.2;

    if (!isNil "_wreck" && {!isNull _wreck}) then {
        _wreck setDir _dir;
        _wreck setPosATL _pos;
        [_wreck, false] remoteExec ["hideObjectGlobal", 2];
        diag_log format ["ARMA3 DEBUG: Moved %1 to %2", vehicleVarName _wreck, _pos];
    } else {
        diag_log "ARMA3 DEBUG: ERROR - Wreck object not found!";
    };

    {
        if (_x != _wreck) then {
            deleteVehicle _x;
        };
    } forEach _targets;
    diag_log "ARMA3 DEBUG: Original container and contents deleted.";

    [_pos, 2, 300, false, false] remoteExec ["BIS_fnc_fire", 0];
    [_dust] spawn { sleep 10; deleteVehicle (_this select 0); };
    
    diag_log "--- ARMA3 DEBUG: Destruction Process Finished ---";
};