HIRAGINO_GOTHIC = "\"Hiragino Kaku Gothic ProN\", \"ヒラギノ角ゴ ProN W3\""
YU_GOTHIC = "YuGothic, \"游ゴシック\""
HIRAGINO_MINCHO = "\"Hiragino Mincho ProN\", \"ヒラギノ明朝 ProN W3\""
YU_MINCHO = "YuMincho, \"游明朝\""
MEIRYO = "Meiryo, \"メイリオ\""

DOMAIN "example.org"
PATH = "/"
URL = "http://#{DOMAIN}#{PATH}"

module.exports =
  pixelRatio: 2
  isPc: false

  meta:
    slug: "peraichi"
    title: "ページタイトル"
    keywords: "キーワード"
    description: "ディスクリプション"
    url: URL
    ogImage: "#{URL}img/ogp.jpg"

  font:
    gothic: "#{YU_GOTHIC}, #{HIRAGINO_GOTHIC}, #{MEIRYO}, sans-serif"
    mincho: "#{YU_MINCHO}, #{HIRAGINO_MINCHO}, #{MEIRYO}, sans-serif"
  
  layout:
    width: 320
