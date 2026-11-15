# lab-web-init
> Built with [Elm Land](https://elm.land) 🌈

## Local development

```bash
# 開発サーバー（http://127.0.0.1:1234）
HOST=127.0.0.1 npx elm-land@0.20.1 server

# ビルド
npx elm-land@0.20.1 build

# elm-review
npx -p elm@0.19.1-6 -p elm-review@2.13.5 elm-review --config review
```

開発サーバーは必ず `HOST=127.0.0.1` を付けて起動すること。

- elm-land@0.20.1 は `HOST` 未指定時に `0.0.0.0`（全インターフェース）へバインドする。起動ログには「localhost」と表示されるが、同じネットワーク上の他端末からも接続できる状態になる
- elm-land は内部の Vite 5.2.8 を固定しており、dev server に既知の脆弱性（任意サイトからの応答読み取り、`server.fs.deny` 回避によるファイル読み取り）がある。さらに `server.fs.allow` がプロジェクトの2階層上まで広げられているため、リポジトリ外のファイルも読まれ得る
- そのため、起動中は同じブラウザで信頼できないサイトを開かず、確認が終わったらすぐに停止する

## Data

記事データは Firestore の `articles` コレクションから、認証なしの REST API で直接取得している（`src/Articles.elm`）。

Firestore Security Rules はこのリポジトリではなく [bizyutyu/b-infra](https://github.com/bizyutyu/b-infra) の `firestore.rules` で管理し、Pulumi でデプロイしている。ルールを変更するときは b-infra 側で行う。

- `articles` は公開読み取り（get / list とも）。`articles` に置いたドキュメントはすべて一覧から取得できるため、下書きは置かないこと
- それ以外のコレクションは読み書きとも拒否

## Deploying to production

`main` への push で `.github/workflows/deploy.yml` が Firebase Hosting へデプロイする。
