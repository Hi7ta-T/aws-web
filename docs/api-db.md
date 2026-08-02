## API実装

## DB設計
エンティティとカラムの確定後、多重度に応じてテーブル同士の関係性を決定。データ型とNULL可否を確定させてからER図を作成した。<br>
<br>
その後、DDLを用いてテーブルを構築。構築したテーブルにDMLでサンプルデータを入力し、FastAPIなどの必要に応じてDQLで格納データを取得する想定とした。

### DDLを用いたテーブル構築
CREATE TABLEを用いてユーザー(users)、場所(spots)、都道府県(prefecture)、口コミ(reviews)の4つのテーブルを構築。<br>
<br>
なお、TerraformでのRDSリソース作成時にDBを作成するため、DDLではCREATE DATABASEを実施していない。<br>
<br>
以下、各テーブルのDDLを記載。
| テーブル名 | ファイル| 
|:-----:|:-----:|
| ユーザー(users) | [users.sql](../db/ddl/users.sql)| 
| 場所(spots) | [spots.sql](../db/ddl/spots.sql)| 
| 都道府県(prefecture) | [prefecture.sql](../db/ddl/prefecture.sql)| 
| 口コミ(reviews) | [reviews.sql](../db/ddl/reviews.sql)| 

### DMLを用いたサンプルデータ入力
prefectureテーブルの「pref_name」は都道府県名を表しているため、マスタデータとして実際の都道府県の名称を登録。<br>他のカラムはトランザクションデータとしてサンプルデータを入力した。

### DQLを用いた格納データの取得
