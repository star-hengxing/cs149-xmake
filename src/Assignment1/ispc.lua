rule("utils.ispc")
    set_extensions(".ispc")

    on_config(function (target, opt)
        local header_outputdir = path.join(target:autogendir(), "rules", "utils", "ispc_headers")
        local obj_outputdir = path.join(target:autogendir(), "rules", "utils", "ispc_objs")
        os.mkdir(target:autogendir())
        os.mkdir(header_outputdir)
        target:add("includedirs", header_outputdir, {public = true})
        target:set("policy", "build.across_targets_in_parallel", false)
    end)
    before_buildcmd_file(function (target, batchcmds, sourcefile_ispc, opt)
        -- import("lib.detect.find_tool")
        -- ispc = find_tool("ispc")
        -- assert(ispc, "ispc not found!")

        local obj_extension = ".o"
        if (os.host() == "windows") then
            obj_extension = ".obj"
        end
        local header_extension = target:extraconf("rules", "utils.ispc", "header_extension") or ".h"

        local obj_outputdir = path.join(target:autogendir(), "rules", "utils", "ispc_objs")
        local header_outputdir = path.join(target:autogendir(), "rules", "utils", "ispc_headers")
        local obj_path = path.join(obj_outputdir, path.filename(sourcefile_ispc) .. obj_extension)
        local header_path = path.join(header_outputdir, path.filename(sourcefile_ispc) .. header_extension)
        batchcmds:show_progress(opt.progress, "${color.build.object}generating.ispc %s", sourcefile_ispc)
        batchcmds:mkdir(obj_outputdir)
        batchcmds:mkdir(header_outputdir)
        -- batchcmds:vrunv(ispc.program,
        batchcmds:vrunv("ispc",
            {"-O3",
            "--target=avx2-i32x8",
            "--arch=x86-64",
            "--opt=disable-fma",
            "--pic",
            "-o", obj_path,
            "-h", header_path,
            path.join(os.projectdir(), sourcefile_ispc)})

        assert(os.exists(target:autogendir()))
        table.insert(target:objectfiles(), obj_path)

        batchcmds:add_depfiles(sourcefile_ispc, header_path)
        batchcmds:set_depmtime(os.mtime(obj_path))
        batchcmds:set_depcache(target:dependfile(obj_path))
        batchcmds:set_depmtime(os.mtime(header_path))
        batchcmds:set_depcache(target:dependfile(header_path))
    end)