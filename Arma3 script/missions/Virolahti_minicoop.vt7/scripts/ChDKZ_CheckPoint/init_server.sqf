// サーバーでのみ実行
if (!isServer) exitWith {};

// ミッションで生成されたものを一元管理するためのグローバル配列
ChDKZ_CheckPoint_ActiveObjs = [];
ChDKZ_CheckPoint_ActiveGroups = [];
ChDKZ_CheckPoint_ActiveMarkers = [];

// ミッションの多重起動を防止するフラグ
ChDKZ_CheckPoint_IsRunning = false;
publicVariable "ChDKZ_CheckPoint_IsRunning";