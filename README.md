# CS149 魔改版

作业来自 -> [Stanford CS149, Fall 2022 PARALLEL COMPUTING](https://gfxcourses.stanford.edu/cs149/fall22)

只测试了 Windows，Linux/MAC 如果构建失败，那就直接用官方的 Makefile

# 快速开始

自行下载 C++ 编译工具链，如 GCC/Clang/MSVC

在 Windows 上，可以考虑用 [Scoop](https://github.com/ScoopInstaller/Scoop)，然后直接
```bash
scoop install xmake ispc llvm
```
> 如果不使用 Clang 作为 C++ 编译器，不需要安装 llvm，并修改 xmake.lua 的 set_toolchains，写入你要用的编译器

也可以手动从官网下载
- [Xmake](https://xmake.io/#/zh-cn/guide/installation)
- [ispc](https://ispc.github.io/downloads.html)

部署完环境后，编译所有作业
```bash
xmake
```
编译命令尽量和作业的 Makefile 一样，避免影响作业结果

作业自带的一些运行命令请看作业目录内的文档

- [作业1](doc/Assignment1.md)

# 学习资料

1. [CMU15418 并行计算机架构与编程](https://www.zhihu.com/column/c_1515272289578479616)
2. [并行计算(一)：CPU介绍](https://zhuanlan.zhihu.com/p/515938171)
3. [并行计算(二)：并行编程基础](https://zhuanlan.zhihu.com/p/516448932)
4. [并行计算(三)：缓存一致性](https://zhuanlan.zhihu.com/p/516870923)