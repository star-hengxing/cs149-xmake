# Assignment 3: A Simple CUDA Renderer

如果是从`scoop`安装的 cuda，需要设置环境变量`CUDA_PATH=C:/Users/<User>/scoop/apps/cuda`，或者在 xmake 里指定目录。

```bash
xmake f --cuda=C:/Users/<User>/scoop/apps/cuda
```

## Part 1: CUDA Warm-Up 1: SAXPY

```bash
xmake run cudaSaxpy
```

## Part 2: CUDA Warm-Up 2: Parallel Prefix-Sum

```bash
xmake run cudaScan
```

检查性能

TODO：perl 脚本不跨平台，先不要使用。

```bash
cd src/Assignment3/scan
perl checker.pl scan
```

## Part 3: A Simple Circle Renderer

`wingdi.h`与`circleRenderer.h`的 `enum SceneName`中`PATTERN`命名冲突，改成`PATTERN_`。

```bash
xmake run render
xmake run render -r cpuref rgb
xmake run render -r cpuref snow
```

检查性能。

```bash
cd src/Assignment3/render
python checker.py
```
