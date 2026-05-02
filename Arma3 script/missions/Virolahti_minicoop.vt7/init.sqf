[] execVM "setupMission.sqf";

// --- ここから追記 ---
// ChDKZ_CheckPointのサーバー変数初期化 (サーバーのみで実行)
if (isServer) then {
    [] execVM "scripts\ChDKZ_CheckPoint\init_server.sqf";
};