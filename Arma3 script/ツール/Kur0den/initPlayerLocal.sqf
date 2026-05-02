waitUntil {!isNull player};


private _mainAction = [
  "kur0denAceRoleChanger",
  "Ace Role Changer",
  "\a3\ui_f\data\igui\cfg\simpleTasks\types\documents_ca.paa",
  {},
  {true}
] call ace_interact_menu_fnc_createAction;


private _medic = [
  "changeMedicRole",
  "Change Medic Role",
  "\a3\ui_f\data\igui\cfg\actions\heal_ca.paa",
  {
    private _currentRank = player getVariable ["ace_medical_medicClass", 0];
    private _newRank = if (_currentRank >= 2) then { 0 } else { _currentRank + 1 };
    private _newRankText = switch (_newRank) do {
      case 0: {"Not a Medic"};
      case 1: {"a Combat Medic"};
      case 2: {"a Doctor"};
    };
    player setVariable ["ace_medical_medicClass", _newRank, true];
    private _msg = format ["%1 is %2", name player, _newRankText];
    ["RoleChanged", ["Role Updated", _msg]] remoteExec ["BIS_fnc_showNotification", 0];

  },
  {true}
] call ace_interact_menu_fnc_createAction;

private _engineer = [
  "changeEngineerRole",
  "Change Engineer Role",
  "\a3\ui_f\data\igui\cfg\actions\repair_ca.paa",  {
    private _currentRank = player getVariable ["ace_repair_engineer", 0];
    private _newRank = if (_currentRank >= 2) then { 0 } else { _currentRank + 1 };
    private _newRankText = switch (_newRank) do {
      case 0: {"Not an Engineer"};
      case 1: {"an Engineer"};
      case 2: {"an Advanced Engineer"};
    };
    player setVariable ["ace_repair_engineer", _newRank, true];
    private _msg = format ["%1 is %2", name player, _newRankText];
    ["RoleChanged", ["Role Updated", _msg]] remoteExec ["BIS_fnc_showNotification", 0];

  },
  {true}
] call ace_interact_menu_fnc_createAction;


[
  player,
  1,
  ["ACE_SelfActions"],
  _mainAction
] call ace_interact_menu_fnc_addActionToObject;


[
  player,
  1,
  ["ACE_SelfActions", "kur0denAceRoleChanger"],
  _medic
] call ace_interact_menu_fnc_addActionToObject;

[
  player,
  1,
  ["ACE_SelfActions", "kur0denAceRoleChanger"],
  _engineer
] call ace_interact_menu_fnc_addActionToObject;
