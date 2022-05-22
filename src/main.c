#include "lua.h"


int
luaopen_pgsql(lua_State *L);

#ifdef _WIN32
	#define GLUA_DLL_EXPORT  __declspec( dllexport ) 
#else
	#define GLUA_DLL_EXPORT	 __attribute__((visibility("default"))) 
#endif

GLUA_DLL_EXPORT int gmod13_open( lua_State* L )
{
	luaopen_pgsql(L);
	lua_setglobal(L, "pgsql");
	return 0;
}

GLUA_DLL_EXPORT int gmod13_close( lua_State* L )
{
	return 0;
}





