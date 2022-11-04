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

    after_build(function (target)
        os.cp(target:targetfile(), "$(projectdir)")
        -- rename
        os.mv(target:filename(), "runtasks" .. path.extension(target:filename()))
        os.mv("runtasks" .. path.extension(target:filename()), "$(scriptdir)")
    end)

target("part_b")
    set_kind("binary")
    add_includedirs("part_a", "../common", "tests")
    add_files("part_b/*.cpp", "tests/main.cpp")

    if is_os("windows") then 
        add_deps("getopt")
    elseif is_os("linux") then 
        add_syslinks("m", "pthread")
    end

    after_build(function (target)
        os.cp(target:targetfile(), "$(projectdir)")
        -- rename
        os.mv(target:filename(), "runtasks" .. path.extension(target:filename()))
        os.mv("runtasks" .. path.extension(target:filename()), "$(scriptdir)")
    end)

target("asst2_test")
    set_kind("phony")

    on_run(function ()
        os.cd("$(scriptdir)")
        local name = "runtasks"
        local filename = name
        if os.host() == "windows" then
            filename = name .. ".exe"
        else
            name = "./" .. name
        end
        assert(os.isfile(filename), "Should build part_a or part_b")

        local test_names =
        {
            "simple_test_sync",
            "ping_pong_equal",
            "ping_pong_unequal",
            "super_light",
            "super_super_light",
            "recursive_fibonacci",
            "math_operations_in_tight_for_loop",
            "math_operations_in_tight_for_loop_fewer_tasks",
            "math_operations_in_tight_for_loop_fan_in",
            "math_operations_in_tight_for_loop_reduction_tree",
            "spin_between_run_calls",
            "mandelbrot_chunked",
            "simple_test_async",
            "ping_pong_equal_async",
            "ping_pong_unequal_async",
            "super_light_async",
            "super_super_light_async",
            "recursive_fibonacci_async",
            "math_operations_in_tight_for_loop_async",
            "math_operations_in_tight_for_loop_fewer_tasks_async",
            "math_operations_in_tight_for_loop_fan_in_async",
            "math_operations_in_tight_for_loop_reduction_tree_async",
            "mandelbrot_chunked_async",
            "spin_between_run_calls_async",
            "simple_run_deps_test",
            "strict_diamond_deps_async",
            "strict_graph_deps_small_async",
            "strict_graph_deps_med_async",
            "strict_graph_deps_large_async",
        }
        
        for _, value in ipairs(test_names)
        do
            -- cprint("Testing " .. "${bright green}%s", value)
            -- os.runv(name, {value})
            os.execv(name, {value})
        end
        cprint("${bright red}Pass!")
    end)