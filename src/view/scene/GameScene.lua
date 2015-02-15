require "src/data/GameModel"
require "src/view/elements/Element"
require "src/control/GameControl"
require "src/util/MotionUtil"
require "src/util/Resources"
require "src/util/Timer"

local gm = require "src/data/GameModel"
local gc = require "src/control/GameControl"
local audio = cc.SimpleAudioEngine:getInstance()
local spacing = Element.WIDTH + 0

local GameScene = class("GameScene",function()
    return cc.Layer:create()
end)

function GameScene:createScene(levelVO,gameModel)
    local scene = cc.Scene:create()
    local layer = GameScene.new(levelVO)
    scene:addChild(layer)
    return scene
end

function GameScene:ctor(levelVO)
    self.levelVO = levelVO
    self.step = levelVO.step
    self.col = levelVO.col
    self.row = levelVO.row
    gm = require "src/data/GameModel"
    gc = require "src/control/GameControl"
    gm = gm.new()
    gc = gc.new(gm,self.col,self.row)
    self:initGameLayer()
    self:initGameInfoLabel()
    self:initMusic()
    self:initKeyboard()
    self:initGameGrid()
end



function GameScene:newxtLevel(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        LevelManager:getInstance():runGameScene(self.levelVO.id+1)
    end
end

function GameScene:resetGame(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        LevelManager:getInstance():runGameScene(self.levelVO.id)
    end
end

function GameScene:backGame(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local gameStart = os.clock()
        local level = require("src/view/scene/LevelScene")
        local scene = level:createScene()
        if cc.Director:getInstance():getRunningScene() then
            local fade = cc.TransitionFade:create(0.7,scene)
            cc.Director:getInstance():replaceScene(fade)
            local gameEnd = os.clock()
            print("创建时间:",gameStart,gameEnd,gameEnd - gameStart)
        else
            cc.Director:getInstance():runWithScene(scene)
        end
    end
end

function GameScene:endGame(isWin)

    --创建游戏结束相关VIEW
    local result = cc.Label:create()
    result:setSystemFontSize(42)
    result:setPosition((origin.x * 2 + visibleSize.width) / 2,origin.y * 2 + visibleSize.height / 2 + 100)
    self:addChild(result)
    
    if isWin then
        --记录关卡最大得分数、星级评分等
        LevelManager:getInstance():setLevelResult(self.levelVO,gm.sroce)
        result:setString("YOU WIN!!!")
    else
        result:setString("YOU LOSE!!!")
    end
    
    local node = ccs.GUIReader:getInstance():widgetFromJsonFile("res/menu/UIEdit_1.ExportJson")
    local baseBtn = ccui.Helper:seekWidgetByName(node, "myBtn")
    
    local ypos = 100
    if isWin then
        ypos = ypos - 50
        local nextLevelBtn = baseBtn:clone()
        nextLevelBtn:addTouchEventListener(handler(self,self.newxtLevel))
        nextLevelBtn:setPosition((origin.x * 2 + visibleSize.width) / 2,(origin.y * 2 + visibleSize.height) / 2 + ypos)
        nextLevelBtn:setTitleText(Resources:getString("nextLevel"))
        self:addChild(nextLevelBtn)
    end
    
    ypos = ypos - 50
    local repetBtn = baseBtn:clone()
    self:addChild(repetBtn)
    repetBtn:setPosition((origin.x * 2 + visibleSize.width) / 2,visibleSize.height/2 + ypos)
    repetBtn:setTitleText(Resources:getString("repeatGame"))
    repetBtn:addTouchEventListener(handler(self,self.resetGame))
    
    ypos = ypos - 50
    local backBtn = baseBtn:clone()
    self:addChild(backBtn)
    backBtn:setPosition((origin.x * 2 + visibleSize.width) / 2,(origin.y * 2 + visibleSize.height) / 2 + ypos)
    backBtn:setTitleText(Resources:getString("backLevel"))
    backBtn:addTouchEventListener(handler(self,self.backGame))

    self:destroy()
end

function GameScene:destroy()
    for col=1,self.col do
        for row = 1,self.row do
            local element = gm.grid[col][row]
            element:release()
        end
    end
    gm.grid = {}
    self.gameLayer:getEventDispatcher():removeEventListener(self.listener)
    self.gameLayer:removeAllChildren()
    self.tipsTime:stop()
    gm = nil
    gc = nil
end

function GameScene:initGameInfoLabel()

    --游戏得分
    local scoreLabel = cc.Label:create()
    scoreLabel:setSystemFontSize(32)
    scoreLabel:setPosition((origin.x * 2 + visibleSize.width)/2,
        self.gameLayer:getPositionY()-80)
    self.scoreLabel = scoreLabel
    self:addChild(scoreLabel)

    --游戏步数
    local stepLabel = cc.Label:create()
    stepLabel:setAnchorPoint(0,0.5)
    stepLabel:setAlignment(cc.TEXT_ALIGNMENT_LEFT)
    stepLabel:setSystemFontSize(32)
    stepLabel:setPosition(origin.x + visibleSize.width * 0.1,origin.y + visibleSize.height - 80)
    self.stepLabel = stepLabel
    self:addChild(stepLabel)
    
    --目标得分
    local goalsLabel  = cc.Label:create()
    goalsLabel:setAnchorPoint(1,0.5)
    goalsLabel:setAlignment(cc.TEXT_ALIGNMENT_RIGHT)
    goalsLabel:setSystemFontSize(32)
    goalsLabel:setPosition(origin.x + visibleSize.width - visibleSize.width * 0.1,origin.y + visibleSize.height - 80)
    goalsLabel:setString(Resources:getString("goalScore")..self.levelVO.goals)
    self.goalsLabel = goalsLabel
    self:addChild(goalsLabel)
    self:setStep(self.step)
    self:addScore(gm.sroce)
end

function GameScene:setStep(step)
    self.stepLabel:setString(Resources:getString("steps")..step)
end

function GameScene:addScore(v)
    gm.sroce = gm.sroce + v
    self.scoreLabel:setString(Resources:getString("gameScore")..gm.sroce)
end

function GameScene:createElement(col,row,type)
    if type == nil then
        type = math.random(1,self.levelVO.elementNum)
    end
    local element = Element:create(col,row,type)
    element:setScale(0.7)
    element:setPosition((col-1)*spacing, (row-1)*spacing)
    element:retain()
    return element
end

function GameScene:addNewElements()
    local count = 0
    for col=1,self.col do
        local len = 1
        for row = 1,self.row do
            local oldElement = gm.grid[col][row]
            if oldElement == false then
                local newElement = self:createElement(col,row)
                self.gameLayer:addChild(newElement)
                gm.grid[col][row] = newElement
                local y = spacing * (self.row-1) + len*spacing
                len = len+1
                count = count + 1
                newElement:setPositionY(y)
            end
        end
    end
    return count
end

----游戏提示设置
--@param isShow type boolean 显示或隐藏游戏提示,默认为显示
--
function GameScene:setGameTips(isShow)
    isShow = (isShow == nil) or isShow
    local tipsMatch = self.tipsMatch
    if tipsMatch ~= nil then
        --print(">>>>>>>>>>>>>>")
        for j = 1,#tipsMatch do
            --print("tipsMatch:", tipsMatch[j].col, tipsMatch[j].row,tipsMatch[j].type)
            --gm.grid[tipsMatch[j].col][tipsMatch[j].row]:setOpacity(50)
            local element = gm.grid[tipsMatch[j].col][tipsMatch[j].row]
            if isShow == true then
                element:showTips()
            else
                element:hideTips()
            end
        end

        if isShow == false then
            self.tipsMatch = nil
        end
        --print("<<<<<<<<<<<<<<<<\n") 
    else
        local matchList = gc:lookForPossibles()
        if #matchList > 0 then
            local i = math.random(1,#matchList)
            self.tipsMatch = matchList[i]
            self:setGameTips(isShow)
        end
    end 
end

----移除
--@param list type 匹配列表
--@param special type 被转换为特效元素的元素对象
function GameScene:removeElement(list,special,specia2)
    gm.isDropping = true
    local function moveElement()
        --移动元素
        for col=1, self.col do
            for row=1, self.row do
                local element = gm.grid[col][row]
                if(element ~= nil and element ~= false) then
                    local x = element:getPositionX()
                    local y = (row-1)*spacing
                    local curY = element:getPositionY()
                    if(curY ~= y) then
                        element:stopActionByTag(TAG_MOVE)
                        local move = cc.MoveTo:create(0.2,cc.vertex2F(x,y))
                        move:setTag(TAG_MOVE)
                        element:runAction(move)
                    end
                end
            end
        end

        local function repeatedChecking()
            --再次检查是否有匹配,有则递归消除
            local matchs = gc:lookForMatches()
            if #matchs ~= 0 then
                self:removeElement(matchs)
            else
                gm.isDropping = false
                self.tipsMatch = nil
                self.tipsTime:reset()
                --达到游戏目标
                if gm.sroce >= self.levelVO.goals then
                    self:endGame(true)
                else if(self.step==0) then
                    --步数用完,游戏结束,挑战失败
                    self:endGame(false)
                else if #(gc:lookForPossibles())<1 then
                    self:endGame(true)
                end 
                end
                end
            end
        end

        local delay = cc.DelayTime:create(0.21)
        local func = cc.CallFunc:create(repeatedChecking )
        local sque = cc.Sequence:create({delay,func})
        self:runAction(sque)

    end

    local function removeChild(element)
        local function release()
            if element:getParent() ~= nil then
                element:getParent():removeChild(element,false)
                element:release()
            end
        end
        element:gotoAndStop(Element.TAG_MATCH)
        gm.grid[element.col][element.row] = false
        --隐藏元素
        local fadeout = cc.FadeOut:create(0.3)
        local func = cc.CallFunc:create(release)
        local seq = cc.Sequence:create({fadeout,func})
        gc:affectAbove(element)
        element:runAction(seq)
    end

    --四消特效
    local function fourRemove(ele)
        -- local count = 0 
        for i = self.row,1,-1 do
            local element = gm.grid[ele.col][i]
            if element ~= nil and element ~= false then
                print("fourRemove ",gm.grid[element.col][i].col,"  ",gm.grid[element.col][i].row)
                -- count = count + 1
                removeChild(gm.grid[element.col][i])
                --removeChild(gm.grid[i][element.row])
            end
        end
    end
    for i=1,#list do
        local len = #list[i]
        local isSpe4 = special == nil and special == nil
        for j=1,#list[i] do
            local element = list[i][j]

            if len >= 4 and (element == special or element == specia2) and
                element.curTag ~= Element.TAG_SPECIAL then --手动交换时处理
                isSpe4 = false
                element:gotoAndStop(Element.TAG_SPECIAL)
            else if isSpe4 and len >= 4 and element.curTag ~= Element.TAG_SPECIAL then--自由掉落时处理
                isSpe4 = false
                element:gotoAndStop(Element.TAG_SPECIAL)
            else 
                if element ~= nil and element ~= false then
                    if element.curTag == Element.TAG_SPECIAL then
                        fourRemove(element)
                    else 
                        removeChild(element)
                    end
                end
            end
            end
        end
    end

    local function next()
        local count = self:addNewElements()
        self:addScore(count * 30)
        moveElement()
    end

    audio:playEffect(MUSIC_GAME.MATCH)
    local delay = MotionUtil:delayCallFunc(0.35,next)
    self:runAction(delay)
end

function GameScene:makeSwap(ele1,ele2)
    local p1 = cc.vertex2F(ele1:getPosition())
    local p2 = cc.vertex2F(ele2:getPosition())
    gm.isSwaping = true
    local count = 0
    local function createMoveTo(p)
        local move = cc.MoveTo:create(0.1,p)
        move:setTag(TAG_MOVE)
        return move
    end

    local function swapElement(node1,node2)
        local tempCol = ele1.col;
        local tempRow = ele1.row;
        ele1.col = ele2.col;
        ele1.row = ele2.row;
        ele2.col = tempCol;
        ele2.row = tempRow;
        gm.grid[ele1.col][ele1.row] = ele1
        gm.grid[ele2.col][ele2.row] = ele2
    end

    local function checkMatch()
        count = count+1
        if count == 2 then
            swapElement(ele1,ele2)
            local matchs = gc:lookForMatches();
            if #matchs == 0 then

                local function setIsSwaping()
                    gm.isSwaping = false;
                end

                self.gameLayer:runAction(MotionUtil:delayCallFunc(0.1,setIsSwaping))
                self:runAction(cc.DelayTime:create(0.1))
                --重置游戏元素,放回原位
                self.tipsTime:start()
                ele1:stopActionByTag(TAG_MOVE)
                ele2:stopActionByTag(TAG_MOVE)
                ele1:runAction(createMoveTo(p1))
                ele2:runAction(createMoveTo(p2))
                swapElement(ele1,ele2);
                audio:playEffect(MUSIC_GAME.FALSEMOVE)
            else
                gm.isSwaping = false
                self:setGameTips(false)
                self.step = self.step-1;
                self:setStep(self.step)
                self:removeElement(matchs,ele1,ele2)
            end
        end
    end
    self.tipsTime:stop()
    local checkFunc = cc.CallFunc:create(checkMatch)
    local squean = cc.Sequence:create({createMoveTo(p2),checkFunc})
    ele1:runAction(squean)

    local squean2 = cc.Sequence:create({createMoveTo(p1),checkFunc})
    ele2:runAction(squean2)
end

function GameScene:onTouchBegan(touch,event)
    if gm.isSwaping or gm.isDropping then return end

    local list = gc:lookForMatches()
    local p = self.gameLayer:convertTouchToNodeSpace( touch )
    local cell = MotionUtil:touchPointToCell(
        cc.rect(p.x + Element.WIDTH / 2,p.y + Element.HEIGHT / 2,
        Element.WIDTH,Element.HEIGHT),self.col,self.row)
    if cell == nil then return true end--判断是否在网格范围

    local element = gm.grid[cell.x][cell.y]
    local state = element.prevTag
    state = state or Element.TAG_NORMAL
    --print("onTouchBegan",element.col,element.row,p.x,p.y)
    local select = self.curSelectElement
    if select == nil or select.type == nil then
        element:gotoAndStop(Element.TAG_SELECT)
        select = element;
        audio:playEffect(MUSIC_GAME.SELECT)
    else if select == element then
        -- print("select",select.col,select.row)
        element:gotoAndStop(state)
        select = nil
        audio:playEffect(MUSIC_GAME.SELECT)
    else
        -- print("select",select.col,select.row)
        local state = select.prevTag
        state = state or Element.TAG_NORMAL
        select:gotoAndStop(state)
        if select.row == element.row and
            math.abs(select.col - element.col) == 1
            or select.col == element.col and
            math.abs(select.row - element.row) == 1 then
            self:makeSwap(select,element)
            select = nil
        else
            element:gotoAndStop(Element.TAG_SELECT)
            select = element
            audio:playEffect(MUSIC_GAME.SELECT)
        end
    end
    end
    self.curSelectElement = select
    --element:setCascadeOpacityEnabled(true)--设置继承父容器透明度
    --cc.Sprite:setOpacity(255)--透明度值为0-255

    return true;
end 

function GameScene:onTouchMove(touch,event)
    if gm.isSwaping or gm.isDropping then return end
    
    local p = self.gameLayer:convertTouchToNodeSpace( touch );
    local cell = MotionUtil:touchPointToCell(cc.rect(p.x + Element.WIDTH / 2,p.y + Element.HEIGHT / 2,
        Element.WIDTH,Element.HEIGHT),self.col,self.row)
    if cell == nil then return true end--判断是否在网格范围
    
    local select = self.curSelectElement
    local element = gm.grid[cell.x][cell.y]
    if(select == nil or select == element) then return end
    
    if select.row == element.row and
        math.abs(select.col - element.col) == 1
        or select.col == element.col and
        math.abs(select.row - element.row) == 1 then
        local state = select.prevTag
        state = state or Element.TAG_NORMAL
        select:gotoAndStop(state)
        self:makeSwap(select,element)
        select = nil
    end
    self.curSelectElement = select
    
end

function GameScene:initGameGrid()
    for i =1, self.col do
        gm.grid[i] = {}
    end
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))

    --预摆放游戏元素
    local function addPreElement(col,row)
        local element = {}
        element.type = math.random(1,self.levelVO.elementNum)
        gm.grid[col][row] = element
    end

    local function setType(list,type)
        for i=1, #list do
            list[i].type = type
        end
    end

    local matches
    repeat
        for col=1,self.col do
            for row = 1,self.row do
                addPreElement(col,row)
            end
        end
        --预摆放-固定位置
--        setType({gm.grid[2][4],gm.grid[4][4],gm.grid[5][4]},1)
--        setType({gm.grid[2][2],gm.grid[3][1],gm.grid[4][2],gm.grid[5][2]},1)
        --setType({gm.grid[3][3],gm.grid[3][4],gm.grid[5][6]},1)
--        print("预摆放:",os.clock())
        local matches = gc:lookForMatches(true)
    until #matches == 0--保证生成的网格不含三连、四连等

    for col=1,self.col do
        for row = 1,self.row do
            local element = self:createElement(col,row,gm.grid[col][row].type)
            self.gameLayer:addChild(element)
            gm.grid[col][row] = element
        end
    end

    --创建游戏提示
    self.tipsTime = Timer:create(self,handler(self,self.setGameTips),7)
    self.tipsTime:start()
end

function GameScene:initGameLayer()
    Resources:addSpriteFrames("res/game/game_bg.plist")
    Resources:addSpriteFrames("res/game/game.plist")
    Resources:addSpriteFrames("res/game/GameIcon.plist")
    
    local listener = cc.EventListenerTouchOneByOne:create()
    self.listener = listener
    listener:registerScriptHandler(handler(self,self.onTouchBegan),cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(handler(self,self.onTouchMove),cc.Handler.EVENT_TOUCH_MOVED)
    listener:setSwallowTouches(true)
    
    local bg = cc.Sprite:createWithSpriteFrameName("game_bg_starrySky.png")
    bg:setPosition((origin.x * 2 + visibleSize.width) /2,(origin.y * 2 + visibleSize.height)/2)
    self:addChild(bg)
    
    local layer = cc.Layer:create()
    layer:setPosition((origin.x * 2 + visibleSize.width - (self.col-1)*spacing)/2,
        (origin.y * 2 + visibleSize.height - (self.row - 1)*spacing)/2)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener,layer)
    self.gameLayer = layer
    self:addChild(layer)
end

function GameScene:initMusic()
    audio:preloadEffect(MUSIC_GAME.SELECT)
    audio:preloadEffect(MUSIC_GAME.FALSEMOVE)
    audio:preloadEffect(MUSIC_GAME.MATCH)
    audio:preloadMusic(MUSIC_GAME.BG)
    
    local function onEnter(event)
        if "enterTransitionFinish" == event then
            audio:playMusic(MUSIC_GAME.BG,true)
        end
    end
    self:registerScriptHandler(onEnter)
    
    --audio:playMusic(MUSIC_GAME.BG,true)
--    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
--        audio:stopMusic()
--        audio:setMusicVolume(0.1)
--        audio:setEffectsVolume(0.1)
--    end
end

function GameScene:initKeyboard()
    local keyboard = cc.EventListenerKeyboard:create()
    keyboard:registerScriptHandler(handler(MotionUtil,MotionUtil.exitGame),
    cc.Handler.EVENT_KEYBOARD_RELEASED)--lua中用RELEASED,还有个值为PELEASED
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(keyboard,self)
end

return GameScene
