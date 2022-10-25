# CS149 Xmake version

slides, code, document, Both are available on the website: [Stanford CS149, Fall 2022 PARALLEL COMPUTING](https://gfxcourses.stanford.edu/cs149/fall22).

Windows and Arch Linux can build, if another os failed to build, use official Makefile.

# Requirements

- [Xmake](https://xmake.io/#/zh-cn/guide/installation)
- [ISPC](https://ispc.github.io/downloads.html)
- [Clang](https://releases.llvm.org/download.html)(Optional)

# Getting Started

> If you are not using Clang as the C++ compiler, you do not need to install llvm and modify xmake.lua set_toolchains.

## Windows

Recommended [Scoop](https://github.com/ScoopInstaller/Scoop) as a package Manager.
```bash
scoop install xmake ispc llvm
```

## Arch Linux

```bash
sudo pacman -S ispc llvm
paru xmake
```

## Building

```bash
xmake build -w mandelbrot
```

The compile flag should be the same as the Makefile, to avoid affecting the result of the assignment.
