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
