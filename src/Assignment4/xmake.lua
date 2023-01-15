set_symbols("debug")
set_optimize("fastest")

function only_linux(target)
    if target:is_plat("linux") then
        target:set("enabled", true)
    else
        target:set("enabled", false)
    end
end

target("assignment4_common")
    set_kind("static")
    add_includedirs(".", {public = true})
    add_files("common/*.cpp")
target_end()

target("graphTools")
    set_kind("binary")
    add_files("tools/*.cpp")
    add_deps("assignment4_common")
target_end()

target("pr")
    set_kind("binary")
    add_files("pagerank/main.cpp", "pagerank/page_rank.cpp")

    add_linkdirs("pagerank")
    add_ldflags("-fopenmp")
    add_ldflags("-l:ref_pr.a", {force = true})
    add_deps("assignment4_common")
    on_load(only_linux)
target_end()

target("pr_grader")
    set_kind("binary")
    add_files("pagerank/grade.cpp", "pagerank/page_rank.cpp")

    add_linkdirs("pagerank")
    add_ldflags("-fopenmp")
    add_ldflags("-l:ref_pr.a", {force = true})
    add_deps("assignment4_common")
    on_load(only_linux)
target_end()

target("bfs")
    set_kind("binary")
    add_files("bfs/main.cpp", "bfs/bfs.cpp")
    add_files("bfs/ref_bfs.o")
    add_ldflags("-fopenmp")
    add_deps("assignment4_common")
    on_load(only_linux)
target_end()

target("bfs_grader")
    set_kind("binary")
    add_files("bfs/grade.cpp", "bfs/bfs.cpp")
    add_files("bfs/ref_bfs.o")
    add_ldflags("-fopenmp")
    add_deps("assignment4_common")
    on_load(only_linux)
target_end()
