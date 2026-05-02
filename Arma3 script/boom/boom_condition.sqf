this addEventHandler ["Explosion", {
    params ["_vehicle", "_damage"];
    systemChat "EXPLOSION DETECTED!";
    diag_log "ARMA3 DEBUG: Explosion EH fired!";
    _vehicle setDamage 0.1; 
}];