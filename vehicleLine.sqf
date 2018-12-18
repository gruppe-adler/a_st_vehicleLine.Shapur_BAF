

private _vehicles = nearestObjects [position player, ["LandVehicle"], 1000];

/*
{
  _x forceFollowRoad true;
} forEach _vehicles;
*/

addMissionEventHandler ["Draw3D", {
    drawIcon3D ["", [1,0,0,1], ASLToAGL getPosASL cursorTarget, 0, 0, 0, "Target", 1, 0.05, "PuristaMedium"];
}];

[_vehicles] spawn {
    params ["_vehicles"];
    

    while {true} do {
        {   

            
            private _vehicle = _x;
            private _cone = _vehicle getVariable ["coneCache", objNull];
            if (!(isNull _cone)) then {
                deleteVehicle _cone;
            };
            private _sizeOfVehicle = boundingBoxReal _vehicle;
            private _p1 = _sizeOfVehicle select 0;
            private _p2 = _sizeOfVehicle select 1;
            private _maxLength = abs ((_p2 select 1) - (_p1 select 1));
            private _currentPosition = position _vehicle;
            private _vehicleInFront = 
                if (_forEachIndex < 1) then {
                    objNull
                } else {
                    _vehicles select (_forEachIndex - 1)
                };

            private _positionInFront = 
                if (!(isNull _vehicleInFront)) then {
                    _vehicleInFront getRelPos [_maxLength+0.1,180]
                } else {
                    if (random 5 > 4) then {
                        (_vehicles select 0) getRelPos [_maxLength*3,0]
                    } else {
                        position _vehicle
                    };
                };

            
            private _cone = createSimpleObject ["RoadCone_F", AGLtoASL _positionInFront];
            _vehicle setVariable ["coneCache", _cone];
            

           
            _vehicle limitSpeed 10;
            private _halfDistance = (_currentPosition distance _positionInFront)/2;
            private _inBetween = _vehicle getRelPos [_halfDistance, 0];
            _vehicle setDriveOnPath [_currentPosition, _inBetween, _positionInFront];
            /*private _wp = group _vehicle addWaypoint [_positionInFront, 0];
            _wp setWaypointCompletionRadius 0.5;
            group _vehicle setCurrentWaypoint _wp;
            */

           
            systemChat str (_vehicle distance _positionInFront);

            sleep (random 3);
        } forEach _vehicles;
        
        
        
        
        systemChat "loop";
    };
};

