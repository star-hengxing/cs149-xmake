# Assignment 2: Building A Task Execution Library from the Ground Up

## Part A: Synchronous Bulk Task Launch

```bash
xmake run part_a -n 8 mandelbrot_chunked
```

因为官方没有提供 Windows 二进制，这一步测试需要 Linux/Mac 系统才能完成。

```bash
cd src/Assignment2/tests
python run_test_harness.py -h
python run_test_harness.py -t super_light super_super_light
```

## Part B: Supporting Execution of Task Graphs

```bash
xmake run part_b
```
