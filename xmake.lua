set_xmakever("2.7.5")

set_project("cs149")

add_rules("mode.debug", "mode.releasedbg", "mode.release", "mode.minsizerel")

set_warnings("all")
set_languages("c++20")

if is_plat("windows") then
    set_runtimes("MD")
    add_defines("_CRT_SECURE_NO_WARNINGS", "NOMINMAX")
end

add_requires("freeglut", {configs = {shared = true}})

includes("src")
