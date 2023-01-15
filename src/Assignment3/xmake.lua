set_optimize("fastest")
-- Higher cuda versions may not be supported
add_cugencodes("compute_35")
-- dynamic link
add_links("cudart")

if is_plat("windows") then 
    add_deps("getopt")
end

target("cudaSaxpy")
    set_kind("binary")
    add_files("saxpy/*.cpp")
    add_files("saxpy/*.cu")
target_end()

target("cudaScan")
    set_kind("binary")
    add_files("scan/*.cpp")
    add_files("scan/*.cu")
target_end()

target("render")
    set_kind("binary")
    add_files("render/*.cpp")
    add_files("render/*.cu")

    add_packages("freeglut")
    set_rundir("render")
target_end()
