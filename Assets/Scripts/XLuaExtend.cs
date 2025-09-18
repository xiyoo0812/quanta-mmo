//XLuaExtend.cs

namespace XLua.LuaDLL {

    using System.Runtime.InteropServices;

    public partial class Lua {
        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_luapb(System.IntPtr L);
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaPb(System.IntPtr L) {
            return luaopen_luapb(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_quanta(System.IntPtr L);
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadQuanta(System.IntPtr L) {
            return luaopen_quanta(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_ljson(System.IntPtr L);
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaJson(System.IntPtr L) {
            return luaopen_ljson(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_luassl(System.IntPtr L);
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaSsl(System.IntPtr L) {
            return luaopen_luassl(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_luabus(System.IntPtr L);
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaBus(System.IntPtr L) {
            return luaopen_luabus(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_ltimer(System.IntPtr L);
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaTimer(System.IntPtr L) {
            return luaopen_ltimer(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_lualog(System.IntPtr L);
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaLog(System.IntPtr L) {
            return luaopen_lualog(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_lstdfs(System.IntPtr L);
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaStdfs(System.IntPtr L) {
            return luaopen_lstdfs(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_lcodec(System.IntPtr L);
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaCodec(System.IntPtr L) {
            return luaopen_lcodec(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_luazip(System.IntPtr L);
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaZip(System.IntPtr L) {
            return luaopen_luazip(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_lsmsb(System.IntPtr L);
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaSmdb(System.IntPtr L) {
            return luaopen_lsmsb(L);
        }

        [DllImport(LUADLL, CallingConvention = CallingConvention.Cdecl)]
        public static extern int luaopen_lworker(System.IntPtr L);
        [MonoPInvokeCallback(typeof(LuaDLL.lua_CSFunction))]
        public static int LoadLuaWorker(System.IntPtr L) {
            return luaopen_lworker(L);
        }
    }
}
