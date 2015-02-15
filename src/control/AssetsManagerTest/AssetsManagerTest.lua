-- 获取目标平台
local targetPlatform = cc.Application:getInstance():getTargetPlatform()

local lineSpace = 40 -- 行间距
local itemTagBasic = 1000 
local menuItemNames =
{
    "enter",
    "reset",
    "update",
}

-- 获取屏幕大小
local winSize = cc.Director:getInstance():getWinSize()

-- 更新层
local function updateLayer()
    -- 首先创建一个层
    local layer = cc.Layer:create()

    local support  = false
    -- 判断是否支持iphone、ipad、win32、android或者mac
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) 
        or (cc.PLATFORM_OS_WINDOWS == targetPlatform) or (cc.PLATFORM_OS_ANDROID == targetPlatform) 
        or (cc.PLATFORM_OS_MAC  == targetPlatform) then
        support = true
    end

    -- 如果不支持平台
    if not support then
        print("Platform is not supported!")
        return layer
    end

    local isUpdateItemClicked = false -- 是否更新项被点击
    local assetsManager       = nil -- 资源管理器对象
    local pathToSave          = ""  -- 保存路径

    local menu = cc.Menu:create() -- 菜单
    menu:setPosition(cc.p(0, 0))  -- 设置菜单位置
    cc.MenuItemFont:setFontName("Arial")-- 设置菜单字体样式
    cc.MenuItemFont:setFontSize(24) -- 设置字体大小

    -- 用于更新的标签
    --local progressLable = cc.Label:createWithTTF("",s_arialPath,30)
    local progressLable = cc.Label:create()
    progressLable:setSystemFontSize(42)
    progressLable:setAnchorPoint(cc.p(0.5, 0.5))
    progressLable:setPosition(cc.p(140,50))
    layer:addChild(progressLable)

    -- 下载目录
    --pathToSave = createDownloadDir()

    -- 下载错误回调
    local function onError(errorCode)
        -- 没有新版本
        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
            progressLable:setString("no new version")
        elseif errorCode == cc.ASSETSMANAGER_NETWORK then
            -- 网络错误
            progressLable:setString("network error")
        end
    end

    -- 进度更新回调
    local function onProgress( percent )
        -- 显示下载进度
        local progress = string.format("downloading %d%%",percent)
        progressLable:setString(progress)
    end
    
    -- 下载成功方法回调
    local function onSuccess()
        progressLable:setString("downloading ok")
    end
  
    -- 获得资源管理器
    local function getAssetsManager()
        if nil == assetsManager then
            -- 创建一个资源管理器，第一个参数是zip包下载地址，第二个参数是版本文件，第三个参数是保存路径
            assetsManager = cc.AssetsManager:new("https://raw.github.com/samuele3hu/AssetsManagerTest/master/package.zip",
                                           "https://raw.github.com/samuele3hu/AssetsManagerTest/master/version",
                                           pathToSave)
            -- 保留所有权，该方法会增加Ref对象的引用计数
            assetsManager:retain()
            -- 设置一系列委托
            assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
            assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
            assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
            assetsManager:setConnectionTimeout(3)-- 设置连接超时
        end

        return assetsManager
    end

    -- 更新
    local function update(sender)
        progressLable:setString("")
        -- 调用AssetsManager的update方法
        getAssetsManager():update()
    end

    -- 重设
    local function reset(sender)
        progressLable:setString("")
        -- 删除下载路径
        deleteDownloadDir(pathToSave)
        
        -- 删除版本
        getAssetsManager():deleteVersion()
       
        -- 创建下载路径
        createDownloadDir()
    end

    -- 重新加载模块
    local function reloadModule( moduleName )

        package.loaded[moduleName] = nil
      
        return require(moduleName)
    end


    -- 进入
    local function enter(sender)
        -- 如果更新按钮没有被点击
        if not isUpdateItemClicked then
            local realPath = pathToSave .. "/package"
            addSearchPath(realPath,true)
        end
        
        -- 重新加载模块
        assetsManagerModule = reloadModule("src/AssetsManagerTest/AssetsManagerModule")

        assetsManagerModule.newScene(AssetsManagerTestMain)
    end

    -- 回调方法
    local callbackFuncs =
    {
        enter,
        reset,
        update,
    }

    -- 菜单回调方法
    local function menuCallback(tag, menuItem)
        local scene = nil
        local nIdx = menuItem:getLocalZOrder() - itemTagBasic
        local ExtensionsTestScene = CreateExtensionsTestScene(nIdx)
        if nil ~= ExtensionsTestScene then
            cc.Director:getInstance():replaceScene(ExtensionsTestScene)
        end
    end

    -- 遍历添加三个菜单项
    for i = 1, table.getn(menuItemNames) do
        local item = cc.MenuItemFont:create(menuItemNames[i])
        item:registerScriptTapHandler(callbackFuncs[i])-- 注册点击回调地址
        -- 设置三个菜单的位置
        item:setPosition(winSize.width / 2, winSize.height - i * lineSpace)
        if not support then
            item:setEnabled(false)
        end
        menu:addChild(item, itemTagBasic + i)
    end

    local function onNodeEvent(msgName)
        if nil ~= assetsManager then
            -- 释放资源
            assetsManager:release()
            assetsManager = nil
        end
    end

    -- 注册层的点击回调方法
    layer:registerScriptHandler(onNodeEvent)
    
    layer:addChild(menu)

    return layer
end

-------------------------------------
--  AssetsManager Test
-------------------------------------
function AssetsManagerTestMain()
    local scene = cc.Scene:create()
    scene:addChild(updateLayer())
   -- scene:addChild(CreateBackMenuItem())
    return scene
end
