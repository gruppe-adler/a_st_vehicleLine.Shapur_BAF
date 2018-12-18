private _markers = 
[
    "marker_12",
    "marker_11",
    "marker_10",
    "marker_9",
    "marker_8",
    "marker_7",
    "marker_6",
    "marker_5",
    "marker_4",
    "marker_3",
    "marker_1",
    "marker_0"
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
        private _greenArrows = _greenArrows select _forEachIndex;
        private _redArrows = _redArrows select _forEachIndex;
        private _id = format ["GRAD_vehicleline_active_%1", _forEachIndex];
        private _isActive = missionNamespace getVariable [_id, false];
        private _trespassers = (allUnits + vehicles) inAreaArray _x;

        // systemChat str _isActive;

        if (count _trespassers > 0) then {

            if (!_isActive) then {
                // systemChat "trespasser detected";
                {
                    _x hideObjectGlobal false;
                } forEach _redArrows;

                {
                    _x hideObjectGlobal true;
                } forEach _greenArrows;

                missionNamespace setVariable [_id, true];

            };

            {
                if (!(isPlayer _x)) then {
                        [_x, _forEachIndex, _id, _markers] call GRAD_vehicleline_fnc_manageVehicle;
                };
            } forEach _trespassers;
        } else {

            if (_isActive) then {
                // systemChat "no trespasser detected";
                {
                    _x hideObjectGlobal true;
                } forEach _redArrows;

                {
                    _x hideObjectGlobal false;
                } forEach _greenArrows;

                missionNamespace setVariable [_id, false];
            };
        };
    } forEach _markers;
    
}, 0.1, [_markers, _greenArrows, _redArrows]] call CBA_fnc_addPerFramehandler;

/*
    [] execVM "grad-vehicleline/functions/fn_createSegments.sqf";
*/