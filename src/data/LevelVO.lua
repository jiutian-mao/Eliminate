--关卡数据实体类
local LevelVO = class("LevelVO")

function LevelVO:ctor(json)
    self.id = json.id
    self.star = json.star
    self.highScore = json.highScore
    self.row = json.row or 8
    self.col = json.col or 8
    self.spacing = json.spacing
    self.elementNum = json.elementNum
    self.width = json.width
    self.height = json.height
    self.step = json.step
    self.goals = json.goals
    self.scoreLevelRate = json.scoreLevelRate
end

function LevelVO:create(json)
    local level = LevelVO.new(json)
    return level
end

return LevelVO