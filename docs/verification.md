
## セルフレビュー

### 使用ツール
コードのセルフレビューに際して、開発環境に以下のツールを追加。

- TFLint version 0.63.1
- tfsec v1.28.14

### セルフレビュー手順
目視でのコード確認後、以下の手順でセルフレビューを行った。
1. terraform fmt<br>
コードの書式、ブロック整理
2. terraform validate<br>
構文ミスやリソースの整合性をエラーとして検出
3. TFLint(terraform Lint)<br>
コードの品質、ベストプラクティスに関する指摘を検出
4. tfsec(terraform security)<br>
作成したコードのセキュリティ問題を検出

tfsec はセキュリティチェックツールのため、コードが完成した疎通検証後に実施した。
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

## 構築検証
terraform applyで作成するリソース数、ならびにエラーが発生していないことを確認してterraform planを実施。エラーが発生した場合はエラー文をコピーしてドキュメントに保存することで、後からエラー内容を確認してコードの修正を行った。<br>
<br>
なお、作成軸として「コスト」を掲げているため、エラー文のドキュメント保存完了後はterraform destroyでリソース数を確認の上、リソースの削除を行った。

### 第1回構築検証(2026/08/08)
