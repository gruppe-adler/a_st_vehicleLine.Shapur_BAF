

private _vehicles = nearestObjects [position player, ["LandVehicle"], 1000];


{
  _x forceFollowRoad true;
  _x setConvoySeparation 1;
} forEach _vehicles;


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
            private _positionInFront = _vehicle getRelPos [_maxLength*2,0]; 
            

            
            private _cone = createSimpleObject ["RoadCone_F", AGLtoASL _positionInFront];
            _vehicle setVariable ["coneCache", _cone];
           
            _vehicle limitSpeed 10;
            _vehicle doMove _positionInFront;
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

