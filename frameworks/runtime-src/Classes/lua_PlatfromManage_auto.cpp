#include "lua_PlatfromManage_auto.hpp"
#include "PlatfromManage.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_PlatfromManage_PlatfromManage_exitGame(lua_State* tolua_S)
{
    int argc = 0;
    PlatfromManage* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"PlatfromManage",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (PlatfromManage*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_PlatfromManage_PlatfromManage_exitGame'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
            return 0;
        cobj->exitGame();
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "exitGame",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_PlatfromManage_PlatfromManage_exitGame'.",&tolua_err);
#endif

    return 0;
}
int lua_PlatfromManage_PlatfromManage_getTest(lua_State* tolua_S)
{
    int argc = 0;
    PlatfromManage* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"PlatfromManage",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (PlatfromManage*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_PlatfromManage_PlatfromManage_getTest'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
            return 0;
        int ret = cobj->getTest();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "getTest",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_PlatfromManage_PlatfromManage_getTest'.",&tolua_err);
#endif

    return 0;
}
int lua_PlatfromManage_PlatfromManage_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"PlatfromManage",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
            return 0;
        PlatfromManage* ret = PlatfromManage::getInstance();
        object_to_luaval<PlatfromManage>(tolua_S, "PlatfromManage",(PlatfromManage*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_PlatfromManage_PlatfromManage_getInstance'.",&tolua_err);
#endif
    return 0;
}
static int lua_PlatfromManage_PlatfromManage_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (PlatfromManage)");
    return 0;
}

int lua_register_PlatfromManage_PlatfromManage(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"PlatfromManage");
    tolua_cclass(tolua_S,"PlatfromManage","PlatfromManage","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"PlatfromManage");
        tolua_function(tolua_S,"exitGame",lua_PlatfromManage_PlatfromManage_exitGame);
        tolua_function(tolua_S,"getTest",lua_PlatfromManage_PlatfromManage_getTest);
        tolua_function(tolua_S,"getInstance", lua_PlatfromManage_PlatfromManage_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(PlatfromManage).name();
    g_luaType[typeName] = "PlatfromManage";
    g_typeCast["PlatfromManage"] = "PlatfromManage";
    return 1;
}
TOLUA_API int register_all_PlatfromManage(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,nullptr,0);
	tolua_beginmodule(tolua_S,nullptr);

	lua_register_PlatfromManage_PlatfromManage(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

