visibleSize = cc.Director:getInstance():getVisibleSize()
origin = cc.Director:getInstance():getVisibleOrigin()

--tag标记，统一管理
TAG_MOVE = 10
TAG_DELAY = 11
TAG_TIPS = 12
TAG_TIMER = 13

MUSIC_GAME = {
    BG = "sound/bgm_game.wav",
    SELECT = "sound/A_select.wav",
    FALSEMOVE = "sound/A_falsemove.wav",
    MATCH = "sound/A_combo1.wav"
}