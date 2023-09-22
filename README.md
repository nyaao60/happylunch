# <a href="https://haplunch.com//">happylunch</a>

  ## アプリの概要
  数ある作品の中から、御覧いただき誠にありがとうございます。<br>
  「ハピランチ」は、社会人のみなさまが、休憩中のごはんをより充実させるために、現在地や目的地からお近くの、安い、美味しい、健康的なランチやお弁当の情報を検索、共有できるサービスです。<br>
  当サービスは、公式マニュアルや技術記事を参考に、たくさんのエラーにもがきながら、独学で開発したため、<br>
  お試しいただければ、とても嬉しいです！<br>
  ※ゲストログイン機能を実装しておりますので、お気軽にお試しできます。<br>


  <img src= '/README_images/概要1.png' height='400' width='830' ><br>
  <img src= '/README_images/概要2.png' height='500' width='830'><br>

## 使用技術
### バックエンド
・Ruby(2.7.6)<br>
・Ruby on Rails (6.0.6)<br>
・MySQL(8.0.32)<br>
・Puma<br>
・Nginx<br>
### フロントエンド
・HTML/CSS<br>
・Javascript<br>
### 開発環境、インフラ
・docker/docker-compose<br>
・GitHub Actions(CI/CD)<br>
・AWS(Route53,ALB,VPC,subnet,ECR,ECS,RDS(MySQL),ACM,S3)<br>
### テスト
・Rspec<br>
## 特に工夫した点
### <strong>メニューに焦点を当てた検索サービス</strong><br>
ランチを調べる際によく利用される既存の大手のサービスは、”お店”の情報を検索するアプリケーションが多く、実際に食べることができる”メニュー”の情報に直結していないと考えたため、当サービスは、ランチメニューそのものに焦点を当て、メニューそのものの美味しさの評価や野菜の豊富さ等を迅速に取得できるようなサービスに設計しました。<br>
### <strong>GoogleAPI用いて情報を多角的に取得</strong><br>
・GoogleAPIを用いて、現在地を取得できるようにし、情報を検索する際に、現在地から一定の距離範囲内のランチ情報を取得できるように設計しました。<br>
•様々な検索オプション（現在地から近い順・料金が安い順・おすすめ度順・野菜が豊富なメニュー）を設けることで、情報を多角的に取得できるようにしました。<br>
・GoogleAPIによって、投稿情報に住所地図を付加することで、ユーザーが素早く、正確に位置情報を把握できるように、設計しました。<br>
### <strong>シームレスなDocker運用、効率的なCI/CDパイプライン</strong><br>
・開発環境と本番環境の差異による問題に対応するため、Dockerを使用して開発を行い、本番環境では、Dockerと相性の良いAWS ECS(Fargate)を利用し、Dockerイメージの管理のみに集中できるサーバーレスな運用を実現しました。<br>
・AWS Route53, ACM, ALBを用いて、独自ドメイン＋常時SSL通信(HTTPS)を実現しました。<br>
・Github Actionsを用いてCI/CDパイプラインを構築しました。<br>
## Happylunchの開発背景
私は、会社に出勤する際の昼食に関して、もともとは弁当を持参し、食べていましたが、仕事が忙しくなると、時間を中々作ることができず、次第に、近くのコンビニやスーパーの弁当を購入するようになりました。<br>
それらの弁当に関して、クオリティが年々上がっていると言えど、飲食店のものと比較すると、できたでないため美味しくない、栄養（野菜）が充分に摂れない、味に飽きたと思うようになりました。<br>
そのような中で、お小遣い内で美味しくて栄養が豊富な昼食を取ることができればハッピーなのになあ・・・と考えた末、そんな昼食情報を簡単に調べることができるアプリ「ハピランチ」を作成しようと開発に至りました。<br>
<br>
想いを体現するにあたって、SNS サイトでよく目にする登録、 ログイン、投稿、フォロー、いいね等の機能に加え、以下のような機能を実装しました。<br>
<機能>
<br>
・お近くのランチを探したいというユーザー向けに、現在地を取得する機能を追加し、距離が近い順でランチを探すことができる条件検索機能<br>
・低価格なランチを探したいというユーザー向けに、価格が安い順でランチを探すことができる条件検索機能<br>
・おすすめの美味しいランチを探したいというユーザー向けに、おすすめ度順でランチを探すことができる条件検索機能<br>
・野菜豊富なランチを探したいというユーザー向けに、野菜豊富なランチのみ検索することができる条件検索機能<br>

## 機能一覧/詳細
### ユーザー機能（devise gem 未使用）
・新規登録、ログイン(永続ログイン)、ログアウト、ユーザー情報編集<br>
・ゲストログイン機能<br>
・管理者機能（ユーザーの削除と紐づく投稿の削除が可能）<br>
・ユーザー一覧表示<br>
### 投稿に関する機能
・投稿記事一覧、詳細表示、記事投稿、編集、削除機能<br>
・記事投稿、編集時はjavascriptで画像プレビューができる<br>
・記事詳細画面では、googleAPIによる地図情報確認が可能<br>
・記事一覧機能にはページネーションを実装（kaminari gemを使用）<br>
・ホーム画面にてフォロー中のユーザーの投稿をタイムラインで確認できる<br>
### 投稿検索機能
・googleAPIを用いた、現在地の取得ができる機能<br>
・googleAPIを用いた、投稿検索機能（現在地から近い順、料金が安い順、おすすめ度順、野菜豊富なメニューの絞り込みの条件で投稿を検索できる。）<br>
### フォロー機能
・フォロー、フォロー解除機能<br>
・フォロー、フォロワー一覧表示機能<br>
### いいね機能
・記事にいいねができる機能<br>
・いいねをした記事のいいね数が変化する<br>
・マイページにていいねを押した記事一覧表示機能<br>
### コメント機能
・記事ごとにコメント投稿、削除、表示する機能<br>
## インフラ構成
<img src= '/README_images/インフラ構成図2.png' >

## ER図
<img src= '/README_images/ER図1.png' >

## 現時点での課題、将来的に実装予定の機能（2023年9月20日現在）
・レスポンシブデザイン実装予定<br>
　現在横幅、1280px〜1920pxまでのPCサイズでのみ、レイアウトの崩れがないことを確認。
<br>
・検索フォームの現在地の取得に時間がかかるため、改善予定<br>
・Vuejsによる完全SPA化、UXの向上を実装予定（いいね、フォローなどのボタンアニメーション）<br>
・投稿ありきのサービスで、現在投稿数が少ないため、投稿数に応じてポイントが付与されるような投稿意欲を促 進させる機能を実装予定<br>