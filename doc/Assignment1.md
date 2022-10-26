# Assignment 1: Performance Analysis on a Quad-Core CPU

- windows 没有 getopt 头文件，使用 [getopt-for-windows](https://github.com/Chunde/getopt-for-windows) 作为代替。
- 程序4和5，clang 和 msvc 编译失败。因为函数的参数分别是 C 式数组和指针，虽然大家都知道 C 式数组作为函数参数会退化成指针，但编译器对此做出了区分。**最后统一成指针通过编译**。

## 程序1

```bash
xmake run mandelbrot
xmake run mandelbrot --threads 2
xmake run mandelbrot --view 2
xmake run mandelbrot --view 2 --threads 3
```

PPM 图片默认生成在**作业目录**，如果有需要可以在`xmake.lua`里修改程序运行目录。

推荐使用 **Honeyview** 在 Windows 上查看 PPM 格式图片。

## 程序2

```bash
xmake run myexp
xmake run myexp --size 3
xmake run myexp --log
```

## 程序3

程序3-5都使用了 ispc 进行编译，如果有不正确的地方，可能需要到 src/Assignment1/ispc.lua 修改编译参数。

```bash
xmake run mandelbrot_ispc
xmake run mandelbrot_ispc --tasks
```

## 程序4

```bash
xmake run sqrt
```

## 程序5

```bash
xmake run saxpy
```

## 程序6

```bash
xmake run kmeans
```

使用 python 对 kmeans 算法进行可视化，安装所需依赖。
```bash
cd src/Assignment1/prog6_kmeans
pip install -r requirements.txt
python plot.py
```