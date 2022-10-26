# Test Harness Readme #
This readme is a description of the tests included in the test harness (`run_test_harness.py`). There are additional tests defined in `tests.h` and listed in the `main` function of `main.cpp`. Those tests can be run directly through the
`../part_*/runtasks` binary.

## SuperSuperLight ##
This test allocates two buffers of size 2^15 elements each and then simply copies elements from one buffer to the other buffer, reversing the order of the copy in each iteration. There are 64 tasks and 400 bulk task launches.

## SuperLight ##
This test allocates two buffers of size 2^15 elements each, and copies elements from one buffer to another in alternating order. Each task will increment values in the input buffer before copying the data to the output buffer. There are 64 tasks and 400 bulk task launches.

## PingPongEqual ##
This test allocates two buffers of size 2^19 elements each and copies elements from one buffer to another in alternating order. Each task will increment values in the input buffer before copying the data to the output buffer. The distribution of work across tasks is made to be equal. There are 64 tasks and 400 bulk task launches.

## PingPongUnequal ##
This test is the same as `pingPongEqual`, except it assigns more work to some tasks than others.

## RecursiveFibonacci ##
This test computes a Fibonacci number using a very compute-intensive recursive method. The computation is specified with 30 bulk task launches, each with 256 tasks. 

## MathOperationsInTightForLoop ##
Each task in this test takes no input and performs 32 compute-intensive computations involving exponent, logarithm, multiply, and add operations. The result of each computation is written into its own index in an output array. There are 16 tasks per bulk launch, the output array for each bulk launch is size 512, and there are 2000 bulk task launches. For the test with dependencies, each task depends on the previous task.

## MathOperationsInTightForLoopFewerTasks ##
This test is the same as `MathOperationsInTightForLoop`, except it splits up the 512 pieces of work per bulk launch among only 9 tasks. Therefore, each task gets a larger share of the computation, and some tasks get slightly more work than others.

## MathOperationsInTightForLoopFanIn ##
This test is split into two types of tasks. First is a set of compute-intensive math operations of the same type as `MathOperationsInTightForLoop`. The second is a single add-reduce operation, which occurs at the end. The reduce depends on all of the compute-intensive math tasks. For each bulk launch of math operations, there are 64 tasks writing to an array of size 2048, and there are 256 bulk launches. The reduce operation does a vector sum of the output vectors from all bulk launches, so the input of the reduce is a vector of size 256*2048 and the output is a vector of size 2048.

## MathOperationsInTightForLoopReductionTree ##
This test is similar to `MathOperationsInTightForLoopFanIn`, except instead of a single add-reduce, it does add-reduce operations in a binary-tree structure, where each add-reduce sums the results of two bulk task launches. Each add-reduce operation is dependent on two preceding operations, which are either both element-wise math or both add-reduce. For the math operations, there are 64 tasks per bulk launch writing to an array of size 16384, and there are 32 bulk launches. Each add-reduce takes an input array of size 32768 and outputs an array of size 16384.

## SpinBetweenRunCalls ##
First, spawns one bulk task launch of a single lightweight task that simply copies a single value to an output array. Second, spawns a launch of 2 medium-weight tasks that each compute the 40th Fibonacci number using the recursive method. Third, spawns another launch of a single lightweight task. In the async case, the final task depends on the first two.

## MandelbrotChunked ##
This test uses 128 tasks in a single bulk task launch to compute a [Mandelbrot fractal](https://en.wikipedia.org/wiki/Mandelbrot_set) image by decomposing the problem into tasks that produce contiguous chunks of output image rows. The input to each task is a specification of the view window and specifics of the Mandelbrot fractal algorithm. The output is an array containing the Mandelbrot fractal image. The computation itself is compute-intensive. Note that, because only one bulk task launch is performed, thread pool and spawning threads each run() should have similar performance.
