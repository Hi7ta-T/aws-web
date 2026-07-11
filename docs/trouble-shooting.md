
## 運用設計書
障害の影響範囲(規模)に応じて以下で分類。<br>
- インスタンス障害
- Availability Zone 障害
- リージョン障害
- (補足)アプリケーション障害

## 監視メトリクス
CloudWatch Alarm の発火条件となる閾値については、疎通検証時に取得したメトリクスを参考に設定する。<br>
なお、設定値は初期値のため、実運用を通して最適な閾値に変更していく予定である。<br>
<br>
以下、監視する項目、メトリクスを記載。
| 障害名 | リソース | 監視項目 | 
|:-----:|:-----:|:-----:|
| インスタンス障害 | ALB | TargetResponseTime |
| インスタンス障害 | EC2 | StatusCheckFailed |
| AZ障害 | ALB | HealthyHostCount/UnhealthyHostCount |
| AZ障害 | ALB | TargetResponseTime |
| リージョン障害 | Route 53 | ヘルスチェック |
| リージョン障害 | ALB | HealthyHostCount/UnhealthyHostCount |
| アプリケーション障害 | ALB | ヘルスチェック |
| アプリケーション障害 | ALB | TargetResponseTime　|

## インスタンス障害
### 障害の発生から検知までのフロー
1. EC2インスタンスに障害が発生<br>
(ex:EC2停止、OSのフリーズ)
2. StatusCheckFailedが「1(異常)」を記録
3. TargetResponseTimeが閾値超過
4. CloudWatch AlarmでSNSへ異常を連絡<br>
(2.3の片方を満たすとAlarm発火)
5. SNSに登録された宛先に異常発生を通知

### 障害後の対応
1. ALBのヘルスチェックによって、正常なインスタンスにリクエストを送付
2. 障害が発生したインスタンスを手作業復旧

なお、今後の規模拡大とともにAuto Scaling Groupを取り入れ、自動で障害時のインスタンス置換を実現する予定である。

## Availability Zone 障害
### 障害の発生から検知までのフロー
1. Availability Zoneに障害が発生<br>
(ex:停電、ネットワーク機器の故障)
2. HealthyHostCountが「1」を記録<br>
(UnhealthyHostCountが「1」を記録)
3. TargetResponseTimeが閾値超過
4. CloudWatch AlarmでSNSへ異常を連絡<br>
(2.3の片方を満たすとAlarm発火)
5. SNSに登録された宛先に異常発生を通知

### 障害後の対応
- ALB:正常なAvailability Zoneのインスタンスへリクエストを転送
- EC2:正常なAvailability Zoneでリクエストを処理
- RDS:スタンバイとして用意されているリソースをプライマリに昇格

RDSは可用性を意識してMulti-AZ構造を採用しているが、障害発生時にはスタンバイDBをプライマリに切り替える関係で<br>
フェイルオーバー中は一時的にアプリケーションが停止する場合がある。

## リージョン障害
### 障害の発生から検知までのフロー
今回は単一リージョンでの構築であり、リージョン障害時はアプリケーション使用不可となるため、障害時の検知と今後の可用性確保案について記載した。
1. リージョンに障害が発生<br>
(ex:データセンター障害、自然災害による大規模停電)
2. Route 53のヘルスチェックが失敗
3. HealthyHostCountが「0」を記録<br>
(UnhealthyHostCountが「2」を記録)
4. CloudWatch AlarmでSNSへ異常を連絡
5. SNSに登録された宛先に異常発生を通知

### 今後の可用性確保案
1. スタンバイ方式で別リージョンにリソースを作成
2. 障害発生後、Route 53のルーティングで別リージョンにあるリソースを使用

スタンバイ方式はコストを抑えた一方、リージョンの移行に時間を要するため<br>
移行が完了するまではアプリケーションが利用出来なくなる。

## (補足)アプリケーション障害
### 障害の発生から検知までのフロー
1. アプリケーションで障害が発生<br>
(ex:Nginx、FastAPIの停止)
2. ALBのヘルスチェックが異常を検知
3. TargetResponseTimeが閾値超過
4. CloudWatch AlarmでSNSへ異常を連絡
5. SNSに登録された宛先に異常発生を通知

### 今後の可用性確保案
アプリケーション障害はgreen/blueでの移行やAuto Scaling Groupによるインスタンスの置換などがあるが、早期に障害を検知し、被害を最小限に抑えることが重要となる。<br>
<br>
以下、アプリケーション障害における今後の展望を記載。
- CloudTrailでAPI操作ログの監視
- CloudWatchで監視メトリクスのダッシュボード化
- 設定した閾値の超過が確認されたらSNSで管理者に連絡
- 集計したログをKinesis Data StreamからLambdaに共有し、リアルタイムで分析処理を実施
