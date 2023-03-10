# CS149 Xmake version

slides, code, document, Both are available on the website: [Stanford CS149, Fall 2022 PARALLEL COMPUTING](https://gfxcourses.stanford.edu/cs149/fall22).

Windows10 can build, if another os failed to build, use official Makefile.

# Requirements

- [Xmake](https://xmake.io/#/zh-cn/guide/installation)
- [ISPC](https://ispc.github.io/downloads.html)
- [CUDA](https://developer.nvidia.com/cuda-downloads)
- [Perl](https://www.perl.org/get.html)
- [Python](https://www.python.org/downloads/)
- [Clang](https://releases.llvm.org/download.html)(Optional)

# Getting Started

## Windows

First download MSVC C++ toolchain from [https://visualstudio.microsoft.com/](https://visualstudio.microsoft.com/)

Recommended [Scoop](https://github.com/ScoopInstaller/Scoop) as a package Manager.
```bash
scoop install xmake ispc cuda perl python llvm
```

## Building

The compile flag should be the same as the Makefile, to avoid affecting the result of the assignment.

```bash
xmake -y
```
