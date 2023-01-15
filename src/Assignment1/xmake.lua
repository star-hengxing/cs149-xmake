target("mandelbrot")
    set_kind("binary")
    add_files("prog1_mandelbrot_threads/*.cpp")

    set_optimize("fastest")

    add_deps("common")

    if is_plat("windows") then 
        add_deps("getopt")
    elseif is_plat("linux") then 
        add_syslinks("m", "pthread")
    end

    set_rundir("prog1_mandelbrot_threads")
target_end()

target("myexp")
    set_kind("binary")
    add_files("prog2_vecintrin/*.cpp")

    set_optimize("none")

    if is_plat("windows") then
        add_deps("getopt")
    end
target_end()

target("mandelbrot_ispc")
    set_kind("binary")
    add_rules("utils.ispc", {header_extension = "_ispc.h"})
    add_files("prog3_mandelbrot_ispc/*.ispc")
    add_files("prog3_mandelbrot_ispc/*.cpp")

    set_values("ispc.flags", "--target=avx2-i32x8", "--arch=x86-64", "--opt=disable-fma")
    set_optimize("fastest")

    add_deps("common")

    if is_plat("windows") then 
        add_deps("getopt")
    elseif is_plat("linux") then 
        add_syslinks("m", "pthread")
    end

    set_rundir("prog3_mandelbrot_ispc")
target_end()

target("sqrt")
    set_kind("binary")
    add_rules("utils.ispc", {header_extension = "_ispc.h"})
    add_files("prog4_sqrt/*.ispc")
    add_files("prog4_sqrt/*.cpp")

    add_cxxflags("-march=native")
    set_values("ispc.flags", "--target=avx2-i32x8", "--arch=x86-64")
    set_optimize("fastest")

    add_deps("common")

    if is_plat("linux") then 
        add_syslinks("m", "pthread")
    end
target_end()

target("saxpy")
    set_kind("binary")
    add_rules("utils.ispc", {header_extension = "_ispc.h"})
    add_files("prog5_saxpy/*.ispc")
    add_files("prog5_saxpy/*.cpp")

    set_values("ispc.flags", "--target=avx2-i32x8", "--arch=x86-64")
    set_optimize("faster")

    add_deps("common")

    if is_plat("linux") then 
        add_syslinks("m", "pthread")
    end
target_end()

target("kmeans")
    set_kind("binary")
    add_files("prog6_kmeans/*.cpp")

    add_cxxflags("-march=native")
    set_optimize("fastest")

    add_deps("common")

    if is_plat("linux") then 
        add_syslinks("m", "pthread")
    end

    set_rundir("prog6_kmeans")
target_end()
