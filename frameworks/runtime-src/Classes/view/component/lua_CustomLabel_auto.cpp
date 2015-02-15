#include "lua_CustomLabel_auto.hpp"
#include "CustomLabel.h"
#include "tolua_fix.h"
#include "LuaBasicConversions.h"



int lua_CustomLabel_CustomLabel_createWithCharMap(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"CustomLabel",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 4)
    {
        std::string arg0;
        int arg1;
        int arg2;
        int arg3;
        ok &= luaval_to_std_string(tolua_S, 2,&arg0);
        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1);
        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2);
        ok &= luaval_to_int32(tolua_S, 5,(int *)&arg3);
        if(!ok)
            return 0;
        cocos2d::Label* ret = CustomLabel::createWithCharMap(arg0, arg1, arg2, arg3);
        object_to_luaval<cocos2d::Label>(tolua_S, "cc.Label",(cocos2d::Label*)ret);
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d\n ", "createWithCharMap",argc, 4);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_CustomLabel_CustomLabel_createWithCharMap'.",&tolua_err);
#endif
    return 0;
}
int lua_CustomLabel_CustomLabel_constructor(lua_State* tolua_S)
{
    int argc = 0;
    CustomLabel* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
            return 0;
        cobj = new CustomLabel();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"CustomLabel");
        return 1;
    }
    CCLOG("%s has wrong number of arguments: %d, was expecting %d \n", "CustomLabel",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_CustomLabel_CustomLabel_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_CustomLabel_CustomLabel_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (CustomLabel)");
    return 0;
}

int lua_register_CustomLabel_CustomLabel(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"CustomLabel");
    tolua_cclass(tolua_S,"CustomLabel","CustomLabel","cc.Label",nullptr);

    tolua_beginmodule(tolua_S,"CustomLabel");
        tolua_function(tolua_S,"new",lua_CustomLabel_CustomLabel_constructor);
        tolua_function(tolua_S,"createWithCharMap", lua_CustomLabel_CustomLabel_createWithCharMap);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(CustomLabel).name();
    g_luaType[typeName] = "CustomLabel";
    g_typeCast["CustomLabel"] = "CustomLabel";
    return 1;
}
TOLUA_API int register_all_CustomLabel(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,"my",0);
	tolua_beginmodule(tolua_S,"my");

	lua_register_CustomLabel_CustomLabel(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

