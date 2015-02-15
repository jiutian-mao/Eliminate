#include "PlatfromManage.h"
#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <jni.h> 
#include "platform\android\jni\JniHelper.h"
#endif

PlatfromManage* PlatfromManage::instance = nullptr;
PlatfromManage* PlatfromManage::getInstance()
{
	if(!instance){
		instance = new PlatfromManage();
	}
	return instance;
};

int PlatfromManage::getTest()
{
	return test;
};

void PlatfromManage::exitGame()
{
	CCLOG("C++ exitGame");
	#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	JniMethodInfo info;
	bool ret = JniHelper::getStaticMethodInfo(info,"org/cocos2dx/lua/AppActivity","exitGame","()V");
	if (ret)
	{
		log("call method succeed");
		info.env->CallStaticVoidMethod(info.classID,info.methodID);
	}
	return;
	#endif

	#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
			Director::getInstance()->end();
			exit(0);
	#endif
};

PlatfromManage::PlatfromManage(){};
PlatfromManage::~PlatfromManage(){};