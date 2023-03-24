# CS149 Xmake version

slides, code, document, Both are available on the website: [Stanford CS149, Fall 2022 PARALLEL COMPUTING](https://gfxcourses.stanford.edu/cs149/fall22).

Only Windows has been tested. If building fails on other operating systems, use the official Makefile.

# Requirements

- [Xmake](https://xmake.io/#/zh-cn/guide/installation)
- [ISPC](https://ispc.github.io/downloads.html)
- [CUDA](https://developer.nvidia.com/cuda-downloads)
- [Perl](https://www.perl.org/get.html)
- [Python](https://www.python.org/downloads/)
- [Clang](https://releases.llvm.org/download.html)(Optional)

# Getting Started

## Windows

It is recommended to use [Scoop](https://github.com/ScoopInstaller/Scoop) as a package manager.

```bash
scoop install xmake ispc cuda perl llvm python
```

## Build

Compile **all assignments** to see if the development environment is successfully deployed.

```bash
xmake -y
```

- ISPC is only used in Assignment 1.
- CUDA and Perl are only used in Assignment 3.
- The compile command should be as similar as possible to the Makefile in the assignment to avoid affecting the results.
