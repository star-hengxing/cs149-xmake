if is_os("windows") then
    target("getopt")
        set_kind("static")
        add_includedirs("getopt-for-windows", {public = true})
        add_files("getopt-for-windows/getopt.c")
end

target("common")
    set_kind("static")
    add_includedirs("common", {public = true})
    add_files("common/*.cpp")

includes("Assignment1")
includes("Assignment2")
includes("Assignment3")
includes("Assignment4")