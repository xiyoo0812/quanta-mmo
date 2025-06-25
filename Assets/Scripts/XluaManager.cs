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
                _luaenv.AddBuildin("lssl", XLua.LuaDLL.Lua.LoadLuaSsl);
                _luaenv.AddBuildin("luapb", XLua.LuaDLL.Lua.LoadLuaPb);
                _luaenv.AddBuildin("ljson", XLua.LuaDLL.Lua.LoadLuaJson);
                _luaenv.AddBuildin("luabus", XLua.LuaDLL.Lua.LoadLuaBus);
                _luaenv.AddBuildin("lualog", XLua.LuaDLL.Lua.LoadLuaLog);
                _luaenv.AddBuildin("lsmdb", XLua.LuaDLL.Lua.LoadLuaSmdb);
                _luaenv.AddBuildin("lcodec", XLua.LuaDLL.Lua.LoadLuaCodec);
                _luaenv.AddBuildin("lstdfs", XLua.LuaDLL.Lua.LoadLuaStdfs);
                _luaenv.AddBuildin("ltimer", XLua.LuaDLL.Lua.LoadLuaTimer);
                _luaenv.AddBuildin("lminiz", XLua.LuaDLL.Lua.LoadLuaMiniz);
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
        string path = Application.dataPath + "/Resources/Lua/" + filename + ".lua";
        if(File.Exists(path)) {
            byte[] content = File.ReadAllBytes(path);
            return content;
        }
        return null;
    }
}
