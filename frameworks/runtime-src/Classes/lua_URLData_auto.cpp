#include "lua_URLData_auto.hpp"
#include "URLData.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_URLData_URLData_setStatusCode(lua_State* tolua_S)
{
    int argc = 0;
    URLData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"URLData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (URLData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_URLData_URLData_setStatusCode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0);
        if(!ok)
            return 0;
        cobj->setStatusCode(arg0);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "setStatusCode",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_URLData_URLData_setStatusCode'.",&tolua_err);
#endif

    return 0;
}
int lua_URLData_URLData_getData(lua_State* tolua_S)
{
    int argc = 0;
    URLData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"URLData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (URLData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_URLData_URLData_getData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
            return 0;
        std::string ret = cobj->getData();
        tolua_pushcppstring(tolua_S,ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "getData",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_URLData_URLData_getData'.",&tolua_err);
#endif

    return 0;
}
int lua_URLData_URLData_getStatusCode(lua_State* tolua_S)
{
    int argc = 0;
    URLData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"URLData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (URLData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_URLData_URLData_getStatusCode'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
            return 0;
        int ret = cobj->getStatusCode();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "getStatusCode",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_URLData_URLData_getStatusCode'.",&tolua_err);
#endif

    return 0;
}
int lua_URLData_URLData_setData(lua_State* tolua_S)
{
    int argc = 0;
    URLData* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"URLData",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (URLData*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_URLData_URLData_setData'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        std::string arg0;

        ok &= luaval_to_std_string(tolua_S, 2,&arg0);
        if(!ok)
            return 0;
        cobj->setData(arg0);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "setData",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_URLData_URLData_setData'.",&tolua_err);
#endif

    return 0;
}
int lua_URLData_URLData_constructor(lua_State* tolua_S)
{
    int argc = 0;
    URLData* cobj = nullptr;
    bool ok  = true;
#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

    argc = lua_gettop(tolua_S)-1;
    do{
        if (argc == 2) {
            int arg0;
            ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0);

            if (!ok) { break; }
            std::string arg1;
            ok &= luaval_to_std_string(tolua_S, 3,&arg1);

            if (!ok) { break; }
            cobj = new URLData(arg0, arg1);
            cobj->autorelease();
            int ID =  (int)cobj->_ID ;
            int* luaID =  &cobj->_luaID ;
            toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"URLData");
            return 1;
        }
    }while(0);
    ok  = true;
    do{
        if (argc == 0) {
            cobj = new URLData();
            cobj->autorelease();
            int ID =  (int)cobj->_ID ;
            int* luaID =  &cobj->_luaID ;
            toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"URLData");
            return 1;
        }
    }while(0);
    ok  = true;
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "URLData",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_URLData_URLData_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_URLData_URLData_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (URLData)");
    return 0;
}

int lua_register_URLData_URLData(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"URLData");
    tolua_cclass(tolua_S,"URLData","URLData","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"URLData");
        tolua_function(tolua_S,"new",lua_URLData_URLData_constructor);
        tolua_function(tolua_S,"setStatusCode",lua_URLData_URLData_setStatusCode);
        tolua_function(tolua_S,"getData",lua_URLData_URLData_getData);
        tolua_function(tolua_S,"getStatusCode",lua_URLData_URLData_getStatusCode);
        tolua_function(tolua_S,"setData",lua_URLData_URLData_setData);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(URLData).name();
    g_luaType[typeName] = "URLData";
    g_typeCast["URLData"] = "URLData";
    return 1;
}
TOLUA_API int register_all_URLData(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,nullptr,0);
	tolua_beginmodule(tolua_S,nullptr);

	lua_register_URLData_URLData(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

