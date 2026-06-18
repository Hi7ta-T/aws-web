
# aws-web

## 概要
地域毎の治安や利便性の可視化を狙いとして<br>
実際の居住者の口コミの内容や数量を管理するWebアプリケーションを作成。<br>
<br>
AWSを用いて作成した3層構成のインフラ基盤をTerraformでIaC化、FastAPI(Python)でAPI構築を実施予定。
<br>

## 使用技術一覧
インフラ構成要素の比較、選定理由はこちら<br>
[サービス選定理由](service-selection.md)
<br>
### 技術スタック
- AWS（インフラ構築）
- Terraform v1.15.3（IaC化)
- FastAPI（API構築)
- Figma（構成図）
- GitHub（ソースコード管理）

### 開発環境
- Debian GNU/Linux 12 (bookworm)
- Visual Studio Code 1.118.1

## アーキテクチャ方針
運用コストと管理負荷のトレードオフを考慮し、以下の内容で構築した。

- 単一リージョンに2AZの3層構成（ALB/EC2/RDS）<br>
管理コストが低下する代わりにリージョン障害時の可用性を確保出来ないため、今後の優先的な考慮点となる。<br>

- NAT GatewayをAZごとに分割配置<br>
運用コストの増加と引き換えにAZ障害時の可用性を確保した。<br>

## Terraform(IaC)
セルフレビュー方法、ならびにリソースの疎通確認結果はこちら<br>
[セルフレビュー、検証結果](verification.md)
<br>
<br>
### 現在のIaC化状況
VPC内リソースのIaC化が完了。
今後はCloudWatch Alarm、SNS、Route 53といったVPC外リソースのIaC化を予定している。

IaC化済<br>
| リソース名 | ファイル| 
|:-----:|:-----:|
| VPC | [vpc.tf](terraform/vpc.tf)| 
| IGW | [igw.tf](terraform/igw.tf)|
| NAT Gateway | [nat.tf](terraform/nat.tf) |
| Subnet | [subnet.tf](terraform/subnet.tf)|
| Routing<br>(associationも記載)| [route.tf](terraform/routing.tf)|
| Security Group | [security_group.tf](terraform/security_group.tf)|
| ALB | [alb.tf](terraform/alb.tf) |
| EC2 | [ec2.tf](terraform/ec2.tf)|
| RDS | [rds.tf](terraform/rds.tf)|


IaC化中<br>
| リソース名 | ファイル| 
|:-----:|:-----:|
| Route 53 | [route53.tf](terraform/route53.tf)| 
| SNS | [sns.tf](terraform/sns.tf)|
| CloudWatch<br>(Alarm) | [cloudwatch.tf](terraform/cloudwatch.tf)|

## NW構成
![NW構成図](docs/aws-network.png)
詳細なNW構成はこちら<br>
[NW構成](design-network.md)

## 障害時の運用設計
CloudWatch AlarmとSNSを連携させて<br>
障害発生時に通知することで、障害の早期発見と迅速な復旧対応へ繋げている。
<br>
<br>
運用設計書はこちら<br>
[運用設計書](trouble-shooting.md)

## 開発記録
2026年3月から成果物を検討開始。<br>
2026年4月にGitHubで成果物管理を始めてからは構築状況に応じて継続修正を行っている。<br>
<br>
2026年6月のTerraform導入時にGit管理のトラブルが発生し、原因究明を行う前に誤ってGitの初期化を実施。<br>
結果としてそれまでのコミット履歴が削除されたため、現在のコミット数は2026年6月以降のものである。<br>

この際の反省点を生かして、本成果物では以下を留意して開発を行っている。
<br>

- 障害発生時の原因分析、対応策検討
- 変更前のファイル状態、影響範囲の確認
- バックアップ取得(復旧可能な状態を保持)

## 構築状況と今後の展望
### 現在の構築状況
- TerraformでVPC内リソースをIaC化。<br>
コードのセルフレビューおよび、リソース毎の疎通検証を実施。<br>
- FastAPI(Python)を用いたAPI構築を開始

### 今後の展望
以下、優先順位ごとに記載。
1. TerraformでVPC外リソースのIaC化<br>
(Route 53,SNS,CloudWatch)
2. FastAPI(Python)でのAPI構築完了
3. アプリケーションをマルチリージョン化
4. Route 53の自動フェイルオーバーでリージョン障害時の可用性を確保
