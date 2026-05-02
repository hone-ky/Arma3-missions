if (isserver) then {
_trigger6 = getPosATL thistrigger ;
_centerobj = createVehicle ["RU_WarfareBVehicleServicePoint",_trigger6, [], 5000, "none"];
_objPS = getPosATL _centerobj;
}