/*
    fn_cleanup.sqf
    チェックポイント作戦の全オブジェクトと変数を消去し、リセットする
*/

// サーバーでのみ実行（クライアントから呼ばれたらサーバーに投げ直す）
if (!isServer) exitWith {
    _this remoteExec ["ChDKZ_CheckPoint_fnc_cleanup", 2];
};

// 稼働していない場合は弾く
if (!ChDKZ_CheckPoint_IsRunning) exitWith {
    ["チェックポイント作戦は現在稼働していません。"] remoteExec ["hint", remoteExecutedOwner];
};

["作戦の中断・クリーンアップを開始します..."] remoteExec ["hint", remoteExecutedOwner];

private _objCount = count ChDKZ_CheckPoint_ActiveObjs;
private _grpCount = count ChDKZ_CheckPoint_ActiveGroups;
diag_log format ["[ChDKZ_CP] ----- Cleanup Started. Deleting %1 Objs, %2 Groups -----", _objCount, _grpCount];

// 1. オブジェクト（バンカー、バリケード、車両など）の削除
{
    if (!isNull _x) then {
        deleteVehicle _x;
    };
} forEach ChDKZ_CheckPoint_ActiveObjs;

// 2. AIグループとユニットの削除
{
    private _grp = _x;
    if (!isNull _grp) then {
        // グループ内の全ユニットを削除
        {
            if (!isNull _x) then { deleteVehicle _x; };
        } forEach units _grp;
        
        // 空になったグループ自身を削除
        deleteGroup _grp;
    };
} forEach ChDKZ_CheckPoint_ActiveGroups;

// 3. マーカーの削除
{
    deleteMarker _x;
} forEach ChDKZ_CheckPoint_ActiveMarkers;


// 4. グローバル管理配列の初期化（空にする）
ChDKZ_CheckPoint_ActiveObjs = [];
ChDKZ_CheckPoint_ActiveGroups = [];
ChDKZ_CheckPoint_ActiveMarkers = [];

// 5. 稼働フラグを下ろす
ChDKZ_CheckPoint_IsRunning = false;
publicVariable "ChDKZ_CheckPoint_IsRunning";

diag_log "[ChDKZ_CP] Cleanup Finished successfully.";

["チェックポイントの全オブジェクトを消去し、システムをリセットしました。"] remoteExec ["hint", 0];