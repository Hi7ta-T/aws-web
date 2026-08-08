
## 目次
各項目の目次を以下に記載。<br>

- [概要](#概要)
- [開発フロー、構築状況](#開発フロー、構築状況)
- [アーキテクチャ方針](#アーキテクチャ方針)
- [使用技術一覧](#使用技術一覧)
- [NW構成](#NW構成)
- [API実装(作成中)](#API実装)
- [DB設計(作成中)](#DB設計)
- [Terraform、疎通検証](#Terraform、疎通検証)
- [運用設計](#運用設計)
- [ドキュメントリンク一覧](#リンク一覧)

## 概要
### 構築内容
**AWSを用いた3層構成(ALB/EC2/RDS)のWebアプリケーションを構築**<br>

- 各地域の口コミの内容や数量を管理
- 口コミの一覧表示や地域別の口コミを検索

### 構築目的
- 口コミで地域毎の治安や利便性を可視化
- 住環境を選択する際の一助として使用

## 開発フロー、構築状況
作成するアプリケーションの構想を練り、設計から構築までの大まかなフローを決定してから構築を開始。<br>
<br>
2026年6月のTerraform導入時にトラブルが発生し、それ以前のコミット履歴が削除されたため、障害発生時の原因分析や復旧可能状態を維持することを重視している。<br>

### 構築状況
2026年内に1つのアプリケーションとして機能させることを目標に構築を進めている。<br>
<br>
NW構成、リソースの選定や運用設計の作成を経て、DB構築まで完了。現在はREST APIのコーディングやCloudflareで取得したドメインのNS移行を行い、疎通検証に向けた取り組みを進めている。<br>
<br>
開発フローや構築状況、今後の展望はこちら<br>
[開発フロー・現在の構築状況](docs/development-process.md)

## アーキテクチャ方針
![アーキテクチャ図](docs/architecture.png)
**本成果物の作成軸は「設計理解」と「コスト」である。**<br>
アプリケーションの可用性と設計コストはトレードオフの関係にあるため、作成軸を元に可用性の確保基準を考慮した。

### リージョン
**単一リージョン(東京,ap-northeast-1)**
- メリット：管理コスト低下
- デメリット：リージョン障害時の可用性確保不可

### Availability Zone
**2AZ構成(ap-northeast-1a,ap-northeast-1c)**
- メリット：AZ障害時の可用性確保
- デメリット：運用コストの増加

設計の軸として「コスト」を置いていたが、「設計理解」として学習を深めるためにNAT Gatewayの分割配置、ならびにRDSのMulti-AZを実構築することを優先して2AZ構成とした。

## 使用技術一覧
インフラ構成要素の比較、選定理由はこちら<br>
[各サービスの比較、選定理由](docs/service-selection.md)
<br>
### 技術スタック
- AWS（クラウド）<br>
VPC, ALB, EC2, RDS, NAT Gateway, Route 53, SSM, CloudWatch(Metrics, Alarms) SNS, ACM を使用。
- Python (プログラミング言語)<br>
追加ライブラリは別途記載。
- Terraform（IaC)
- Cloudflare (ドメイン取得)<br>
取得後はRoute 53にNSサーバー移行。
- Nginx (Webサーバー/リバースプロキシ）
- MySQL (データベース)
- Figma（構成図デザイン）
- GitHub（ソースコード管理）

### Pythonライブラリ
- FastAPI (APIフレームワーク)
- Uvicorn (FastAPI実装)
- SQLAlchemy (DB操作)
- PyMySQL (MySQL接続)
- passlib[bcrypt] (認証情報のハッシュ化)
- python-dotenv (接続情報保護)

### 開発環境
- Debian GNU/Linux 12 (bookworm)
- Visual Studio Code 1.118.1

### 使用予定
- HTML (フロントエンド構造)
- JavaScript (フロントエンド動作)
- CSS (スタイル)

## NW構成
2AZの3層構成(ALB, EC2, RDS)を単一リージョンで作成。
- 1AZにつきPublic Subnetを1個とPrivate Subnetを2個配置
- EC2の実行環境はSSMを経由して使用するため22ポート(SSH)の開放不要

詳細なNW構成はこちら<br>
[NW構成](docs/design-network.md)

## API実装
### 使用するAPI構成
以下、本成果物で使用するAPI構成を記載。<br>
| API名 | 今回使用するAPI | 
|:-----:|:-----:|
| Web API | FastAPI(Python) |
| OS API | Python内部ライブラリ<br>OS機能を使用する際に呼出 |
| ライブラリAPI | FastAPI, Uvicorn, SQLAlchemy, passlibなど<br>必要な機能に応じたライブラリを使用 |
| クラウドAPI | AWS API<br>(Terraform AWS Provider) |

### Web APIの構築
REST APIでのCRUD実装に向けて、現在はDMLでのサンプルデータ入力を実施している。<br>
<br>
API仕様、実装内容はこちら<br>
[API実装](docs/api-spec.md)

## DB設計
![ER図](docs/er-diagram.png)
ユーザー(user)、場所(spot)、口コミ(review)の3つのエンティティを使用。<br>
MySQLのDDLを用いてDBテーブルを作成。<br>各エンティティのテーブル作成後にサンプルデータを格納し、構築したAPIで検証予定。<br>
<br>
DBのテーブル設計(SQL)はこちら<br>
[DB設計](docs/db-design.md)

## Terraform、疎通検証
### 現在のIaC化状況
インフラ基盤となる3層構成(ALB/EC2/RDS)に関わる主要リソースのIaC化が完了。

**IaC化済**<br>
| リソース名 | ファイル | 
|:-----:|:-----:|
| Provider | [provider.tf](terraform/provider.tf)| 
| VPC | [vpc.tf](terraform/vpc.tf)| 
| Subnet | [subnet.tf](terraform/subnet.tf)|
| IGW | [igw.tf](terraform/igw.tf)|
| NAT Gateway | [nat.tf](terraform/nat.tf) |
| Routing<br>(association)| [route.tf](terraform/routing.tf)|
| Security Group | [security_group.tf](terraform/security_group.tf)|
| IAM<br>(SSM Only) | [iam.tf](terraform/iam.tf)| 
| ALB | [alb.tf](terraform/alb.tf) |
| EC2 | [ec2.tf](terraform/ec2.tf)|
| RDS | [rds.tf](terraform/rds.tf)|

**IaC化中**<br>
| リソース名 | ファイル| 
|:-----:|:-----:|
| Route 53 | [route53.tf](terraform/route53.tf)| 
| SNS | [sns.tf](terraform/sns.tf)|
| CloudWatch<br>(Alarms) | [cloudwatch.tf](terraform/cloudwatch.tf)|
| ACM | [acm.tf](terraform/acm.tf)| 

### セルフレビューと疎通検証
terraform fmt / validateとTFLintでセルフレビューを実施。疎通検証後にtfsecでのセキュリティチェックを予定している。<br>
<br>
セルフレビュー方法、リソースの検証方法と疎通結果はこちら(現在作成中)<br>

[セルフレビュー・検証結果](docs/verification.md)

## 運用設計
CloudWatch AlarmsとSNSを連携させて障害発生時に通知することで、障害の早期発見と迅速な復旧対応を目的としている。<br>
なお、CloudWatch Alarmsの閾値は疎通検証時に取得したメトリクス値を基に設定する予定。<br>
<br>
運用設計書はこちら<br>
[運用設計書](docs/trouble-shooting.md)

## リンク一覧
- [開発フロー・現在の構築状況](docs/development-process.md)<br>
本成果物の開発フロー、各項目別の構築状況を記載。開発時に発生したトラブルや今後の展望も記載している。

- [各サービスの選定理由](docs/service-selection.md)<br>
ロードバランサー、サーバー、DB、VPCリソースの選定理由を記載。補足としてインスタンスタイプとWebサーバー、SSM経由でのEC2接続経路について比較して説明。

- [NW構成](docs/design-network.md)<br>
セキュリティを鑑みたサブネット配置やCIDR、SGについて記載。

- [セルフレビュー・検証結果](docs/verification.md)<br>
前半はterraform fmt / validate やTFLintを用いたセルフレビューと頻出したエラーを記載。後半は作成したコードで行った経路別の疎通検証結果を記録している。

- [運用設計書](docs/trouble-shooting.md)<br>
インスタンス障害、AZ障害、リージョン障害時の現段階の障害検知と可用性を確保するための対策を記載。補足としてアプリケーション障害時の対応も述べている。

- [API実装](docs/api-spec.md)<br>
FastAPIを用いたREST APIのCRUD実装について、使用したライブラリ、ならびに設定したHTTPメソッドやエンドポイント(URL)などを含めて記載。

- [DB設計](docs/db-design.md)<br>
REST APIによるCRUD実装に向けて、DMLを用いたサンプルデータの登録を実施。登録したデータを使用してAPIの動作検証を行う予定としている。
