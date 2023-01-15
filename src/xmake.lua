if is_plat("windows") then
    target("getopt")
        set_kind("static")
        add_includedirs("getopt-for-windows", {public = true})
        add_files("getopt-for-windows/getopt.c")
    target_end()
end

target("common")
    set_kind("static")
    add_includedirs("common", {public = true})
    add_files("common/*.cpp")
target_end()

includes("Assignment1")
includes("Assignment2")
includes("Assignment3")
includes("Assignment4")
