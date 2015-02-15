--关卡管理
LevelManager = {}
local level = nil
local levelConfigDri = "res/levelData/"
local levelConfigName = "levelConfig.txt"

function LevelManager:new(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    
    --初始化
    local full = cc.FileUtils:getInstance():fullPathForFilename(levelConfigDri..levelConfigName)
    local str = cc.FileUtils:getInstance():getStringFromFile(full)
    local json = require("json")
    level = json.decode(str)
    return o
end

function LevelManager:getInstance()
    if self._instance == nil then
        self._instance = self:new()
    end
    return self._instance
end 

function LevelManager:getLevelData(index)
	local full = cc.FileUtils:getInstance():fullPathForFilename(levelConfigDri.."level_"..index..".json")
    local str = cc.FileUtils:getInstance():getStringFromFile(full) 
    local levelVo = require("src/data/LevelVO")
    local json = require("json")
    local jsonObj = json.decode(str)
    jsonObj.id = index
    local data = levelVo:create(jsonObj)
	return data
end

function LevelManager:getMaxLevel()
    return level.maxLevel
end

function LevelManager:getLevelStar(index)
    return level.levelArr[index]
end

function LevelManager:setLevelResult(levelVo,score)
    local isSend = false
    
    --获得关卡得分星级
    local i = 1
    while levelVo.scoreLevelRate[i] ~= nil and score > levelVo.scoreLevelRate[i] do
    	i = i + 1
    end
    print("星级:"..i)
    if(not level.levelArr[levelVo.id] or level.levelArr[levelVo.id] < i) then
        level.levelArr[levelVo.id] = i
        levelVo.star = i
        isSend = true
    end
    
    --设置最大可玩关卡
    if level.maxLevel <= levelVo.id then
        level.maxLevel = level.maxLevel + 1
        isSend = true
    end
    if isSend then 
        self:sendLevelData() 
    end
end

function LevelManager:sendLevelData()
    local json = require("json")
    local data = json.encode(level)
    --local full = cc.FileUtils:getInstance():fullPathForFilename(levelConfigDri)
    local full = cc.FileUtils:getInstance():fullPathForFilename("levelData/")
    local p = my.CustomFile:writeFile(data,full,levelConfigName)
    print(p)
end


---------------------------
--@param
--@return
function LevelManager:runGameScene(id)
    local gameStart = os.clock()
    local levelVO = self:getLevelData(id)
    levelVO.id = id
    local GameScene = require("src/view/scene/GameScene")
    local game = GameScene:createScene(levelVO)
    if cc.Director:getInstance():getRunningScene() then
        local fade = cc.TransitionFade:create(0.7,game)
        cc.Director:getInstance():replaceScene(fade)
        local gameEnd = os.clock()
        print("创建时间:",gameStart,gameEnd,gameEnd - gameStart)
    else
        cc.Director:getInstance():runWithScene(game)
    end
end

return LevelManager