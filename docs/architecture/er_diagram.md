# 製造業データモデル 設計図 (Target ER Diagram)

将来的に目指す完成想定図（Target State）のER図です。
ここに記載されたモデルを元に、要件定義とDBMLへの変換を進めていきます。

```mermaid
erDiagram
%% 製造業データモデル ER図 - Version 2.0 (Item & BOM Integrated)

%% -------------------- I. 基礎・取引先マスタ --------------------
"品目マスタ" {
    INT 品目_ID PK "連番 内部キー"
    VARCHAR 品目_コード "業務コード (旧商品/品番)" 
    VARCHAR 品目名 "総称（基材/完成品/購入品/内製中間材など）"
    INT 品目区分 "1:受託基材, 2:完成品, 3:購入セット品, 4:購入原材料, 5:内製中間材 等"
    VARCHAR メーカー名 "購入品の場合の製造元メーカー"
    VARCHAR 在庫単位 "在庫/消費/出荷管理単位"
    BOOLEAN ロット管理対象 "Trueの場合 ロット管理"
}

"工程マスタ" {
    INT 工程_ID PK "連番 内部キー"
    INT 工程_コード "業務コード"
    VARCHAR 工程名
}

"スキルマスタ" {
    INT スキル_ID PK "連番 内部キー"
    VARCHAR スキル_コード "業務コード"
    VARCHAR スキル名
}

"BusinessPartner (取引先マスタ)" {
    INT id PK "business_partners"
    VARCHAR partner_code "取引先コード (業務コード)"
    VARCHAR name "会社名"
    BOOLEAN is_customer "顧客フラグ (受注元)"
    BOOLEAN is_supplier "仕入先フラグ (発注元)"
    BOOLEAN is_manufacturer "メーカーフラグ (製造元)"
    DATETIME discarded_at "論理削除"
}

"DeliveryDestination (納入先マスタ)" {
    INT id PK "delivery_destinations"
    INT business_partner_id FK "BusinessPartner参照"
    VARCHAR destination_code "納入先コード (業務コード)"
    VARCHAR name "拠点名 (例: 物流センター、代理店倉庫)"
    VARCHAR zip_code "郵便番号"
    VARCHAR address "物理的な配送先住所"
    VARCHAR phone_number "電話番号"
    VARCHAR contact_person "担当者名"
    DATETIME discarded_at "論理削除"
}


"ロケーションマスタ" {
    INT id PK
    INT 拠点ID FK "所属拠点"
    VARCHAR 場所コード "場所コード (例: W001-S01-A)"
    VARCHAR 場所名 "場所名 (例: 倉庫A-棚B1)"
    DATETIME 廃止日時 "discarded_at"
}


"技術情報マスタ" {
    INT 技術_ID PK "連番 内部キー"
    VARCHAR 品目_コード FK "業務コード"
    VARCHAR 推奨保管温度
    VARCHAR 危険物区分
    INT 消費有効期限
}

"品目構成マスタ (ItemBOM)" {
    INT 構成_ID PK "連番 内部キー"
    VARCHAR 親品目_コード FK "品目マスタを参照 (作られるもの)"
    VARCHAR 子品目_コード FK "品目マスタを参照 (消費されるもの)"
    INT 工程_コード FK "消費が発生する工程"
    DECIMAL 標準消費量 "標準消費数量"
    DECIMAL 歩留率
    DATE 有効開始日
    DATE 有効終了日 "NULLなら現行"
}

%% -------------------- II. 品質基準マスタ --------------------

"検査項目マスタ" {
    INT 検査項目_ID PK "連番 内部キー"
    VARCHAR 検査項目_コード "業務コード"
    VARCHAR 検査項目名
    VARCHAR 検査単位
}

"標準検査基準マスタ" {
    INT 標準検査基準ID PK "連番 内部キー"
    VARCHAR 品目_コード FK "品目マスタを参照"
    INT 工程_コード FK
    VARCHAR 検査項目_コード FK
    VARCHAR 品質グレード "品質等級"
    DECIMAL 基準値_最小
    DECIMAL 基準値_最大
}

"個別検査基準マスタ" {
    INT 個別検査基準ID PK "連番 内部キー"
    VARCHAR partner_code FK "BusinessPartner参照"
    VARCHAR 品目_コード FK "品目マスタを参照"
    VARCHAR 検査項目_コード FK
    VARCHAR 品質グレード "品質等級"
    DECIMAL 基準値_最小
    DECIMAL 基準値_最大
}

%% -------------------- III. ユーザー・組織・履歴管理 (HR & Organization) --------------------

"ユーザーマスタ" {
    INT id PK "users: 個人情報"
    VARCHAR ユーザー_コード "ログインID"
    VARCHAR 名前 "氏名"
    VARCHAR 暗号化パスワード "password_digest"
    DATETIME 廃止日付 "discarded_at"
}

"組織権限マスタ" {
    INT id PK "org_unit_permissions: 権限定義"
    INT 組織単位ID FK "org_unit_id"
    INT 権限種別 "permission: 0=admin, 1=user_mgmt..."
}

"拠点マスタ" {
    INT id PK "facilities: 営業拠点・拠点"
    VARCHAR 拠点コード "コード"
    VARCHAR 拠点名 "名称"
    VARCHAR 住所 "住所"
    DATETIME 廃止日時 "discarded_at"
}

"組織単位マスタ" {
    INT id PK "org_units: 部・課・PJ等"
    INT 親組織ID FK "parent_id (階層)"
    VARCHAR 組織コード "コード"
    VARCHAR 組織名 "名称"
    INT 組織種別 "0:部署, 1:PJ, 2:委員会"
    DATETIME 廃止日時 "discarded_at"
}

"配属辞令履歴" {
    INT id PK "assignments: 人事履歴"
    INT ユーザーID FK "user_id"
    INT 拠点ID FK "facility_id"
    INT 組織単位ID FK "org_unit_id"
    VARCHAR 役職名 "job_title (肩書き)"
    INT 配属役職区分 "role: 0=作業員, 1=管理者等（配属先での役割）"
    BOOLEAN 主属フラグ "is_primary (メイン所属)"
    DATE 開始日 "start_date"
    DATE 終了日 "end_date"
}

"セッションマスタ" {
    INT id PK "sessions: 認証管理"
    INT ユーザーID FK
    VARCHAR IPアドレス
    VARCHAR ユーザーエージェント
    DATETIME 作成日時
}

"ユーザースキル関連" {
    INT id PK
    INT ユーザーID FK
    INT SKILL_ID FK
}

"人員賃率データ" {
    INT id PK
    INT ユーザーID FK
    DECIMAL 標準賃率 "標準賃率"
    DATE 開始日
    DATE 終了日
}

"設備会計マスタ" {
    INT 会計_ID PK "連番 内部キー"
    VARCHAR ユーザー_コード FK "ユーザーマスタを参照"
    DECIMAL 取得価額
    DECIMAL 設備費率
    VARCHAR 償却方法
}

%% -------------------- IV. 仕入・在庫管理トランザクション --------------------

"仕入見積データ" {
    INT 見積_ID PK "連番 内部キー"
    INT 見積_コード "業務コード"
    VARCHAR 品目_コード FK "品目マスタを参照"
    VARCHAR partner_code FK "仕入先BusinessPartner参照"
    DECIMAL 見積単価
    VARCHAR 発注単位 "購入単位 (例: 缶, パレット)"
    DECIMAL 入目数量 "1発注単位あたりの内容量 (例: 15)"
    VARCHAR 入目単位 "内容量の単位 (例: kg)"
    DECIMAL 換算係数 "発注単位から在庫単位への換算係数"
    DATE 有効開始日
    DATE 有効終了日
}

"発注データ" {
    INT 発注_ID PK "連番 内部キー"
    INT 発注_コード "業務コード"
    DATE 発注日
    VARCHAR partner_code FK "仕入先BusinessPartner参照"
    VARCHAR delivery_destination_id FK "納入先DeliveryDestinationまたは自社拠点参照"
}

"発注明細データ" {
    INT 発注明細_ID PK "連番 内部キー"
    INT 発注_コード FK "業務コード"
    VARCHAR 品目_コード FK "品目マスタを参照"
    INT 見積_コード FK "適用される見積データ"
    DECIMAL 発注数量 "発注単位での数量"
    DATE 希望納期 "対象資材の希望納品日"
    DATE 納期回答 "仕入先からの確定および回答納期"
}

"入荷データ" {
    INT 入荷_ID PK "連番 内部キー"
    INT 入荷_コード "業務コード"
    DATETIME 入荷処理日時
    VARCHAR 納品書No
}

"入荷明細データ" {
    INT 入荷明細_ID PK "連番 内部キー"
    INT 入荷_コード FK "業務コード"
    INT 発注明細_コード FK "業務コード"
    DATETIME 入荷日
    DECIMAL 入荷数量 "発注単位での数量"
    DECIMAL 仕入単価 "実際適用された単価"
    VARCHAR 仕入先ロット番号 "仕入先バッチ番号"
    DECIMAL 在庫換算数量 "在庫単位に換算された数量"
}

"品目ロットデータ" {
    INT ロット_ID PK "連番 内部キー"
    INT 入荷明細_ID FK "ロット発生元の入荷明細 または 製造記録"
    VARCHAR 社内ロットNo "自社発番の管理番号"
    DATE 製造日 "ロット製造日"
    VARCHAR 備考
}

"在庫データ" {
    INT id PK "連番 内部キー"
    INT 品目ID FK "item_id"
    INT 組織ユニットID FK "論理的所有組織 (必須)"
    INT ロケーションID FK "物理的場所 (任意)"
    DECIMAL 在庫数量 "quantity"
}

"在庫移動データ" {
    INT 移動_ID PK "連番 内部キー"
    INT 作業実績_コード FK "業務コード NULL可"
    VARCHAR 移動タイプ "消費 棚卸調整 ロケーション移動 入庫等"
    VARCHAR 品目_コード FK "品目マスタを参照"
    DECIMAL 消費数量 "在庫単位での数量 例: g"
    INT 適用入荷明細_コード FK "業務コード"
    VARCHAR 消費元個別識別子 FK "業務コード"
    DECIMAL 消費原価
    VARCHAR 移動元ロケーション_コード FK "業務コード"
    VARCHAR 移動先ロケーション_コード FK "業務コード"
}

%% -------------------- V. 受注・販売管理トランザクション --------------------
"受注データ" {
    INT 受注_ID PK "連番 内部キー"
    INT 受注_コード "業務コード"
    DATE 受注日
    VARCHAR partner_code FK "顧客BusinessPartner参照"
}

"受注明細データ" {
    INT 受注明細_ID PK "連番 内部キー"
    INT 受注_コード FK "業務コード"
    VARCHAR 品目_コード FK "品目マスタを参照"
    INT delivery_destination_id FK "納入先DeliveryDestination参照"
    DECIMAL 受注数量 "品目の在庫単位での数量"
    DECIMAL 受注単価 "実際適用された単価"
    DATE 納期
}

%% -------------------- VI. 生産・実績トランザクション --------------------
"作業指示データ" {
    INT 指示_ID PK "連番 内部キー"
    INT 指示_コード "業務コード"
    INT 受注明細_コード FK "生産依頼元"
    VARCHAR 対象品目_コード FK "品目マスタ (作るもの)"
    INT 工程_コード FK
    VARCHAR 必須スキル_コード FK
    VARCHAR 品質グレード "指示品質等級"
    INT 作業順序
    INT 標準時間
    DATE 計画開始日
}

"作業実績データ" {
    INT 実績_ID PK "連番 内部キー"
    INT 実績_コード "業務コード"
    INT 指示_コード FK "業務コード"
    VARCHAR ユーザー_コード FK "ユーザーマスタを参照"
    VARCHAR 検査項目_コード FK
    INT 標準検査基準コード FK "標準検査基準マスタを参照"
    INT 個別検査基準コード FK "個別検査基準マスタを参照"
    DATETIME 開始日時
    DATETIME 完了日時
    DECIMAL 検査結果値
    VARCHAR 総合合否
    VARCHAR 不良区分 "合格 不合格スクラップ 手直しなど"
}


%% -------------------- VII. リレーションシップ 定義 --------------------
"BusinessPartner (取引先マスタ)" ||--o{ "DeliveryDestination (納入先マスタ)" : 複数納入先

%% Items & BOM
"品目マスタ" ||--|| "技術情報マスタ" : 技術情報
"品目マスタ" ||--o{ "品目構成マスタ (ItemBOM)" : 親として保持
"品目マスタ" ||--o{ "品目構成マスタ (ItemBOM)" : 子として消費
"工程マスタ" ||--o{ "品目構成マスタ (ItemBOM)" : 消費発生工程

"品目マスタ" ||--o{ "標準検査基準マスタ" : 適用
"工程マスタ" ||--o{ "標準検査基準マスタ" : 適用工程
"検査項目マスタ" ||--o{ "標準検査基準マスタ" : 項目
"BusinessPartner (取引先マスタ)" ||--o{ "個別検査基準マスタ" : 適用取引先
"品目マスタ" ||--o{ "個別検査基準マスタ" : 適用
"検査項目マスタ" ||--o{ "個別検査基準マスタ" : 項目

%% HR & Organization Relationships
"ユーザーマスタ" ||--o{ "配属辞令履歴" : 履歴
"拠点マスタ" ||--o{ "配属辞令履歴" : 拠点配属
"組織単位マスタ" ||--o{ "配属辞令履歴" : 組織所属
"組織単位マスタ" ||--o{ "組織単位マスタ" : 組織階層
"組織単位マスタ" ||--o{ "組織権限マスタ" : 権限付与
"ユーザーマスタ" ||--o{ "ユーザースキル関連" : 保有スキル
"スキルマスタ" ||--o{ "ユーザースキル関連" : 必要要件
"ユーザーマスタ" ||--o{ "人員賃率データ" : 標準原価設定
"ユーザーマスタ" ||--o{ "セッションマスタ" : 認証

%% Transactions
"BusinessPartner (取引先マスタ)" ||--o{ "受注データ" : 得意先
"受注データ" ||--o{ "受注明細データ" : 構成
"品目マスタ" ||--o{ "受注明細データ" : 受注品目
"DeliveryDestination (納入先マスタ)" ||--o{ "受注明細データ" : 納入先
"受注明細データ" ||--o{ "作業指示データ" : 依頼元
"品目マスタ" ||--o{ "作業指示データ" : 対象品目
"工程マスタ" ||--o{ "作業指示データ" : 含む
"スキルマスタ" ||--o{ "作業指示データ" : 必要スキル
"作業指示データ" ||--o{ "作業実績データ" : 実現
"ユーザーマスタ" ||--o{ "作業実績データ" : 実行者
"検査項目マスタ" ||--o{ "作業実績データ" : 記録
"標準検査基準マスタ" ||--o{ "作業実績データ" : 標準基準参照
"個別検査基準マスタ" ||--o{ "作業実績データ" : 個別基準参照
"品目マスタ" ||--o{ "仕入見積データ" : 適用品目
"BusinessPartner (取引先マスタ)" ||--o{ "仕入見積データ" : 提供元
"BusinessPartner (取引先マスタ)" ||--o{ "発注データ" : 発注先
"発注データ" ||--o{ "発注明細データ" : 構成
"品目マスタ" ||--o{ "発注明細データ" : 品目
"仕入見積データ" ||--o{ "発注明細データ" : 適用見積
"発注明細データ" ||--o{ "入荷明細データ" : 該当発注
"入荷データ" ||--o{ "入荷明細データ" : 構成
"入荷明細データ" ||--o{ "品目ロットデータ" : ロット情報
"拠点マスタ" ||--o{ "ロケーションマスタ" : 拠点内の場所
"ロケーションマスタ" ||--o{ "在庫データ" : 配置
"組織単位マスタ" ||--o{ "在庫データ" : 所有
"品目マスタ" ||--o{ "在庫データ" : 品目
"入荷明細データ" ||--o{ "在庫データ" : 発生元
"ロケーションマスタ" ||--o{ "在庫移動データ" : 移動元
"ロケーションマスタ" ||--o{ "在庫移動データ" : 移動先
"作業実績データ" ||--o{ "在庫移動データ" : 消費元
"品目マスタ" ||--o{ "在庫移動データ" : 対象品目
"入荷明細データ" ||--o{ "在庫移動データ" : 原価元ロット
"在庫データ" ||--o{ "在庫移動データ" : 原価元個別
```
