Resources = {}
local stringFileName = "res/string.plist"
local map = nil

-----
--return string.plist文件String字段
function Resources:getString(key)
    if(map == nil) then
        local file = cc.FileUtils:getInstance():fullPathForFilename(stringFileName)
        map = cc.FileUtils:getInstance():getValueMapFromFile(file)
    end
    return map[key]
end

---------------------------
-- SpriteFrameCache类方法简写
--@return 
function Resources:addSpriteFrames(plist)
    cc.SpriteFrameCache:getInstance():addSpriteFrames(plist)
end

---------------------------
-- SpriteFrameCache类方法简写
--@return 
function Resources:removeSpriteFrameByName(plist)
    cc.SpriteFrameCache:getInstance():removeSpriteFrameByName(plist)
end

return Resources