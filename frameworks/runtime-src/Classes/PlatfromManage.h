#ifndef __PLATFRORM_MANAGE__H__
#define __PLATFRORM_MANAGE__H__

#include "cocos2d.h"
USING_NS_CC;

class PlatfromManage : public Ref
{
public:
	
	int test;

	int getTest();

	void exitGame();

	static PlatfromManage* getInstance();
	
private:
	PlatfromManage();
	~PlatfromManage();
	static PlatfromManage* instance;
};

#endif	//__PLATFRORM_MANAGE__H__