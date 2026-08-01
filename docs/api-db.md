## API実装

## DB設計
エンティティとカラムの確定後、多重度に応じてテーブル同士の関係性を決定。データ型とNULL可否を確定させてからER図を作成した。<br>
<br>
その後、DDLを用いてテーブルを構築。構築したテーブルにDMLでサンプルデータを入力し、FastAPIなどの必要に応じてDQLで格納データを取得することとした。

### DDLを用いたテーブル構築
CREATE TABLE を用いてユーザー(users)、場所(spots)、都道府県(prefecture)、口コミ(reviews)の4つのテーブルを構築。<br>
なお、RDS on MySQLを使用するため、CREATE DATABASE でのDBの構築は実施していない。<br>
<br>
以下、各テーブル構築のSQLを記載。
