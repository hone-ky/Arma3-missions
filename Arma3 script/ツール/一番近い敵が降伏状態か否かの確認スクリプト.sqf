// プレイヤー以外の全ユニットから、別陣営かつ生存しているAIを抽出
private _enemies = allUnits select {
    alive _x && 
    {!isPlayer _x} && 
    {side _x != side player}
};

// 対象が存在しない場合の処理
if (_enemies isEqualTo []) exitWith {
    hint "近くに対象となる敵AIが見つかりません。";
};

// プレイヤーから一番近いAIを検索
private _closestAI = _enemies select 0;
private _minDist = player distance _closestAI;

{
    private _dist = player distance _x;
    if (_dist < _minDist) then {
        _minDist = _dist;
        _closestAI = _x;
    };
} forEach _enemies;

// ACE3の降伏状態と手錠状態をチェック
// ※ 変数が設定されていない場合はデフォルトで false を返す
private _isSurrendering = _closestAI getVariable ["ace_captives_isSurrendering", false];
private _isHandcuffed = _closestAI getVariable ["ace_captives_isHandcuffed", false];

// 結果を判定してテキストを作成
private _statusText = "戦闘状態（降伏していません）";

if (_isHandcuffed) then {
    _statusText = "手錠をかけられています（捕虜）";
} else {
    if (_isSurrendering) then {
        _statusText = "降伏状態です（両手を挙げています）";
    };
};

// 距離と名前を取得
private _distText = round (_minDist);
private _nameText = name _closestAI;

// Hintで画面右上に通知
hint format [
    "【最も近い敵AIの情報】\n名前: %1\n距離: %2m\n状態: %3",
    _nameText,
    _distText,
    _statusText
];