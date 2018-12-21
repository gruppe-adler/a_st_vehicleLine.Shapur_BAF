private _markers =
[
   "marker_0",
   "marker_1",
   "marker_2",
   "marker_3",
   "marker_4",
   "marker_5",
   "marker_6",
   "marker_7",
   "marker_8",
   "marker_9",
   "marker_10",
   "marker_11",
   "marker_12"
];

private _greenArrows = [];
private _redArrows = [];

{
   private _pos = getMarkerPos _x;
   _pos params ["_posX", "_posY"];
   private _sizeY = (getMarkerSize _x) select 0;
   private _sizeX = (getMarkerSize _x) select 1;

   private _aX = _posX - _sizeX;
   private _aY = _posY - _sizeY;
   private _bX = _aX + _sizeX*2;
   private _bY = _aY + _sizeY*2;

   private _posTopLeft = [_aX, _aY, 0];
   private _posTopRight = [_aX, _bY, 0];
   private _posBottomLeft = [_bX, _aY, 0];
   private _posBottomRight = [_bX, _bY, 0];


   private _topleftGreen = "Sign_Arrow_Green_F" createVehicleLocal _posTopLeft;
   private _topRightGreen = "Sign_Arrow_Green_F" createVehicleLocal _posTopRight;
   private _bottomLeftGreen = "Sign_Arrow_Green_F" createVehicleLocal _posBottomLeft;
   private _bottomRightGreen = "Sign_Arrow_Green_F" createVehicleLocal _posBottomRight;

   private _topleftRed = "Sign_Arrow_F" createVehicleLocal _posTopLeft;
   private _topRightRed = "Sign_Arrow_F" createVehicleLocal _posTopRight;
   private _bottomLeftRed = "Sign_Arrow_F" createVehicleLocal _posBottomLeft;
   private _bottomRightRed = "Sign_Arrow_F" createVehicleLocal _posBottomRight;

   _topleftGreen setPos _posTopLeft;
   _topRightGreen setPos _posTopRight;
   _bottomLeftGreen setPos _posBottomLeft;
   _bottomRightGreen setPos _posBottomRight;

   _topleftRed setPos _posTopLeft;
   _topRightRed setPos _posTopRight;
   _bottomLeftRed setPos _posBottomLeft;
   _bottomRightRed setPos _posBottomRight;


   _greenArrows pushBack [_topleftGreen, _topRightGreen, _bottomLeftGreen, _bottomRightGreen];
   _redArrows pushBack [_topleftRed, _topRightRed, _bottomLeftRed, _bottomRightRed];

   {
      private _arrowCluster = _x;
      {
         _x hideObjectGlobal true;
      } forEach _arrowCluster;
   } forEach _redArrows;
} forEach _markers;

[{
   params ["_args", "_handle"];
   _args params ["_markers", "_greenArrows", "_redArrows"];

   {
      private _marker = _x;
      private _nextMarker = _markers select (_forEachIndex -1 max 0);
      if (_marker != _nextMarker) then {
         private _greenArrows = _greenArrows select _forEachIndex;
         private _redArrows = _redArrows select _forEachIndex;
         private _id = format ["GRAD_vehicleline_%1_", _marker];
         private _isActive = missionNamespace getVariable [_id + "active", false];
         private _trespassers = allUnits inAreaArray _marker;
         private _noVehicleInArea = isNull (missionNamespace getVariable [_id + "vehicleInMarker", objNull]);

         if (!_isActive && {_noVehicleInArea}) then {
            private _vehicles = ((getMarkerPos _x) nearEntities [["Car", "Motorcycle", "Truck"], 50]) inAreaArray _marker;
            systemChat str (_vehicles);
            if (count _vehicles > 0) then {
               if (count _vehicles > 1) then {
                  private _vehicle = _vehicles select 0;
                  private _posMarker = getMarkerPos _marker;
                  private _distance = _vehicle distance2D _posMarker;

                  {
                     private _distanceNew = _vehicle distance2D _posMarker;
                     if (_distance < _distanceNew) then {
                        _distance = _distanceNew;
                        _vehicle = _x;
                     };
                  }forEach _vehicles;

                  _vehicles = [_vehicle];
               };

               missionNamespace setVariable [_id + "active", true];
               missionNamespace setVariable [_id + "vehicleInMarker", _vehicles select 0];

               [(_vehicles select 0), (format ["GRAD_vehicleline_%1_active", _nextMarker]), _nextMarker] call GRAD_vehicleline_fnc_manageVehicle;

               [{(count ((_this select 1) inAreaArray (_this select 0)) == 0)}, {missionNamespace getVariable [_this select 3 + "vehicleInMarker", objNull]; systemChat format ["Marker: %1, free.", _this select 0];},[_marker, _vehicles, _id]] call CBA_fnc_waitUntilAndExecute;
               [
               {(count ((_this select 1) inAreaArray (_this select 0)) == 0)},
               {
                  params ["", "", "_redArrows", "_greenArrows"];
                  {
                     _x hideObjectGlobal false;
                  } forEach _redArrows;

                  {
                     _x hideObjectGlobal true;
                  } forEach _greenArrows;

               },
               [_marker, _vehicles, _redArrows, _greenArrows]] call CBA_fnc_waitUntilAndExecute;
            };
         };

         systemChat format ["Marker: %1, isActiv: %2, isNull: %3", _marker, _isActive, _noVehicleInArea];
         if (_isActive && {_noVehicleInArea}) then {
            {
               _x hideObjectGlobal true;
            } forEach _redArrows;

            {
               _x hideObjectGlobal false;
            } forEach _greenArrows;

            missionNamespace setVariable [_id + "active", false];
            missionNamespace setVariable [_id + "vehicleInMarker", objNull];
         };
      };
   } forEach _markers;
}, 1, [_markers, _greenArrows, _redArrows]] call CBA_fnc_addPerFramehandler;
