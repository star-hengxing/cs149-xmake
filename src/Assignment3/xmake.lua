set_optimize("fastest")

add_cugencodes("compute_35")

if is_os("windows") then 
    add_deps("getopt")
end

target("cudaSaxpy")
    set_kind("binary")
    add_files("saxpy/*.cpp")
    add_files("saxpy/*.cu")

target("cudaScan")
    set_kind("binary")
    add_files("scan/*.cpp")
    add_files("scan/*.cu")

target("render")
    set_kind("binary")
    add_files("render/*.cpp")
    add_files("render/*.cu")

    add_packages("freeglut")