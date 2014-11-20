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

### npm run watch

jade, stylus, coffee の監視

### npm run build

release フォルダにビルド

### npm test

mocha と phantomで書かれたテストが走る
たぶんね

### npm run sprite --dir directory_name

スプライト画像と、スプライト用のstylusを作る  
パスは、src/imgからの相対パス  

src/stylus/sprite/directory_name.styl  
にスプライト用の mixin が記述された stylus 用のファイルが書き出される  
