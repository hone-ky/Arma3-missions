_trg = createTrigger ["EmptyDetector", _objPS, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "PRESENT", false];
_trg setTriggerStatements ["this", "totalNum = count units east; ", ""];

_trg = createTrigger ["EmptyDetector", _objPS, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "PRESENT", false];
_trg setTriggerStatements ["this", "currentNum = count units east;
if (currentNum < totalNum / 2 ) then [ {_x addWaypoint []
} forEach thislist group east; ]", ""];

#トリガー内のオブジェクトに限定するコードを書く
#トリガー内のオブジェクトのカウントは東側のみに設定する

nBuilding = nearestBuilding position _x;
WPNum = count waypoints _x;
while deleteWaypoint