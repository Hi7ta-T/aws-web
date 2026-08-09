## 各リソースの疎通検証
### 検証手順、成功条件
可用性を意識して2AZ構成でEC2とNAT Gatewayを分割配置して構築しているため、AZ毎に各リソースの通信経路に適した方法で疎通検証を行った。(外部 → ALB を除く)<br>
<br>
なお、長時間の応答待機を防ぐため、タイムアウト値を3秒に設定した。

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

1. **外部 → ALB**<br>
` curl --connect-timeout 3 https://DNS名 `
- 検証手順<br>
Cloudflareでドメインを取得してRoute 53のホストゾーンに委任。TLS証明書をALBに関連づけることで、HTTPS通信を使用可能とした。(ALBのSG = 443,0.0.0.0/0)<br>
Nginxを追加したEC2の実行環境でcurlコマンドを行い、外部クライアントからEC2のWebサーバーまでを疎通する経路で確認。

- 成功条件<br>
HTTPステータスコードが「200 OK」

2. **外部 → SSM → EC2**<br>
` aws ssm start-session --target `
- 検証手順<br>
Session Manager 経由でEC2の対象インスタンスに接続出来ることを確認。インスタンスへの接続後、Nginxをインストールして起動出来るかどうかを検証。

- 成功条件<br>
EC2へのログイン、ならびにNginxのインストールと起動が出来るかどうか。

3. **ALB → EC2**<br>
` curl --connect-timeout 3 https://DNS名 `
- 検証手順<br>
Nginxを追加したEC2の実行環境でcurlコマンドを行い、外部クライアントからEC2のWebサーバーまでの疎通を検証。
AZごとに配置したEC2(Nginx)の応答で確認。

- 成功条件<br>
HTTPステータスコードが「200 OK」

4. **EC2 → RDS**<br>
` nc -zv -w 3 RDSのエンドポイント 3306 `
- 検証手順<br>
MySQLプロトコルで通信するため、curlではなくncコマンドを使用し、RDSのエンドポイントを指定。<br>
疎通検証のみを実施することから-zオプション、コマンドの実行結果を理解しやすくするために-vオプションを使用した。

- 成功条件<br>
ncコマンドのレスポンスが「Succeeded!」


5. **EC2 → NAT Gateway → Internet**<br>
` curl --connect-timeout 3 https://DNS名 `
- 検証手順<br>
Nginxを追加したEC2の実行環境でcurlコマンドを行い、EC2からインターネットへアウトバウンド通信出来るかどうかを確認。

- 成功条件<br>
HTTPステータスコードが「200 OK」

### 疎通検証結果(作成中)
以下、通信経路別に疎通検証の結果を記載。

1. **外部 → ALB**

2. **外部 → SSM → EC2**

3. **ALB → EC2**

4. **EC2 → RDS**

5. **EC2 → NAT Gateway → Internet**
