set_xmakever("2.7.3")
set_version("0.0.1")

set_project("cs149")

set_arch("x64")
set_warnings("all")
set_languages("c++20")
set_toolchains("clang")

add_rules("mode.debug", "mode.releasedbg", "mode.release", "mode.minsizerel")

add_requires("freeglut", {configs = {shared = true}})

if is_os("windows") then
    add_defines("_CRT_SECURE_NO_WARNINGS", "NOMINMAX")
end

includes("src")