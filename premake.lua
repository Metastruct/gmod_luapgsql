	
		
function os.winSdkVersion()
        local reg_arch = iif( os.is64bit(), "\\Wow6432Node\\", "\\" )
        local sdk_version = os.getWindowsRegistry( "HKLM:SOFTWARE" .. reg_arch .."Microsoft\\Microsoft SDKs\\Windows\\v10.0\\ProductVersion" )
        if sdk_version ~= nil then return sdk_version end
end

solution "pgsql"

        language "C++"
        location ( "solutions/" .. os.target() .. "-" .. _ACTION )
        flags { "NoPCH", "NoImportLib"}
        optimize "On"
        vectorextensions "SSE"
        symbols "On"
        floatingpoint "Fast"
        editandcontinue "Off"
        targetdir ( "out/" .. os.target() .. "/" )
        includedirs {  "/usr/include/postgresql/", 
                                        "src/"
                                        }

        if os.target() == "macosx" or os.target() == "linux" then

                buildoptions { "-std=c++11 -fPIC" }
                linkoptions { " -fPIC" }

        end

        configurations { "Release" }
        platforms { "x86", "x86_64" }

        defines { "NDEBUG" }
        optimize "On"
        floatingpoint "Fast"

        if os.target() == "windows" then
                defines{ "WIN32" }
        elseif os.target() == "linux" then
                defines{ "LINUX" }
        end

        local platform
        if os.target() == "windows" then
                platform = "win"
                links { "pq" }
        elseif os.target() == "macosx" then
                platform = "osx"
                links { "pq" }
        elseif os.target() == "linux" then
                platform = "linux"
                links { "pq" }
        else
                error "Unsupported platform."
        end



        filter "platforms:x86"
                architecture "x86"
                libdirs { "lib/" .. os.target() }
                if os.target() == "windows" then
                        targetname( "gmsv_gwsockets_" .. platform .. "32")
                else
                        targetname( "gmsv_gwsockets_" .. platform)
                end
        filter "platforms:x86_64"
                architecture "x86_64"
                libdirs { "lib64/" .. os.target() }
                targetname( "gmsv_pgsql_" .. platform .. "64")
        filter {"system:windows", "action:vs*"}
                systemversion((os.winSdkVersion() or "10.0.16299") .. ".0")
                toolset "v141"

        project "pgsql"
                files{ "src/**.c", "src/**.cpp" }
                kind "SharedLib"
                targetprefix ("")
                targetextension (".dll")
                targetdir("out/" .. os.target())
