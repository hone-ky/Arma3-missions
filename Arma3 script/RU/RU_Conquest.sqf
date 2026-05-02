if (isserver) then {
_trigger = getPosATL thistrigger ;

_centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 7000, "none"];
_centerobjPS = getPosASL _centerobj;
_rNumber = random 40 ;
_landLocation = if ( _rNumber > 30 ) then {
    locationPosition nearestLocation [_centerobjPS, "NameCity"];
} else {
    locationPosition nearestLocation [_centerobjPS, "Namevillage"];
};
_landLocation set [2, 0];
_obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 2000, "none"];  
_objPS = getPosATL _obj;
_obj1 = createVehicle ["Land_Cargo_HQ_V1_F", _objPS, [], 500, "none"]; 
_obj1PS = getPosATL _obj1;
_obj2 = createVehicle ["Land_Communication_F", _obj1PS, [], 20, "none"];
_obj2PS = getPosATL _obj2;
_obj3 = createVehicle ["Land_PowerGenerator_F", _obj2PS, [], 5, "none"];
_obj3PS = getPosATL _obj3;

_RU_HQ = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_chq")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _RU_HQ addWaypoint [ _objPS, 50 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _RU_HQ addWaypoint [ getWPPos [_RU_HQ, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";

_rNumber = random 5 ;
for "_i" from 1 to _rNumber - 4 do {
    _hilux = createVehicle ["rhs_btr70_msv", _obj1PS, [], 300];
    _grp = createVehicleCrew _hilux;
    _hiluxPS = getPosATL _hilux;
    _hilux setpos [getPos _hilux select 0, getPos _hilux select 1, (getPos _hilux select 2) +5];
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _obj1PS, 300 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _hiluxPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 5 ;
for "_i" from 0 to _rNumber do {
    _RU_sentry = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_fireteam")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _RU_sentry addWaypoint [ _objPS, 400 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _RU_sentry addWaypoint [ getWPPos [_RU_sentry, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 3 ;
for "_i" from 0 to _rNumber do {
    _RU_QRF = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _RU_QRF addWaypoint [ _objPS, 200 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _RU_QRF addWaypoint [ getWPPos [_RU_QRF, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 5 ;
for "_i" from 1 to _rNumber do {
    _hilux = createVehicle ["rhs_zsu234_aa", _obj1PS, [], 2000];
    _grp = createVehicleCrew _hilux;
    _hiluxPS = getPosATL _hilux;
    _hilux setpos [getPos _hilux select 0, getPos _hilux select 1, (getPos _hilux select 2) +5];
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _obj1PS, 2000 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _hiluxPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 5 ;
for "_i" from 1 to _rNumber do {
    _hilux = createVehicle ["RHS_Mi24Vt_vvsc", _obj1PS, [], 3000];
    _grp = createVehicleCrew _hilux;
    _hiluxPS = getPosATL _hilux;
    _hilux setpos [getPos _hilux select 0, getPos _hilux select 1, (getPos _hilux select 2) +5];
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _obj1PS, 10000 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _hiluxPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 10 ;
for "_i" from 8 to _rNumber do {
    _hilux = createVehicle ["RHS_Ka52_vvsc", _obj1PS, [], 3000];
    _grp = createVehicleCrew _hilux;
    _hiluxPS = getPosATL _hilux;
    _hilux setpos [getPos _hilux select 0, getPos _hilux select 1, (getPos _hilux select 2) +5];
    for "_i" from 1 to 4 do {
        _wp = _grp addWaypoint [ _obj1PS, 10000 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _grp addWaypoint [ _hiluxPS, 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};

_rNumber = random 3 ;
for "_i" from 0 to _rNumber do {
    _centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 4000, "none"];
    _centerobjPS = getPosASL _centerobj;
    _RU_QRF = [_centerobjPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_tv" >> "rhs_group_rus_tv_90" >> "RHS_T90SMPlatoon")] call BIS_fnc_spawnGroup;
for "_i" from 1 to 4 do {
    _wp = _RU_QRF addWaypoint [ _centerobjPS, 4000 ] ;
    _wp setWaypointType "move";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
};
_wp = _RU_QRF addWaypoint [ getWPPos [_RU_QRF, 0], 0];
_wp setWaypointType "cycle";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
};

_rNumber = random 3 ;
for "_i" from 0 to _rNumber do {
    _obj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 4000, "none"];
    _objPS = getPosASL _obj;

    counter = 0 ;

    _rNumber = random 7 ;
    for "_i" from 7 to _rNumber do {
        _RU_HQ = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_chq")] call BIS_fnc_spawnGroup;
        for "_i" from 1 to 4 do {
            _wp = _RU_HQ addWaypoint [ _objPS, 50 ] ;
            _wp setWaypointType "move";
            _wp setWaypointBehaviour "SAFE";
            _wp setWaypointSpeed "LIMITED";
        };
        _wp = _RU_HQ addWaypoint [ getWPPos [_RU_HQ, 0], 0];
        _wp setWaypointType "cycle";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
        counter = counter + 1 ;
    };

    _rNumber = random 5 ;
    for "_i" from 0 to _rNumber do {
        _RU_sentry = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_fireteam")] call BIS_fnc_spawnGroup;
        for "_i" from 1 to 4 do {
            _wp = _RU_sentry addWaypoint [ _objPS, 400 ] ;
            _wp setWaypointType "move";
            _wp setWaypointBehaviour "SAFE";
            _wp setWaypointSpeed "LIMITED";
        }; 
        _wp = _RU_sentry addWaypoint [ getWPPos [_RU_sentry, 0], 0];
        _wp setWaypointType "cycle";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
        counter = counter + 1 ;
    };

    _rNumber = random 3 ;
    for "_i" from 0 to _rNumber do {
        _RU_QRF = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad")] call BIS_fnc_spawnGroup;
        for "_i" from 1 to 4 do {
            _wp = _RU_QRF addWaypoint [ _objPS, 200 ] ;
            _wp setWaypointType "move";
            _wp setWaypointBehaviour "SAFE";
            _wp setWaypointSpeed "LIMITED";
        };
        _wp = _RU_QRF addWaypoint [ getWPPos [_RU_QRF, 0], 0];
        _wp setWaypointType "cycle";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
        counter = counter + 1 ;
    };

    for "_i" from 1 to counter / 2  do {
        _btr = createVehicle ["rhs_btr70_msv", _objPS, [], 300];
        _grp = createVehicleCrew _btr;
        _btrPS = getPosATL _btr;
        _btr setpos [getPos _btr select 0, getPos _btr select 1, (getPos _btr select 2) +5];
        for "_i" from 1 to 4 do {
            _wp = _grp addWaypoint [ _objPS, 300 ] ;
            _wp setWaypointType "move";
            _wp setWaypointBehaviour "SAFE";
            _wp setWaypointSpeed "LIMITED";
        };
        _wp = _grp addWaypoint [ _btrPS, 0];
        _wp setWaypointType "cycle";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
};

_rNumber = random 3 ;
for "_i" from 0 to _rNumber do {
    _centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 4000, "none"];
    _centerobjPS = getPosASL _centerobj;
    _rNumber = random 40 ;
    _landLocation = if ( _rNumber > 30 ) then {
        locationPosition nearestLocation [_centerobjPS, "NameCity"];
    } else {
        locationPosition nearestLocation [_centerobjPS, "Namevillage"];
    };
    _landLocation set [2, 0];
    _obj = createVehicle ["BOX_min_rf_AmmoVeh", _landLocation, [], 100, "none"];  
    _objPS = getPosATL _obj;
    _obj1 = createVehicle ["CamoNet_BLUFOR_open_F", _objPS, [], 0, "none"];  
    _obj1PS = getPosATL _obj1;

    _RU_HQ = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_chq")] call BIS_fnc_spawnGroup;
    for "_i" from 1 to 4 do {
        _wp = _RU_HQ addWaypoint [ _objPS, 50 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _RU_HQ addWaypoint [ getWPPos [_RU_HQ, 0], 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";

    _rNumber = random 2 ;
    for "_i" from 0 to _rNumber do {
        _hilux = createVehicle ["rhs_btr70_msv", _obj1PS, [], 300];
        _grp = createVehicleCrew _hilux;
        _hiluxPS = getPosATL _hilux;
        _hilux setpos [getPos _hilux select 0, getPos _hilux select 1, (getPos _hilux select 2) +5];
        for "_i" from 1 to 4 do {
            _wp = _grp addWaypoint [ _obj1PS, 300 ] ;
            _wp setWaypointType "move";
            _wp setWaypointBehaviour "SAFE";
            _wp setWaypointSpeed "LIMITED";
        };
        _wp = _grp addWaypoint [ _hiluxPS, 0];
        _wp setWaypointType "cycle";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };

    _rNumber = random 5 ;
    for "_i" from 0 to _rNumber do {
        _RU_sentry = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_fireteam")] call BIS_fnc_spawnGroup;
        for "_i" from 1 to 4 do {
            _wp = _RU_sentry addWaypoint [ _objPS, 400 ] ;
            _wp setWaypointType "move";
            _wp setWaypointBehaviour "SAFE";
            _wp setWaypointSpeed "LIMITED";
        };
        _wp = _RU_sentry addWaypoint [ getWPPos [_RU_sentry, 0], 0];
        _wp setWaypointType "cycle";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };

    _rNumber = random 3 ;
    for "_i" from 0 to _rNumber do {
        _RU_QRF = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "rhs_faction_msv" >> "rhs_group_rus_msv_infantry_emr" >> "rhs_group_rus_msv_infantry_emr_squad")] call BIS_fnc_spawnGroup;
        for "_i" from 1 to 4 do {
            _wp = _RU_QRF addWaypoint [ _objPS, 200 ] ;
            _wp setWaypointType "move";
            _wp setWaypointBehaviour "SAFE";
            _wp setWaypointSpeed "LIMITED";
        };
        _wp = _RU_QRF addWaypoint [ getWPPos [_RU_QRF, 0], 0];
        _wp setWaypointType "cycle";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
};

_rNumber = random 3 ;
for "_i" from 0 to _rNumber do {
    _centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 4000, "none"];
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
    _obj = createVehicle ["Land_WaterBottle_01_cap_F", _landLocation, [], 2000, "none"];  
    _objPS = getPosATL _obj;
    _obj1 = createVehicle ["Land_WaterBottle_01_cap_F", _objPS, [], 500, "none"]; 
    _obj1PS = getPosATL _obj1;

    _RU_Guard = [_obj1PS, east, (configfile >> "CfgGroups" >> "East" >> "min_rf" >> "Infantry" >> "min_rf_InfSquad")] call BIS_fnc_spawnGroup;
    for "_i" from 1 to 4 do {
        _wp = _RU_Guard addWaypoint [ _obj1PS, 50 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _RU_Guard addWaypoint [ getWPPos [_RU_Guard, 0], 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";

    _rNumber = random 5 ;
    for "_i" from 5 to _rNumber do {
        _btr70 = createVehicle ["rhs_btr70_msv", _obj1PS, [], 300];
        _grp = createVehicleCrew _btr70;
        _btr70PS = getPosATL _btr70;
        _btr70 setpos [getPos _btr70 select 0, getPos _btr70 select 1, (getPos _btr70 select 2) +5];
        for "_i" from 1 to 4 do {
            _wp = _grp addWaypoint [ _obj1PS, 300 ] ;
            _wp setWaypointType "move";
            _wp setWaypointBehaviour "SAFE";
            _wp setWaypointSpeed "LIMITED";
        };
        _wp = _grp addWaypoint [ _btr70PS, 0];
        _wp setWaypointType "cycle";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };

    _rNumber = random 3 ;
    for "_i" from 0 to _rNumber do {
        _SAM = createVehicle ["O_R_SAM_System_04_F", _obj1PS, [], 30];
        _grp = createVehicleCrew _SAM;
    };

    _Radar = createVehicle ["O_R_Radar_System_02_F", _obj1PS, [], 30];
    _grp = createVehicleCrew _Radar;
};

_rNumber = random 3 ;
for "_i" from 0 to _rNumber do {
    _centerobj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 4000, "none"];
    _centerobjPS = getPosASL _centerobj;
    _rNumber = random 40 ;
    _landLocation = if ( _rNumber > 30 ) then {
        locationPosition nearestLocation [_centerobjPS, "NameCity"];
    } else {
        locationPosition nearestLocation [_centerobjPS, "Namevillage"];
    };
    _landLocation set [2, 0];
    _obj = createVehicle ["CUP_BOX_ChDKZ_AmmoVeh_F", _landLocation, [], 1000, "none"];  
    _objPS = getPosATL _obj;
    _obj1 = createVehicle ["CamoNet_BLUFOR_open_F", _objPS, [], 0, "none"];  
    _obj1PS = getPosATL _obj1;

    _rNumber = random 2 ;
    for "_i" from 0 to _rNumber do {
        _RU_HQ = [_objPS, east, (configfile >> "CfgGroups" >> "East" >> "min_rf" >> "Infantry" >> "min_rf_InfSquad")] call BIS_fnc_spawnGroup;
    for "_i" from 1 to 4 do {
        _wp = _RU_HQ addWaypoint [ _objPS, 50 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
    };
    _wp = _RU_HQ addWaypoint [ getWPPos [_RU_HQ, 0], 0];
    _wp setWaypointType "cycle";
    _wp setWaypointBehaviour "SAFE";
    _wp setWaypointSpeed "LIMITED";
    };

    _rNumber = random 3 ;
    for "_i" from 0 to _rNumber do {
        _ural = createVehicle ["rhs_ural_ammo_msv_01", _objPS, [], 300];
        _grp = createVehicleCrew _ural;
        _uralPS = getPosATL _ural;
        _ural setpos [getPos _ural select 0, getPos _ural select 1, (getPos _ural select 2) +5];
        _wp = _grp addWaypoint [ _obj3PS, 50 ] ;
        _wp setWaypointType "move";
        _wp setWaypointBehaviour "SAFE";
        _wp setWaypointSpeed "LIMITED";
        _wp1 = _grp addWaypoint [ _obj1PS, 50];
        _wp1 setWaypointType "cycle";
        _wp1 setWaypointBehaviour "SAFE";
        _wp1 setWaypointSpeed "LIMITED";
    };

    _location = createLocation ["Invisible", _obj1PS, 10, 10];
    _trg = createTrigger ["EmptyDetector", _trigger, false];
    _trg setTriggerArea [10, 10, 10, false];
    _trg setTriggerActivation ["EAST", "PRESENT", false];
    _trg setTriggerStatements ["this", "{ 
_classname = typeOf _x ;
_x setUnitLoadout _classname ; 
} forEach thislist;", ""];
};

_trg = createTrigger ["EmptyDetector", _trigger, false];
_trg setTriggerArea [12000, 12000, -1, false];
_trg setTriggerActivation ["EAST", "PRESENT", false];
_trg setTriggerStatements ["this && round (time %1) == 1", "{
_ammotruck = locationPosition nearestLocation [getpos _x, 'invisible'];
_WPpos = getWPPos [_x, 1];
_magazinesAmmo = magazinesAmmo [_x, false] ; 
_magazinscount = count _magazinesAmmo ; 
if (_magazinscount <= 2 && str _WPpos != (str _ammotruck) ) then { _x move _ammotruck } ; 
} forEach thislist;", ""];

_obj = createVehicle ["Land_WaterBottle_01_cap_F",_trigger, [], 4000, "none"];
_objPS = getPosASL _obj;
_rNumber = random 5 ;
for "_i" from 0 to _rNumber do {
    mortar = createVehicle ["rhs_D30_msv", _objPS, [], 30];
    _grp = createVehicleCrew mortar;
};
};