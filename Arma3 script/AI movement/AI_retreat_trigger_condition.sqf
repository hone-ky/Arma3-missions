if (isNil "opfor_initial_units") then {
    opfor_initial_units = ({side _x == east} count allUnits);
};

_current_opfor_units = ({side _x == east} count allUnits);

_current_opfor_units <= (opfor_initial_units * 0.75)