//XluaManager.cs

using System.IO;
using UnityEngine;
using XLua;

public static class XluaManager {
    private static LuaEnv _luaenv;

    public static LuaEnv Lua {
        get {
            if (_luaenv == null) {
                _luaenv = new LuaEnv();
                _luaenv.AddBuildin("luapb", XLua.LuaDLL.Lua.LoadLuaPb);
                _luaenv.AddBuildin("quanta", XLua.LuaDLL.Lua.LoadQuanta);
                _luaenv.AddBuildin("ljson", XLua.LuaDLL.Lua.LoadLuaJson);
                _luaenv.AddBuildin("luabus", XLua.LuaDLL.Lua.LoadLuaBus);
                _luaenv.AddBuildin("lualog", XLua.LuaDLL.Lua.LoadLuaLog);
                _luaenv.AddBuildin("lsmdb", XLua.LuaDLL.Lua.LoadLuaSmdb);
                _luaenv.AddBuildin("luassl", XLua.LuaDLL.Lua.LoadLuaSsl);
                _luaenv.AddBuildin("luazip", XLua.LuaDLL.Lua.LoadLuaZip);
                _luaenv.AddBuildin("lcodec", XLua.LuaDLL.Lua.LoadLuaCodec);
                _luaenv.AddBuildin("lstdfs", XLua.LuaDLL.Lua.LoadLuaStdfs);
                _luaenv.AddBuildin("ltimer", XLua.LuaDLL.Lua.LoadLuaTimer);
                _luaenv.AddBuildin("lworker", XLua.LuaDLL.Lua.LoadLuaWorker);
                _luaenv.AddLoader(luaLoader);
                //执行启动脚本
                _luaenv.DoString("require 'main'");
            }
            return _luaenv;
        }
    }

    private static byte[] luaLoader(ref string filename) {
        filename = filename.Replace('.', '/');
        string path_lua = "Quanta/lua/" + filename + ".lua";
        if(File.Exists(path_lua)) {
            byte[] content = File.ReadAllBytes(path_lua);
            return content;
        }
        string path_conf = "Quanta/config/" + filename;
        if(File.Exists(path_conf)) {
            byte[] content = File.ReadAllBytes(path_conf);
            return content;
        }
        return null;
    }
}
