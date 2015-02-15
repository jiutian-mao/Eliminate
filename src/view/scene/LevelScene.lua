require "src/view/scene/GameScene"
require "GlobalVariables"
require "src/control/LevelManager"
require "src/util/MotionUtil"

local LevelScene = class("LevelScene",function()
    return cc.Layer:create()
end)

function LevelScene:createScene()
    local scene = cc.Scene:create()
    local layer = LevelScene.new()
    scene:addChild(layer)
    return scene
end

function LevelScene:ctor()
    self.lm = LevelManager:getInstance()
    self:initData()
    self:initKeyboard()
    self:initView()
end

function LevelScene:initData()
    self.currentLevel = self.lm:getMaxLevel()
    self.levelList = {}
    for i=1,20 do--20关
        self.levelList[i] = false
    end
end

function LevelScene:initKeyboard()
    local keyboard = cc.EventListenerKeyboard:create()
    keyboard:registerScriptHandler(handler(MotionUtil,MotionUtil.exitGame),cc.Handler.EVENT_KEYBOARD_RELEASED)--lua中用RELEASED,还有个值为PELEASED
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(keyboard,self)
end

function LevelScene:onTouchHandler(touch,event)
    local bool,node = MotionUtil:touchNodeToNode(touch,event)
    if bool then
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
        print("level-tag:",node:getTag())
        local id = node:getTag()
        self.lm:runGameScene(id)
        return true
    end
    print("level-tag:",node:getTag())
    return false
end

function LevelScene:initView()
    
    Resources:addSpriteFrames("res/source/Level_Source.plist")
    local centerX = (origin.x * 2 + visibleSize.width) /2
    
    local spr = cc.Sprite:create("res/game/menu_bg.png")
    spr:setPosition(centerX,(origin.y * 2 + visibleSize.height)/2)
    self:addChild(spr)
    
    local eventDispatcher = self:getEventDispatcher()
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(handler(self,self.onTouchHandler),cc.Handler.EVENT_TOUCH_BEGAN)
    listener:setSwallowTouches(true)
    
    local colLen = 4
    local rowLen = 4
    local count = 1
    for j =  -rowLen/2,rowLen/2 do
        for i = colLen/2,-colLen/2,-1 do
            local lock = nil
            if count <= self.currentLevel then
                lock = cc.Sprite:createWithSpriteFrameName("UnLock.png")
                eventDispatcher:addEventListenerWithSceneGraphPriority(listener:clone(),lock)
                --添加关卡星级显示
                local starNum = self.lm:getLevelStar(count) or 0
                for i = 0,starNum-1 do
                    local star = cc.Sprite:createWithSpriteFrameName("Star_Small.png")
                    star:setPosition(19+i*16,16)
                    lock:addChild(star)
                end
                
                --添加关卡编号
                local levelNum = my.CustomLabel:createWithCharMap("res/fonts/digital_level.png",31,29,0)
                levelNum:setString(count.."")
                levelNum:setPosition(35,55)
                lock:addChild(levelNum)
                
            else
                lock = cc.Sprite:createWithSpriteFrameName("Lock.png")
            end
            lock:setPosition(centerX - i * (lock:getContentSize().width+5),
            visibleSize.height / 2 -  j * (lock:getContentSize().height + 5))
            lock:setTag(count)
            self:addChild(lock)
            count = count + 1
        end
    end
end

return LevelScene