require "Cocos2d"

-- cclog
local cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    cc.FileUtils:getInstance():addSearchPath("src")
    cc.FileUtils:getInstance():addSearchPath("res")
    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
        cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(540,660,cc.ResolutionPolicy.NO_BORDER)
    else
        cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(560,960,cc.ResolutionPolicy.NO_BORDER)
    end
   
    local scene = require("src/view/scene/LevelScene")
    local gameScene = scene:createScene()
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(gameScene)
    else
        cc.Director:getInstance():runWithScene(gameScene)
    end
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
