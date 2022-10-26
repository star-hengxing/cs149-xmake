# CS149 魔改版

[English](doc/README-EN.md)

slides，代码，作业文档，都可以从官网获得：[Stanford CS149, Fall 2022 PARALLEL COMPUTING](https://gfxcourses.stanford.edu/cs149/fall22)。

只测试了 Windows，其他操作系统如果构建失败，那就用官方的 Makefile。

# 依赖

- [Xmake](https://xmake.io/#/zh-cn/guide/installation)
- [ISPC](https://ispc.github.io/downloads.html)
- [CUDA](https://developer.nvidia.com/cuda-downloads)
- [Perl](https://www.perl.org/get.html)
- [Python](https://www.python.org/downloads/)
- [Clang](https://releases.llvm.org/download.html)（可选）

# 快速开始

> 如果不使用 Clang 作为 C++ 编译器，不需要安装 llvm，并修改 xmake.lua 的 set_toolchains。

## Windows

推荐使用 [Scoop](https://github.com/ScoopInstaller/Scoop) 作为包管理。
```bash
scoop install xmake ispc cuda perl llvm python
```

## 构建

- ispc 只用在作业1。
- cuda 和 perl 只用在作业3。
- 作业3依赖的 freeglut 库由 xmake 管理，如果库下载失败，查看[文档](https://xmake.io/#/zh-cn/package/remote_package?id=%e8%bf%9c%e7%a8%8b%e5%8c%85%e4%b8%8b%e8%bd%bd%e4%bc%98%e5%8c%96)。
- 编译命令尽量和作业内的 Makefile 一样，避免影响作业结果。
- 更详细的编译设置查看 doc 目录

编译一下看看开发环境是否部署成功。
```bash
xmake build -w mandelbrot
xmake build -w mandelbrot_ispc
xmake build -w cudaSaxpy
xmake build -w render
```

- [x] [作业1](doc/Assignment1.md)
- [x] [作业2](doc/Assignment2.md)
- [x] [作业3](doc/Assignment3.md)
- [ ] 作业4

# 学习资料

1. [CMU15418 并行计算机架构与编程](https://www.zhihu.com/column/c_1515272289578479616)
2. [并行计算(一)：CPU介绍](https://zhuanlan.zhihu.com/p/515938171)
3. [并行计算(二)：并行编程基础](https://zhuanlan.zhihu.com/p/516448932)
4. [并行计算(三)：缓存一致性](https://zhuanlan.zhihu.com/p/516870923)