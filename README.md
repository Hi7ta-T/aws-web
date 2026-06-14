
# aws-web

## 概要
地域毎の治安や利便性の可視化を狙いとして<br>
実際の居住者の口コミの内容や数量を管理するWebアプリケーションを作成。<br>
<br>
AWSを用いて作成した3層構成のインフラ基盤をTerraformでIaC化、FastAPI(Python)でAPI構築を実施予定。
<br>

## 技術スタック
VPC内の各サービスの比較、選定理由はこちら<br>
[サービス選定理由](service-selection.md)
<br>
<br>
以下、使用予定を含む技術スタックを記載
- AWS（インフラ構築）
- Terraform（IaC化)
- FastAPI（API構築)
- Figma（構成図）
- GitHub（成果物説明）

## アーキテクチャ方針
- 運用コストと管理負荷をトレードオフし、単一リージョンに2AZの3層構成（ALB/EC2/RDS）を構築。<br>
管理コストが低下する代わりにリージョン障害時の可用性を確保出来ないため、今後の優先的な考慮点となる。<br>

- NAT GatewayをAZごとに分割して配置。<br>
運用コストの増加と引き換えにAZ障害時の可用性を確保した。<br>

## 本成果物のNW構成図
![NW構成図](docs/aws-network.png)
- 詳細なNW構成はこちら<br>
[NW構成](design-network.md)

## Terraform(IaC)
NW通信に関わるVPC内リソースのみIaC化済。
今後はCloudWatch Alarm、SNS、Route 53といったVPC外リソースのIaC化を予定している。

| リソース名 | ファイル| 
|:-----:|:-----:|
| VPC | [vpc.tf](terraform/vpc.tf)| 
| IGW | [igw.tf](terraform/igw.tf)|
| NAT Gateway | [nat.tf](terraform/nat.tf) |
| Subnet | [subnet.tf](terraform/subnet.tf)|
| Routing | [route.tf](terraform/routing.tf)|
| Security Group | [security_group.tf](terraform/security_group.tf)|
| ALB | [alb.tf](terraform/alb.tf) |
| EC2 | [ec2.tf](terraform/ec2.tf)|
| RDS | [rds.tf](terraform/rds.tf)|


## 障害時の運用
CloudWatch AlarmとSNSを連携させて<br>
障害発生時に通知することで、障害の早期発見と迅速な復旧対応へ繋げている。
- 運用設計書はこちら<br>
[運用設計書](trouble-shooting.md)

## 構築状況と今後の展望
現在はAWS上でのNW構築は完了しており、VPC内リソースをTerraformでIaC化している。<br>
ルート別の疎通確認と並行してFastAPI(Python)を用いたAPI構築を行う。<br>
<br>
また、将来的にはRoute 53の自動フェイルオーバーを使用して
リージョン障害時にも可用性を担保する予定である。<br>
