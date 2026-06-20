
## セルフレビュー、検証結果
### 使用ツール
コードのセルフレビューに際して、開発環境に以下のツールを追加。

- TFLint version 0.63.1
- tfsec v1.28.14

### セルフレビュー手順
目視でのコード確認後、以下の手順でセルフレビューを行った。
1. terraform fmt<br>
コードの書式、ブロック整理
2. terraform validate<br>
誤記載やリソース参照ミスをエラーとして検出
3. TFLint(terraform Lint)<br>
コードの品質、ベストプラクティスに関する指摘を検出

tfsec はセキュリティチェックツールのため、コードが完成した疎通確認後に実施した。
<br>

### エラー検出例
terraform validate の実行時に頻繁に検出されたエラー例を記載。
- tagsブロックでの「＝」記載忘れ
- ALB/EC2/RDSリソースに vpc_id を記載
- 誤記載（multi-az , secutity_groups）
- リソース別のSubnet 指定ミス<br>
(subnet_id , subnets , subnet_ids)
- リソース別のSecurity Group 指定ミス<br>
(security_groups , vpc_security_group_ids)

## 各リソースの疎通検証
今回は可用性を意識して2AZ構造でEC2とNAT Gatewayを分割配置して構築しているため、AZ毎に各リソースの通信経路に適した方法で疎通検証を行った。(外部 → ALB を除く)

- 外部 → ALB
- ALB → EC2(ap-northeast-1a)
- ALB → EC2(ap-northeast-1c)
- EC2 → RDS(ap-northeast-1a)
- EC2 → RDS(ap-northeast-1c)
- EC2 → NAT Gateway → Internet<br>(ap-northeast-1a)
- EC2 → NAT Gateway → Internet<br>(ap-northeast-1c)
