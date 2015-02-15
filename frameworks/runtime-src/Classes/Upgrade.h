//  Gobal.h
//
//  Created by Sharezer on 14-07-26.
//
//

#ifndef _UPGRADE_H_
#define _UPGRADE_H_
#include "cocos2d.h"

class Upgrade : public cocos2d::CCLayer, public cocos2d::extension::AssetsManagerDelegateProtocol
{
public:
	Upgrade();
	virtual ~Upgrade();

	virtual bool init();

	void upgrade(cocos2d::Ref* pSender);	//检查版本更新
	void reset(cocos2d::Ref* pSender);		//重置版本
	
	virtual void onError(cocos2d::extension::AssetsManager::ErrorCode errorCode);		//错误信息
	virtual void onProgress(int percent);	//更新下载进度
	virtual void onSuccess();		//下载成功
	CREATE_FUNC(Upgrade);
private:
	cocos2d::extension::AssetsManager* getAssetManager();
	void initDownloadDir();		//创建下载目录

private:
	std::string _pathToSave;
	cocos2d::Label *_showDownloadInfo;
};


#endif
