## API実装
API実装に関する追加ライブラリとしてFastAPIとUvicorn、SQLAlchemy、PyMySQLを使用。<br>
疎通検証を実施するため、最初に口コミの一覧表示(GET, /reviews)のAPI実装を行い、その後は必要に応じたAPIを作成する予定としている。

## エンドポイント定義
実行したい処理によって、作成するAPIのHTTPメソッドとパスを設定。<br>
<br>
以下、作成予定のエンドポイント定義を記載。
| 処理名 | HTTPメソッド | パス(URL) |
|:-----:|:-----:|:-----:|
| 口コミの一覧取得 | GET | /reviews |
| 特定の口コミを取得 | GET | /reviews/{review_id} |
| 特定のユーザーを取得 | GET | /users/{user_id} |
| 口コミの新規登録 | POST | /reviews |
| ユーザーの新規登録 | POST | /users |
| 場所の新規登録 | POST | /spots |
| 口コミの削除 | DELETE | /reviews/{review_id} |
| ユーザーの削除 | DELETE | /users/{user_id} |

## API実装手順
1. MySQLのDBとPythonを接続
2. DBテーブル・APIモデルの紐付け
3. 関数を用いて対応する処理を記載

### MySQLのDBとPythonを接続

### DBテーブル・APIモデルの紐付け

### 各APIの実装コード
以下、エンドポイント別に実装コードを記載。
