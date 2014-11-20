colors = require "colors"
_ = require "lodash"

module.exports = (msg, t) ->
  ws = (n) -> _.reduce [0...n], ((s) -> s + " "), ""
  shiftedRainbow = (msg, t) ->
    n = t * 5 | 0
    (colors.rainbow (ws n) + msg).substring n
  max = 10
  faceSize = 3
  face = "’ω’   "
  faceLen = face.length
  faceDouble = face+face
  t = 0 if not t?
  facePosMax = faceLen - faceSize
  facePos = Math.floor faceLen * t
  faceClipped = faceDouble.substring facePos, facePos + faceSize
  
  len = msg.length
  paddingLen = ((max - len) / 2 | 0) + 1
  padding = ws paddingLen
  s = padding + msg + padding

  console.log ""
  console.log colors.yellow "    ＿人人人人人＿"
  console.log colors.yellow "   ＞#{s.toUpperCase()}＜"
  console.log colors.yellow "   ￣Y^Y^Y^Y^Y^Y￣"
  console.log (
    shiftedRainbow " ▂▅▇█▓▒░", t) +
    "(#{faceClipped})" +
    (shiftedRainbow "░▒▓█▇▅▂", 1-t
    )
