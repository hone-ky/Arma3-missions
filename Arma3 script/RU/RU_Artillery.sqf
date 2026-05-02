_trigger = getPosATL thistrigger ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 8000, "none"];
_centerobjPS = getPosASL _centerobj;
_rNumber = random 40 ;
_landLocation = if ( _rNumber > 30 ) then {
    locationPosition nearestLocation [_centerobjPS, "NameCity"];
} else {
    if ( _rNumber > 15 ) then {
        locationPosition nearestLocation [_centerobjPS, "Namevillage"];
    } else {
        locationPosition nearestLocation [_centerobjPS, "Namelocal"];
    };
};
_landLocation set [2, 0];
_obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 1500, "none"];  
_objPS = getPosATL _obj;

_rNumber = random 5 ;
for "_i" from 0 to _rNumber do {
    mortar = createVehicle ["rhs_2b14_82mm_msv", _objPS, [], 30];
    _grp = createVehicleCrew mortar;
};

_trg = createTrigger ["EmptyDetector", _landlocation, false];
_trg setTriggerArea [3000, 3000, -1, false];
_trg setTriggerActivation ["WEST", "PRESENT", false];
_trg setTriggerStatements ["this", "_marker = getMarkerPos 'beketov4'; 
_target = createVehicle ['Land_WaterBottle_01_cap_F', _marker, [], 200, 'none'];
_targetPS = getPosATL _target;
{
    _veh = vehicle _x;
    if ((_veh isKindOf 'rhs_2b14_82mm_msv') == true) then {
    _veh commandArtilleryFire [ _targetPS, currentMagazine _veh, 10]; };
} forEach thislist;", ""];

_marker = createMarker ["beketov4", _landLocation];
"beketov4" setMarkerType "hd_objective";
_trg = createTrigger ["EmptyDetector", _objPS, false];
_trg setTriggerArea [1000, 1000, -1, false];
_trg setTriggerActivation ["EAST", "NOT PRESENT", false];
_trg setTriggerStatements ["this", "deleteMarker 'beketov4';", ""];

_trigger = getPosATL thistrigger ;
_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 12000, "none"];
_centerobjPS = getPosASL _centerobj;
_rNumber = random 40 ;
_landLocation = if ( _rNumber > 30 ) then {
    locationPosition nearestLocation [_centerobjPS, "NameCity"];
} else {
    if ( _rNumber > 15 ) then {
        locationPosition nearestLocation [_centerobjPS, "Namevillage"];
    } else {
        locationPosition nearestLocation [_centerobjPS, "Namelocal"];
    };
};
_landLocation set [2, 0];
_target = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 200, "none"];
_targetPS = getPosATL _target;
{
    _veh = vehicle _x;
    if ((_veh isKindOf "rhs_D30_msv") == true) then {
    _veh setVehicleAmmo 1;
    _veh commandArtilleryFire [ getPosASL _targetPS, currentMagazine _veh, 10]; };
    hint str _veh;
} forEach units east;


if (isServer) then {
{
    _targets = _x targets [true, 1000, [ west ]];
} forEach units east;
_targets = _targets select 1;

{
    _veh = vehicle _x;
    if ((_veh isKindOf "rhs_D30_msv") == true) then {
    _veh setVehicleAmmo 1;
    _veh commandArtilleryFire [ getPosASL _targets, currentMagazine _veh, 10]; };
} forEach units east;
};



{
    _targets = _x targets [true, 1000, [ west ]];
} forEach thislist;
_targets = _targets select 1;
_targetPS = getPosASL _targets;
_grp = group _x;
_WPpos = getWPPos [_x, 1];

{
    if ((_x isKindOf "tank") == true && str _WPpos != str _targetPS) then {
    _wp = _grp addWaypoint [ _targetPS, 0 ] ;
    _wp setWaypointType "move"; };
} forEach units east;