## セルフレビュー、検証結果
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
terraform validate の実行時に検出されたエラー例を記載。
- tagsブロックでの「＝」記載忘れ
- RDSリソースに cidr_id を記載
- multi-az の誤記載(正：multi_az）
- subnet_id/subnets/subnet_ids の使い分け

## 各リソースの疎通検証
各リソースのルーティングごとに適した方法で疎通確認を実施。
