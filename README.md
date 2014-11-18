## 必要なもの
* Node
* gulp
* GraphicsMagick (スプライトの生成に使う)

## Instaration

1. GraphicsMagick をインストール
  ```sh
  brew install graphicsmagick
  ```

2. gulp をグローバルにインストール
  ```sh
  npm install gulp -g
  ```

3. npm install する
  ```
  npm install
  ```

##gulp コマンド

--release をつけると、リリース用のパスで実行

### gulp

* gulp jade
* gulp stylus
* gulp coffeeify (coffee + browserify)
* gulp copy-*

を全部やる

### gulp watch

jade, stylus, coffee の監視

### gulp sprite --dir directory_name

スプライト画像と、スプライト用のstylusを作る  
パスは、src/imgからの相対パス  

src/stylus/sprite/directory_name.styl  
にスプライト用の mixin が記述された stylus 用のファイルが書き出される  
