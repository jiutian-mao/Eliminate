#include "lua_URLLoader_auto.hpp"
#include "URLLoader.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_URLLoader_URLLoader_load(lua_State* tolua_S)
{
    int argc = 0;
    URLLoader* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"URLLoader",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (URLLoader*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_URLLoader_URLLoader_load'", nullptr);
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
        cobj->load(arg0);
        return 0;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "load",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_URLLoader_URLLoader_load'.",&tolua_err);
#endif

    return 0;
}
int lua_URLLoader_URLLoader_test(lua_State* tolua_S)
{
    int argc = 0;
    URLLoader* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"URLLoader",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (URLLoader*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_URLLoader_URLLoader_test'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
            return 0;
        int ret = cobj->test();
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "test",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_URLLoader_URLLoader_test'.",&tolua_err);
#endif

    return 0;
}
int lua_URLLoader_URLLoader_getInstance(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"URLLoader",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
            return 0;
        URLLoader* ret = URLLoader::getInstance();
        object_to_luaval<URLLoader>(tolua_S, "URLLoader",(URLLoader*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "getInstance",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_URLLoader_URLLoader_getInstance'.",&tolua_err);
#endif
    return 0;
}
static int lua_URLLoader_URLLoader_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (URLLoader)");
    return 0;
}

int lua_register_URLLoader_URLLoader(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"URLLoader");
    tolua_cclass(tolua_S,"URLLoader","URLLoader","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"URLLoader");
        tolua_function(tolua_S,"load",lua_URLLoader_URLLoader_load);
        tolua_function(tolua_S,"test",lua_URLLoader_URLLoader_test);
        tolua_function(tolua_S,"getInstance", lua_URLLoader_URLLoader_getInstance);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(URLLoader).name();
    g_luaType[typeName] = "URLLoader";
    g_typeCast["URLLoader"] = "URLLoader";
    return 1;
}
TOLUA_API int register_all_URLLoader(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,nullptr,0);
	tolua_beginmodule(tolua_S,nullptr);

	lua_register_URLLoader_URLLoader(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

