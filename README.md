# CS149 魔改版

[English](doc/README-EN.md)

slides，代码，作业文档，都可以从官网获得：[Stanford CS149, Fall 2022 PARALLEL COMPUTING](https://gfxcourses.stanford.edu/cs149/fall22)。

只测试了 Windows 和 Arch Linux，其他操作系统如果构建失败，那就用官方的 Makefile。

# 依赖

- [Xmake](https://xmake.io/#/zh-cn/guide/installation)
- [ISPC](https://ispc.github.io/downloads.html)
- [Clang](https://releases.llvm.org/download.html)（可选）

# 快速开始

> 如果不使用 Clang 作为 C++ 编译器，不需要安装 llvm，并修改 xmake.lua 的 set_toolchains。

## Windows

推荐使用 [Scoop](https://github.com/ScoopInstaller/Scoop) 作为包管理。
```bash
scoop install xmake ispc llvm
```

## Arch Linux

```bash
sudo pacman -S ispc clang
paru xmake
```

## 构建

编译一下看看开发环境是否部署成功。
```bash
xmake build -w mandelbrot
```
编译命令尽量和作业内的 Makefile 一样，避免影响作业结果。

- [x] [作业1](doc/Assignment1.md)
- [x] [作业2](doc/Assignment2.md)
- [ ] 作业3
- [ ] 作业4

# 学习资料

1. [CMU15418 并行计算机架构与编程](https://www.zhihu.com/column/c_1515272289578479616)
2. [并行计算(一)：CPU介绍](https://zhuanlan.zhihu.com/p/515938171)
3. [并行计算(二)：并行编程基础](https://zhuanlan.zhihu.com/p/516448932)
4. [并行计算(三)：缓存一致性](https://zhuanlan.zhihu.com/p/516870923)