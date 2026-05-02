this addEventHandler ["Explosion", {
    params ["_v", "_damage"];
    if (_damage > 0.01) then {
        missionNamespace setVariable ["GO_1", true, true];
        diag_log "ARMA3 DEBUG: Container detected explosion!";
    };
}];

missionNamespace getVariable ["GO_1", false]