#include "URLLoader.h"
#include "CCLuaEngine.h"
#include "URLData.h"
int URLLoader::test()
{
	return 10;
}

void URLLoader::load(string& url)
{
	CCLOG("URL: %s",url.c_str());
	HttpRequest* request = new HttpRequest();
	request->setUrl(url.c_str());
	/*char* postData = "a=1&b=2";
	request->setRequestData(postData,strlen(postData));*/
	request->setRequestType(HttpRequest::Type::GET);
	request->setResponseCallback(CC_CALLBACK_2(URLLoader::onHttpRequestCompleted,this));
	HttpClient::getInstance()->setTimeoutForConnect(3);
	HttpClient::getInstance()->setTimeoutForRead(3);
	HttpClient::getInstance()->send(request);
	request->release();
}

void URLLoader::onHttpRequestCompleted(HttpClient* sender,HttpResponse* response)
{
	URLData data(-1,"Hello world");
	auto engine = cocos2d::LuaEngine::getInstance();
	cocos2d::BasicScriptData    scriptdata(this, &data);
	cocos2d::ScriptEvent    eve(kCallFuncEvent, &scriptdata);
	
	if(!response)
	{
		engine->sendEvent(&eve);
		return;
	}
	
	long statusCode = response->getResponseCode();
	data.setStatusCode((int)statusCode);
    char statusString[64] = {};
    sprintf(statusString, "HTTP Status Code: %ld, tag = %s", statusCode, response->getHttpRequest()->getTag());
    log("response code: %ld", statusCode);

	if(!response->isSucceed())
	{
		log("response failed");
        log("error buffer: %s", response->getErrorBuffer());
		engine->sendEvent(&eve);
        return;
	}
	vector<char> *buffer = response->getResponseData();
	 std::string temp(buffer->begin(),buffer->end());
	data.setData(temp);
	engine->sendEvent(&eve);
	
	//CCLOG(responseData->getCString());
	printf("Http Test, dump data: ");
	for (unsigned int i = 0; i < buffer->size(); i++)
    {
        printf("%c", (*buffer)[i]);
    }
	printf("\n");
	
	if (response->getHttpRequest()->getReferenceCount() != 2)
    {
        log("request ref count not 2, is %d", response->getHttpRequest()->getReferenceCount());
    }
	
	//HttpClient::getInstance()->destroyInstance();
}

URLLoader* URLLoader::instance = nullptr;
URLLoader* URLLoader::getInstance()
{
	if(!instance)
	{
		instance = new URLLoader();
		//instance->autorelease();
		//instance->retain();
	}
	return instance;
};