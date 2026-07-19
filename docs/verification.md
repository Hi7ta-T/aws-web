
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

## 各リソースの疎通検証
### 検証手順、成功条件
可用性を意識して2AZ構成でEC2とNAT Gatewayを分割配置して構築しているため、AZ毎に各リソースの通信経路に適した方法で疎通検証を行った。(外部 → ALB を除く)

| 通信経路 | AZ |
|:-----:|:-----:|
| 外部 → ALB | - |
| 外部 → SSM → EC2 | ap-northeast-1a |
| 外部 → SSM → EC2 | ap-northeast-1c |
| ALB → EC2 | ap-northeast-1a |
| ALB → EC2 | ap-northeast-1c |
| EC2 → RDS | ap-northeast-1a |
| EC2 → RDS | ap-northeast-1c |
| EC2 → NAT Gateway <br>→ Internet | ap-northeast-1a |
| EC2 → NAT Gateway <br>→ Internet |ap-northeast-1c |

Terraform専用のIAMユーザーを作成し、疎通検証を優先するために一時的にAdministrator Accessを付与。<br>
IAMは最小権限が推奨されていることから、疎通検証完了後は必要な権限のみを設定予定。

### 外部 → ALB
- 検証手順<br>
Cloudflareでドメインを取得してRoute 53のホストゾーンに委任。TLS証明書をALBに関連づけることで、HTTPS通信を使用可能とした。(ALBのSG = 443,0.0.0.0/0)<br>
Nginxを追加したEC2の実行環境でcurlコマンドを行い、外部クライアントからEC2のWebサーバーまでを疎通する経路で確認。

- 成功条件<br>
HTTPステータスコードが「200 OK」

### 外部 → SSM → EC2
- 検証手順<br>
Session Manager 経由でEC2の対象インスタンスに接続。Nginxをインストールして起動出来るかどうかを確認。

- 成功条件<br>

### ALB → EC2
- 検証手順<br>
Nginxを追加したEC2の実行環境でcurlコマンドを行い、外部クライアントからEC2のWebサーバーまでの疎通を検証。
AZごとに配置したEC2(Nginx)の応答で確認。

- 成功条件<br>
HTTPステータスコードが「200 OK」

### EC2 → RDS
- 検証手順<br>
MySQLプロトコルで通信するため、curlではなくncコマンドを使用。RDSのエンドポイントを指定、応答の有無で確認。

- 成功条件<br>

### EC2 → NAT Gateway → Internet
- 検証手順<br>
Nginxを追加したEC2の実行環境でcurlコマンドを行い、Webサーバーから外部クライアントへアクセス出来るかどうかを確認。

- 成功条件<br>
HTTPステータスコードが「200 OK」

### 疎通検証結果
以下、通信経路別に疎通検証の結果を記載。

### 外部 → ALB

### 外部 → SSM → EC2

### ALB → EC2

### EC2 → RDS

### EC2 → NAT Gateway → Internet
