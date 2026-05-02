_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",centerobj, [], 8000, "none"];
_centerobjPS = getPosASL _centerobj;
_rNumber = random 40 ;
_landLocation = if ( _rNumber > 30 ) then {
    locationPosition nearestLocation [_centerobjPS, "NameCity"];
} else {
    locationPosition nearestLocation [_centerobjPS, "Namevillage"];
};
_obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 100, "none"];  
_objPS = getPosATL _obj;
_marker = createMarker ["_USER_DEFINED destination", _objPS];
"_USER_DEFINED destination" setMarkerType "hd_unknown";
