## 必要なもの
* Node.js, npm
* GraphicsMagick (スプライトの生成に使う)

## Instaration

1. GraphicsMagick をインストール
  ```sh
  brew install graphicsmagick
  ```

2. npm install する
  ```
  npm install
  ```

## コマンド

### options

* --src source-directory
* --dest destination-directory
* --release release build
* --sp convert enviroment to smartphone mode

**オプションは、すべて"--"を挟む**

```
npm run build -- --release
```

### npm run serve

0.0.0.0:9000 にサーバを立てる

### npm run watch

jade, stylus, coffee の監視

### npm run build

ビルド  

### npm run sprite -- --dir directory_name

スプライト画像と、スプライト用のstylusを作る  
パスは、src/imgからの相対パス  

src/stylus/sprite/directory_name.styl  
にスプライト用の mixin が記述された stylus 用のファイルが書き出される  

### npm test

test/ 以下のテストを走らせる。  
phantom とかは入れてないので、ユニットテストだけ

## ファイル構成について

### base.jade, base.styl

ベースファイル
* ブロックやユーティリティなどの読み込み。  
* 最終的なコンテンツに依存するような内容は書かない。  
* いじるべきではない。

### index.jade, style.styl, app.coffee

エントリポイント  
* モジュールとパーツの読み込み。
* 容易に移植できることを心がける。ex. index.jade の内容を some-page.jade の .content 内に埋める・・・とか
* ヘッダとかフッタとかの共通パーツのテンプレートを書くのもここ

### partial/**/*.jade, partial/**/*.styl, partial/**/*.coffee

パーツ

* サイトのパーツを切り分けて書く
* セクションとか
* ファイルが見やすくなるまでガンガン分割する

### module/**/*.jade, module/**/*.styl, module**/*.coffee

独立したモジュール
* 機能的に独立し、使いまわせるモジュールを書く
* ソーシャルボタンとか

### CSS の独立性を維持するために

module は、**"全体をラッパでくくったスタイルを記述すべき"**  
partial は、**"全体をラッパでくくらないスタイルを記述すべき"**

例:
```jade
.slug
  .section
    .some-content
      .some-module
```

```style.styl
@import module/some-module
.slug
  .section
    @import partial/some-partial
```

```module/some-module.styl
.some-module
  module styles
```

```partial/some-partial.styl
&
  partial style
```

このようにすることで、コンテンツの移植が用意になる
