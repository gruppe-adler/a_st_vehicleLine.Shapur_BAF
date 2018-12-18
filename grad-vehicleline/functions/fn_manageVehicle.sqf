params ["_vehicle", "_index", "_id", "_markers"];

private _maxCount = count _markers;

// reached end of line, go for it
/*
if (_index == _maxCount) exitWith {
    _vehicle doFollow leader group _vehicle;
};
*/

private _nextIndex = _index + 1;
private _nextSegmentID = format ["GRAD_vehicleline_active_%1", _nextIndex];
private _nextSegmentBlocked =  missionNamespace getVariable [_nextSegmentID, false];
private _nextPosition = getMarkerPos (_markers select _nextIndex);

systemChat ("moving from " + str _index + " to " + str _nextIndex);
systemChat ("next segment is " + str _nextSegmentBlocked);

if (_nextSegmentBlocked) exitWith {
    [{
        params ["_vehicle", "_nextSegmentID", "_nextPosition"];
        !(missionNamespace getVariable [_nextSegmentID, false])
    }, {
        params ["_vehicle", "_nextSegmentID", "_nextPosition"];
        systemChat "next segment got free, moving on...";
        _vehicle setDriveOnPath [position _vehicle, _nextPosition];
    },
    [_vehicle, _nextSegmentID, _nextPosition]
    ] call CBA_fnc_waitUntilAndExecute;
};

_vehicle setDriveOnPath [position _vehicle, _nextPosition];
systemChat ("next segment instantly free, going strong: " + str _index);