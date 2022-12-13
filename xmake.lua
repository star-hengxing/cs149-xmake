set_xmakever("2.7.3")

set_project("cs149")

add_rules("mode.debug", "mode.releasedbg", "mode.release", "mode.minsizerel")

set_arch("x64")
set_warnings("all")
set_languages("c++20")

if is_os("windows") then
    set_toolchains("clang-cl")
    set_runtimes("MD")
    add_defines("_CRT_SECURE_NO_WARNINGS", "NOMINMAX")
else
    set_toolchains("clang")
end

add_requires("freeglut", {configs = {shared = true}})

includes("src")