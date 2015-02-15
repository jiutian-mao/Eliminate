#include "Upgrade.h"
#include "HelloWorldScene.h"

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
#include <dirent.h>
#include <sys/stat.h>
#endif

USING_NS_CC;
USING_NS_CC_EXT;

#define DOWNLOAD_FIEL		"download"	//下载后保存的文件夹名

Upgrade::Upgrade():
_pathToSave(""),
_showDownloadInfo(NULL)
{

}

Upgrade::~Upgrade()
{
	AssetsManager* assetManager = getAssetManager();
	CC_SAFE_DELETE(assetManager);
}

bool Upgrade::init()
{
	if (!CCLayer::init())
	{
		return false;
	}
	Size winSize = Director::getInstance()->getWinSize();
	initDownloadDir();
	_showDownloadInfo = Label::createWithSystemFont("", "Arial", 20);
	this->addChild(_showDownloadInfo);
	_showDownloadInfo->setPosition(Vec2(winSize.width / 2, winSize.height / 2 - 20));


	auto itemLabel1 = MenuItemLabel::create(
		Label::createWithSystemFont("Reset", "Arail", 20), CC_CALLBACK_1(Upgrade::reset, this));
	auto itemLabel2 = MenuItemLabel::create(
		Label::createWithSystemFont("Upgrad", "Arail", 20), CC_CALLBACK_1(Upgrade::upgrade, this));

	auto menu = Menu::create(itemLabel1, itemLabel2, NULL);
	this->addChild(menu);

	itemLabel1->setPosition(Vec2(winSize.width / 2, winSize.height / 2 + 20));
	itemLabel2->setPosition(Vec2(winSize.width / 2, winSize.height / 2 ));

	menu->setPosition(Vec2::ZERO);

	return true;
}

void Upgrade::onError(AssetsManager::ErrorCode errorCode)
{
	if (errorCode == AssetsManager::ErrorCode::NO_NEW_VERSION)
	{
		_showDownloadInfo->setString("no new version");
	}
	else if (errorCode == AssetsManager::ErrorCode::NETWORK)
	{
		_showDownloadInfo->setString("network error");
	}
	else if (errorCode == AssetsManager::ErrorCode::CREATE_FILE)
	{
		_showDownloadInfo->setString("create file error");
	}else if(errorCode == AssetsManager::ErrorCode::UNCOMPRESS)
	{
		_showDownloadInfo->setString("can not read file global information");
	}
}

void Upgrade::onProgress(int percent)
{
	if (percent < 0)
		return;
	char progress[20];
	snprintf(progress, 20, "download %d%%", percent);
	_showDownloadInfo->setString(progress);
}

void Upgrade::onSuccess()
{
	CCLOG("download success");
	_showDownloadInfo->setString("download success");
	std::string path = FileUtils::getInstance()->getWritablePath() + DOWNLOAD_FIEL;
	//FileUtils::getInstance()->addSearchPath(path, true);
	auto scene = HelloWorld::scene();
	Director::getInstance()->replaceScene(scene);
}

AssetsManager* Upgrade::getAssetManager()
{
	static AssetsManager *assetManager = NULL;
	if (!assetManager)
	{
		assetManager = new AssetsManager("http://pre-d.eims.com.cn/download/sp2p/zqm/hello.zip",
			"http://shezzer.sinaapp.com/downloadTest/version.php",
			_pathToSave.c_str());
		assetManager->setDelegate(this);
		assetManager->setConnectionTimeout(3);
	}
	return assetManager;
}

void Upgrade::initDownloadDir()
{
	CCLOG("initDownloadDir");
	_pathToSave = CCFileUtils::getInstance()->getWritablePath();
	_pathToSave += DOWNLOAD_FIEL;
CCLOG("Path: %s", _pathToSave.c_str());
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
	DIR *pDir = NULL;
	pDir = opendir(_pathToSave.c_str());
	if (!pDir)
	{
		mkdir(_pathToSave.c_str(), S_IRWXU | S_IRWXG | S_IRWXO);
	}
#else
	if ((GetFileAttributesA(_pathToSave.c_str())) == INVALID_FILE_ATTRIBUTES)
	{
		CreateDirectoryA(_pathToSave.c_str(), 0);
	}
#endif
	CCLOG("initDownloadDir end");
}

void Upgrade::reset(Ref* pSender)
{
	_showDownloadInfo->setString("");
	// Remove downloaded files
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
	string command = "rm -r ";
	// Path may include space.
	command += "\"" + _pathToSave + "\"";
	system(command.c_str());
#else
	std::string command = "rd /s /q ";
	// Path may include space.
	command += "\"" + _pathToSave + "\"";
	system(command.c_str());
#endif
	getAssetManager()->deleteVersion();
	initDownloadDir();
}

void Upgrade::upgrade(Ref* pSender)
{
	_showDownloadInfo->setString("");
	getAssetManager()->update();

}
