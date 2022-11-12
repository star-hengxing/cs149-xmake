# Assignment 2: Building A Task Execution Library from the Ground Up

## Part A: Synchronous Bulk Task Launch

```bash
xmake run part_a mandelbrot_chunked
xmake run part_a -n 8 mandelbrot_chunked
```

## Part B: Supporting Execution of Task Graphs

因为两个作业都是一份 main 代码，所以运行命令同上就可

```bash
xmake run part_b
```

## 测试

在 src/Assignment2/xmake.lua 写了个脚本运行所有测试函数
```
xmake build part_a
xmake run part_a_test
xmake build part_b
xmake run part_b_test
```

## 与官方实现对比
因为官方没有提供 Windows 二进制，这一步测试需要 Linux/Mac 系统才能完成。

```bash
cd src/Assignment2/tests
python run_test_harness.py -h
python run_test_harness.py -t super_light super_super_light
```
