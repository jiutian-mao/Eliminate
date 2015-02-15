require "src/util/MotionUtil"

Timer = class("Timer",function(node,handler, interval,repeatCount)
    local t = {}
    return t
end)

Timer.currentCount = 0
Timer.repeatCount = 9999999999
Timer.interval = 0
Timer.running = false
Timer.node = nil
Timer.handler = nil
Timer.action = nil
--创建计时器
function Timer:create(node,handler, interval,repeatCount)
    local t = Timer.new(node,handler, interval,repeatCount)
    return t
end

local function getAction(interval,callBack)
--    local delay = cc.DelayTime:create(interval)
--    local sequence = cc.Sequence:create({delay,cc.CallFunc:create(callBack)})
    local delay = MotionUtil:delayCallFunc(interval,callBack)
    local rep = cc.RepeatForever:create(delay)
    return rep
end


function Timer:init(node,handler,interval,repeatCount)
    
    self.node = node
    self.handler = handler
    if repeatCount ~= nil then
        self.repeatCount = repeatCount
    end
    self.interval = interval
end

function Timer:ctor(node,handler, interval,repeatCount)
    self:init(node,handler, interval,repeatCount)
end

function Timer:start()
    
    local function timerHandler()
        if self.currentCount >= self.repeatCount then
            self:stop()
            return
        end
        self.handler();
        self.currentCount = self.currentCount + 1
    end
    
    if self.action == nil then
        self.action = getAction(self.interval,timerHandler)
    end
    self.node:runAction(self.action)
	self.running = true
end

function Timer:stop()
    self.node:stopAction(self.action)
    self.action = nil
    self.running = false
end

function Timer:reset()
    self:stop()
    self.currentCount = 0
    self:init(self.node,self.handler,self.interval,self.repeatCount)
    self:start()
    return self
end