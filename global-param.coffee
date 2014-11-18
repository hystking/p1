HIRAGINO_GOTHIC = "\"Hiragino Kaku Gothic ProN\", \"ヒラギノ角ゴ ProN W3\""
YU_MINCHO = "YuMincho, \"游明朝\""
HIRAGINO_MINCHO = "\"Hiragino Mincho ProN\", \"ヒラギノ明朝 ProN W3\""
MEIRYO = "Meiryo, \"メイリオ\""

module.exports =
  meta:
    title: "ページタイトル"
    keywords: "キーワード"
    description: "ディスクリプション"
    url: "http://example.org/"

  layout:
    width: "900px"

  font:
    gothic: "#{HIRAGINO_GOTHIC}, #{MEIRYO}, sans-serif"
    mincho: "#{YU_MINCHO}, #{HIRAGINO_MINCHO}, #{MEIRYO}, sans-serif"

  color:
    main: "#666"
    sub: "#ccc"
