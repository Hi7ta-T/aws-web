
## 本成果物のNW構成
![NW構成図](aws-network.png)
<br>

### 構成図の概要<br>
2AZの3層構成(ALB,EC2,RDS)を単一リージョンで作成。
- 1AZにつきPublic Subnetを1個とPrivate Subnetを2個配置
- VPC外のサービスとしてはRoute 53,CloudWatch(Alarm),SNSを採用

本ドキュメントはNW構成の説明資料のため<br>
詳細なサービス選定理由は以下に記載。<br>
[サービス選定理由](service-selection.md)

### 各サービスのサブネット配置<br>
- ALB:Public Subnet<br>
クライアントからのWeb通信（HTTP/HTTPS）のリクエストを受け入れるため、直接インターネット接続可能なPublic Subnetに配置<br>

- EC2:Private Subnet<br>
外部接続が不要であり、かつ接続経路を絞ることでセキュリティ性の向上を図るため<br>直接のインターネット接続不可であるPrivate Subnetに配置<br>

- RDS:Private Subnet<br>
外部接続が不要であり、かつ接続経路を絞ることでセキュリティ性の向上を図るため<br>
直接のインターネット接続不可であるPrivate Subnetに配置<br>

### サブネット/VPCのCIDR<br>
- VPC=/16<br>
今後サービスの拡張で追加のサブネットが必要となった際を考慮して /16 で作成<br>

- サブネット=/24<br>
現在は各サービスでIP使用数10個未満だが、スケールアウトやサービス拡張に伴う使用量追加を考慮して<br>
IP使用数を余分に確保するため /24 で作成<br>

### 各SGの設定理由<br>
- Internet → ALB（443=0.0.0.0/0）<br>
全てのWeb通信を受け入れ可能とすると通信傍受の可能性が高まり通信者の安全性が確保できないため、TLSで通信の暗号化、安全性を確保したHTTPS通信のみ受信可能とする<br>

- ALB → EC2（80＝ALB SG）<br>
TLSハンドシェイクを含むHTTPS通信（クライアント⇔ALB間）の終端がALBであり、ALBによって復号が行われることから内部では負荷軽減のためHTTP通信を使用<br>
受け入れるインバウンド通信をALBのSGのみとし、通信経路を限定することでセキュリティ性を向上<br>

- EC2 → RDS（3306=EC2 SG）<br>
受け入れるインバウンド通信をEC2のSGのみとすることで、通信経路を限定しセキュリティ性を向上<br>
今回はMySQLを使用するため、3306ポートを指定<br>
