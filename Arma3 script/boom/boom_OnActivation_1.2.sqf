this addEventHandler ["Explosion", {
    params ["_target", "_damage"];

    if (_damage > 0.01 && !(_target getVariable ["is_dead", false])) then {
        _target setVariable ["is_dead", true];

        [_target, wreck_1] spawn {
            params ["_oldObj", "_wreck"];
            
            systemChat "--- EXPLOSION DETECTED! ---";
            diag_log "ARMA3 DEBUG: Container EH triggered.";

            private _pos = getPosATL _oldObj;
            private _dir = getDir _oldObj;

            "SmallSecondary" createVehicle _pos;
            "SmokeShell" createVehicle _pos;

            sleep 0.05;

            {
                if (_x != _wreck) then {
                    deleteVehicle _x;
                };
            } forEach (nearestObjects [_pos, [], 2]);

            if (!isNull _wreck) then {
                _wreck setDir _dir;
                _wreck setPosATL _pos;
                [_wreck, false] remoteExec ["hideObjectGlobal", 2];
                systemChat "DEBUG: Wreck replaced.";
            };

            [_pos, 2, 300, false, false] remoteExec ["BIS_fnc_fire", 0];
            systemChat "--- DESTRUCTION SUCCESS ---";
        };
    };
}];