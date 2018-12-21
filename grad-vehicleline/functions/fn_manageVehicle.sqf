params ["_vehicle", "_nextSegmentID", "_marker"];

private _nextSegmentBlocked =  missionNamespace getVariable [_nextSegmentID, false];
private _nextPosition = getMarkerPos _marker;

systemChat ("next segment is Blocked:  " + str _nextSegmentBlocked);

if (_nextSegmentBlocked) exitWith {
    [{
        !(missionNamespace getVariable [_this select 1, false])
    }, {
        params ["_vehicle", "", "_nextPosition"];
        systemChat "next segment got free, moving on...";
        _vehicle setDriveOnPath [position _vehicle, _nextPosition];
    },
    [_vehicle, _nextSegmentID, _nextPosition]
    ] call CBA_fnc_waitUntilAndExecute;
};

_vehicle setDriveOnPath [position _vehicle, _nextPosition];
systemChat ("next segment instantly free, going strong: " + str _index);
