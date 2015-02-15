#include "HelloWorldScene.h"
//#include "AppMacros.h"
#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "cocos2d.h"
#include "Runtime.h"
#include "ConfigParser.h"
//#include "assets-manager\AssetsManager.h" 
#include "lua_PlatfromManage_auto.hpp"
#include "PlatfromManage.h"
//#include "Upgrade.h"
USING_NS_CC;


Scene* HelloWorld::scene()
{
    // 'scene' is an autorelease object
    auto scene = Scene::create();
    
    // 'layer' is an autorelease object
    HelloWorld *layer = HelloWorld::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool HelloWorld::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !Layer::init() )
    {
        return false;
    }
	#if (COCOS2D_DEBUG>0)
	  initRuntime();
	#endif
    
    if (!ConfigParser::getInstance()->isInit()) {
            ConfigParser::getInstance()->readConfig();
        }
    // initialize director
  auto director = Director::getInstance();
    auto glview = director->getOpenGLView();    
    if(!glview) {
        Size viewSize = ConfigParser::getInstance()->getInitViewSize();
        string title = ConfigParser::getInstance()->getInitViewName();
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
        extern void createSimulator(const char* viewName, float width, float height,bool isLandscape = true, float frameZoomFactor = 1.0f);
        bool isLanscape = ConfigParser::getInstance()->isLanscape();
        createSimulator(title.c_str(),viewSize.width,viewSize.height,isLanscape);
#else
        glview = GLView::createWithRect(title.c_str(), Rect(0,0,viewSize.width,viewSize.height));
        director->setOpenGLView(glview);
#endif
    }
	auto engine = LuaEngine::getInstance();

    ScriptEngineManager::getInstance()->setScriptEngine(engine);

    LuaStack* stack = engine->getLuaStack();
    stack->setXXTEAKeyAndSign("2dxLua", strlen("2dxLua"), "XXTEA", strlen("XXTEA"));
	PlatfromManage::getInstance()->test = 10;
    lua_State *L = stack->getLuaState();
	lua_getglobal(L, "_G");
	register_all_PlatfromManage(L);
	lua_settop(L, 0);
	
	//register_all_MyClass(engine->getLuaStack()->getLuaState());
    //register custom function
    //LuaStack* stack = engine->getLuaStack();
    //register_custom_function(stack->getLuaState());
	
	
//#if (COCOS2D_DEBUG>0)
//    if (startRuntime())
//        return true;
//#endif
		//运行下载文件hello.lua 
    string runLua = CCFileUtils::sharedFileUtils()->fullPathForFilename("hello.lua"); 
    //engine->executeScriptFile(runLua.c_str()); 
    engine->executeScriptFile(ConfigParser::getInstance()->getEntryFile().c_str());
    return true;
    
    auto visibleSize = Director::getInstance()->getVisibleSize();
    auto origin = Director::getInstance()->getVisibleOrigin();

    /////////////////////////////
    // 2. add a menu item with "X" image, which is clicked to quit the program
    //    you may modify it.

    // add a "close" icon to exit the progress. it's an autorelease object
    auto closeItem = MenuItemImage::create(
                                        "CloseNormal.png",
                                        "CloseSelected.png",
                                        CC_CALLBACK_1(HelloWorld::menuCloseCallback,this));
    
    closeItem->setPosition(origin + Vec2(visibleSize) - Vec2(closeItem->getContentSize() / 2));

    // create menu, it's an autorelease object
    auto menu = Menu::create(closeItem, NULL);
    menu->setPosition(Vec2::ZERO);
    this->addChild(menu, 1);
    
    /////////////////////////////
    // 3. add your codes below...

    // add a label shows "Hello World"
    // create and initialize a label
    
    auto label = LabelTTF::create("Hello World", "Arial", 36);
    
    // position the label on the center of the screen
    label->setPosition(Vec2(origin.x + visibleSize.width/2,
                            origin.y + visibleSize.height - label->getContentSize().height));

    // add the label as a child to this layer
    this->addChild(label, 1);

    // add "HelloWorld" splash screen"
   // auto sprite = Sprite::create("HelloWorld.png");

    // position the sprite on the center of the screen
   // sprite->setPosition(Vec2(visibleSize / 2) + origin);

    // add the sprite as a child to this layer
    //this->addChild(sprite);
    
	//用下载的资源，创建一个3D精灵
	std::string fileName = "3D/tortoise.c3b";
	auto sprite3D = Sprite3D::create(fileName);
	sprite3D->setScale(0.2f);
	auto s = Director::getInstance()->getWinSize();
	//sprite3D->setPosition(Vec2(s.width * 4.f / 5.f, s.height / 2.f));
	sprite3D->setPosition3D(Vec3(s.width * 4.f / 5.f, s.height / 2.f, 0));

	this->addChild(sprite3D, 3);
	auto animation = Animation3D::create("3D/tortoise.c3b");

	if (animation)
	{
		auto animate = Animate3D::create(animation, 0.f, 10.0f);
		sprite3D->runAction(RepeatForever::create(animate));
	}

    return true;
}

void HelloWorld::menuCloseCallback(Ref* sender)
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WP8) || (CC_TARGET_PLATFORM == CC_PLATFORM_WINRT)
	MessageBox("You pressed the close button. Windows Store Apps do not implement a close button.","Alert");
    return;
#endif

    Director::getInstance()->end();

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    exit(0);
#endif
}
