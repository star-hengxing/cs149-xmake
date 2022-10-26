includes("ispc.lua")

target("mandelbrot")
    set_kind("binary")
    add_files("prog1_mandelbrot_threads/*.cpp")

    set_optimize("fastest")

    add_deps("common")

    if is_os("windows") then 
        add_deps("getopt")
    elseif is_os("linux") then 
        add_syslinks("m", "pthread")
    end

    set_rundir("prog1_mandelbrot_threads")

target("myexp")
    set_kind("binary")
    add_files("prog2_vecintrin/*.cpp")

    set_optimize("none")

    if is_os("windows") then
        add_deps("getopt")
    end

target("ISPC_mandelbrot")
    set_kind("object")
    add_rules("utils.ispc")
    add_files("prog3_mandelbrot_ispc/*.ispc")

target("mandelbrot_ispc")
    set_kind("binary")
    add_files("prog3_mandelbrot_ispc/*.cpp")

    set_optimize("fastest")

    add_deps("common", "ISPC_mandelbrot")

    if is_os("windows") then 
        add_deps("getopt")
    elseif is_os("linux") then 
        add_syslinks("m", "pthread")
    end

    set_rundir("prog3_mandelbrot_ispc")

target("ISPC_sqrt")
    set_kind("object")
    add_rules("utils.ispc")
    add_files("prog4_sqrt/*.ispc")

target("sqrt")
    set_kind("binary")
    add_files("prog4_sqrt/*.cpp")
    add_cxxflags("-march=native")

    set_optimize("fastest")

    add_deps("common", "ISPC_sqrt")

    if is_os("linux") then 
        add_syslinks("m", "pthread")
    end

target("ISPC_saxpy")
    set_kind("object")
    add_rules("utils.ispc")
    add_files("prog5_saxpy/*.ispc")

target("saxpy")
    set_kind("binary")
    add_files("prog5_saxpy/*.cpp")

    set_optimize("faster")

    add_deps("common", "ISPC_saxpy")

    if is_os("linux") then 
        add_syslinks("m", "pthread")
    end

target("kmeans")
    set_kind("binary")
    add_files("prog6_kmeans/*.cpp")
    add_cxxflags("-march=native")

    set_optimize("fastest")

    add_deps("common")

    if is_os("linux") then 
        add_syslinks("m", "pthread")
    end