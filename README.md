## 必要なもの
* Node.js, npm
* GraphicsMagick (スプライトの生成に使う)

## Installation

1. GraphicsMagick をインストール
  ```sh
  brew install graphicsmagick
  ```

2. npm install する
  ```
  npm install
  ```

## コマンド

### npm run serve

0.0.0.0:9000 にサーバを立てる

### npm run watch

jade, stylus, coffee の監視

### npm run build

ビルド  

### npm run bower

bower install のあと、
main ファイルを src/js/lib 以下に吐き出す

### npm run sprite -- --dir directory_name

スプライト画像と、スプライト用のstylusを作る  
パスは、src/imgからの相対パス  

src/stylus/sprite/directory_name.styl  
にスプライト用の mixin が記述された stylus 用のファイルが書き出される  

### npm test

test/ 以下のテストを走らせる。  
phantom とかは入れてないので、ユニットテストだけ

#### コマンドオプション

全部共通です。

* --src source directory
* --dest destination directory
* --release release build
* --pc switch enviroment to pc mode

**オプションは、すべて"--"を挟む**

```
npm run build -- --release
```

## ファイル構成について

### base.jade, base.styl

* ブロックやユーティリティなどの読み込み。  
* ミックスインなどのユーティリティもここ

### index.jade, style.styl, app.coffee

* エントリポイント  
* モジュールとパーツの読み込み。

### partial/\*\*/\*.jade, partial/\*\*/\*.styl, partial/\*\*/\*.coffee

* サイトのパーツを切り分けて書く
* セクションとか
* ファイルが見やすくなるまでガンガン分割する

### module/\*\*/\*.jade, module/\*\*/\*.styl, module/\*\*/\*.coffee

* 機能的に独立し、使いまわせるモジュールを書く
* ソーシャルボタンとか

### CSS の独立性を維持するために

module や partial は、**"全体をラッパでくくらないスタイルを記述すべき"**

#### 例

index.jade
```jade
.slug
  .some-section
    // some content
```

style.styl
```
.slug
  .some-section
    @import partial/some-section
```
