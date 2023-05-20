# <a href="https://haplunch.com//">happylunch</a>

## アプリの概要
数ある作品の中から、ご覧いただき誠にありがとうございます。<br>
「ハピランチ」は、社会人のみなさまが、休憩中のごはんをより充実させるために、お近くの、安くて、美味しい、健康的なランチやお弁当の情報を検索、共有できるサービスです。<br>
当サービスは、公式マニュアルや技術記事を参考に独学で開発しました。<br>
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
・AWS(Route53,ALB,VPC,subnet,ECR,ECS,RDS(MySQL),ACM)<br>
### テスト、静的コード解析
・Rspec<br>
## 工夫した点
・スマホでの使用が主となるはずなので、レスポンシブデザインを意識しました。<br>
・GoogleAPIを導入し、住所情報に地図を付加することで、ユーザーが素早く、正確に位置情報を把握できるように、設計しました。また、検索オプションを追加（現在地から近い順・料金が安い順）することで、ユーザーが多角的に情報を取得できるようにし、利便性を高めました。<br>
・Dockerと相性の良いAWS(ECS Fargate)を採用しました。<br>
・Github Actionsを用いてCI/CDパイプラインを構築しました。<br>
## Happylunchの開発背景
私は、会社に出勤する際の昼食に関して、もともとは弁当を持参していて食べていました。<br>
しかし、仕事が忙しくなると、時間がなく作ることができず、次第に、近くのコンビニやスーパーの弁当で買うようになりました。<br>
それらの弁当に関して、クオリティが年々上がっているとは言えど、飲食店のものと比較するとできたでないため美味しくない、栄養（野菜）が充分に摂れない、味に飽きたと思うようになりました。<br>
そのような中で、それほど高くない値段で美味しくて栄養が豊富な昼食を取ることができればハッピーなのになあ・・・と考えた末、そんな昼食情報を簡単に調べることができるアプリを作成しよう開発にいたりました。<br>
<br>
会社員が昼食に支払う費用は、以下の調査から、男性は649円女性は656円が平均値となっています。<br>
https://www.okan-media.jp/food-one-coin-menu<br>
大手のグルメサイトでは、条件検索をする際に、上限の最低値が〜999円となっていることが多く、これと差別化するべく、当アプリではより会社員の平均値に近い800円を上限とし、肌感覚ですが、一般的な会社員が日常のランチで手が出せる範囲の値段のランチを調べることができるアプリとしました。<br>
また、もっと低価格なランチ情報を調べたい！という方には、500円未満のワンコインランチ検索、野菜をいっぱい摂取したい！という方のためには、投稿に野菜が豊富かの情報を付加することで、野菜豊富なランチを検索をすることができるようにしました。<br>
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
・HOME画面にて、googleAPIを用いた投稿検索機能があり、現在地から近い順・料金が安い順の条件で投稿を検索できる。<br>
・記事一覧機能にはページネーションを実装（kaminari gemを使用）<br>
・ホーム画面にてフォロー中のユーザーの投稿をタイムラインで確認できる<br>
### フォロー機能(Ajax)
・フォロー、フォロー解除機能<br>
・フォロー、フォロワー一覧表示機能
### いいね機能
・記事にいいねができる機能<br>
・いいねをした記事のいいね数が変化する<br>
・マイページにていいねを押した記事一覧表示機能
### コメント機能
・記事ごとにコメント投稿、削除、表示する機能
## インフラ構成
<img src= '/README_images/インフラ構成図.png' >

## ER図
<img src= '/README_images/ER図.png' >

## 現時点での問題点
・Vuejsによる完全SPA化、UXの向上（いいね、フォローなどのボタンアニメーション）<br>
・投稿者の投稿ありきのアプリケーションなので、データ数が圧倒的に少ない。<br>
→投稿者が投稿してくれるような仕組み作り（投稿数に応じてポイントが付与され、そのポイントをランチの支払いに使用できるようなもの）を実装予定。<br>
・現在地の取得に時間がかかる。<br>