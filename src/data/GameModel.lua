local GameModel = class("GameModel")
--分数
GameModel.sroce = 0
-- 交换中
GameModel.isSwaping = false
--是否坠落中
GameModel.isDropping = false
--游戏主网格
GameModel.grid = {}

return GameModel