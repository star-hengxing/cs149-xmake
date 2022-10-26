set_optimize("fastest")

target("tutorial")
    set_kind("binary")
    add_files("tutorial/*.cpp")

    if is_os("linux") then 
        add_syslinks("pthread")
    end

target("part_a")
    set_kind("binary")
    add_includedirs("part_a", "../common", "tests")
    add_files("part_a/*.cpp", "tests/main.cpp")

    if is_os("windows") then 
        add_deps("getopt")
    elseif is_os("linux") then 
        add_syslinks("m", "pthread")
    end

target("part_b")
    set_kind("binary")
    add_includedirs("part_a", "../common", "tests")
    add_files("part_b/*.cpp", "tests/main.cpp")

    if is_os("windows") then 
        add_deps("getopt")
    elseif is_os("linux") then 
        add_syslinks("m", "pthread")
    end