MotionUtil = {}

----------------------
-- 对象方法转换处理函数，格式：handler(obj,obj.method)
-- @param obj 调用对象
-- @param method 调用方法
-- @return 匿名调用函数
function handler(obj,method)
    return function(...)
        return method(obj,...)
    end
end


function MotionUtil:delayCallFunc(time,callback,parament)
    parament = parament or {}
    local delay = cc.DelayTime:create(time)
    local func = cc.CallFunc:create(callback,parament)
    local seq = cc.Sequence:create({delay,func})
    seq:setTag(TAG_DELAY)
    return seq
end

function MotionUtil:touchPointToNode(rect,col,row)

end

--根据触摸点坐标获取指定grid索引
function MotionUtil:touchPointToCell(rect,col,row)
    local cellX = math.modf((rect.x) / rect.width)
    local cellY = math.modf((rect.y) / rect.height)
    local cell = {}
    cell.x = cellX + 1
    cell.y = cellY + 1
    if cell.x > col or rect.x < -rect.width/2 or 
        cell.y > row or rect.y < -rect.height/2 then
        cell = nil
    end
    return cell
end

----------------------
--获取触屏node对象
---- @param #touch
---- @param #event 
---- @return bool(是否目标触屏对象);node(当前触屏对象)
function MotionUtil:touchNodeToNode(touch,event)
    local node = event:getCurrentTarget()
    local size = node:getContentSize()
    local rect = cc.rect(0,0,size.width,size.height)
    local point = node:convertTouchToNodeSpace(touch)
    if cc.rectContainsPoint(rect,point) then
        return true,node
    end 
    return false,node
end

--按键控制-退出游戏
function MotionUtil:exitGame(keyCode,pEvent)
    if keyCode == cc.KeyCode.KEY_ESCAPE or keyCode == cc.KeyCode.KEY_BACKSPACE
        or keyCode == 6 then
        if(PlatfromManage ~= nil) then
            --调用自定义C++导出类，实现平台控制
            PlatfromManage:getInstance():exitGame();
        else
            cc.Director:getInstance():endToLua()
        end
    end
end
