#ifndef __URL_LOADER__
#define __URL_LOADER__
#include "cocos2d.h"
#include <string.h>
#include "network/HttpClient.h"
USING_NS_CC;
using namespace network;
using namespace std;
class URLLoader : public Ref
{
public:
	static URLLoader* getInstance();

	void load(string& url);
		
	int test();
	
private:
	void onHttpRequestCompleted(HttpClient* sender,HttpResponse* response);

	static URLLoader* instance;

	URLLoader(){};

	~URLLoader(){};

};

#endif //__URL_LOADER__
