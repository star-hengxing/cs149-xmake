# Assignment 4: Big Graph Processing in OpenMP #

**Due: Thursday Dec 1st, 11:59PM PST**

**100 points total**

## Overview ##

In this assignment, you will implement two graph processing algorithms: [breadth-first search](https://en.wikipedia.org/wiki/Breadth-first_search) (BFS) and a simple implementation of [page rank](https://en.wikipedia.org/wiki/PageRank). A good implementation of this assignment will be able to run these algorithms on graphs containing hundreds of millions of edges on a multi-core machine in only seconds.

## Environment Setup ##

Early starters of this assignment should get started by running on the 4-core (8 hyperthread) machines in the Myth cluster.  These machines will suffice for basic development and performance testing.  However final grading will be performed on 32 vCPU machines that you will run on the AWS cloud platform (see [cloud_readme.md](cloud_readme.md) for setup).

To get started on myth machines:

**Note: to do this step, you may need to add an SSH key pair to your GitHub account and the myth machines:** [Add SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

Download the Assignment 4 starter code from the course Github page using:

    git clone git@github.com:stanford-cs149/asst4.git

#### Background: Learning OpenMP ####

In this assignment we'd like you to use [OpenMP](http://openmp.org/) for multi-core parallelization. OpenMP is an API and set of C-language extensions that provides compiler support for parallelism. You can also use OpenMP to tell the compiler to parallelize iterations of `for` loops, and to manage mutual exclusion. It is well documented online, but here is a brief example of parallelizing a `for` loop, with mutual exclusion.

    /* The iterations of this for loop may be parallelized by the compiler */      
    #pragma omp parallel for                                                      
    for (int i = 0; i < 100; i++) {  
    
      /* different iterations of this part of the loop body may be
         run in parallel on different cores */
    
      #pragma omp critical                                                          
      {
        /* This block will be executed by at most one thread at a time. */
        printf("Thread %d got iteration %lu\n", omp_get_thread_num(), i);           
      }                                                                             
    }
    
Please see OpenMP documentation for the syntax for how to tell OpenMP to use different forms of static or dynamic scheduling. (For example, `omp parallel for schedule(dynamic 100)` distributes iterations to threads using dynamic scheduling with a chunk size of 100 iterations.  You can think of the implementation as a dynamic work queue where threads in the thread pool pull off 100 iterations at once, like what [we talked about in these lecture slides](https://gfxcourses.stanford.edu/cs149/fall22/lecture/perfopt1/slide_11).
    
Here is an example for an atomic counter update in OpenMP.

    int my_counter = 0;
    #pragma omp parallel for                                                        
    for (int i = 0; i < 100; i++) {                                                      
        if ( ... some condition ...) {
           #pragma omp atomic
           my_counter++;
        }
    }

We expect you to be able to read OpenMP documentation on your own (Google will be very helpful), but here are some useful links to get you started:

 * The OpenMP 3.0 specification: <http://www.openmp.org/mp-documents/spec30.pdf>.
 * An OpenMP cheat sheet <http://openmp.org/mp-documents/OpenMP3.1-CCard.pdf>.
 * OpenMP has support for reductions on shared variables, and for declaring thread-local copies of variables.
 * This is a nice guide for the `omp parallel_for` directives: <http://www.inf.ufsc.br/~bosco.sobral/ensino/ine5645/OpenMP_Dynamic_Scheduling.pdf>

#### Background: Representing Graphs ####

The starter code operates on directed graphs, whose implementation you can find in `graph.h` and `graph_internal.h`.  We recommend you begin by understanding the graph representation in these files. A graph is represented by an array of edges (both `outgoing_edges` and `incoming_edges`), where each edge is represented by an integer describing the id of the destination vertex.  Edges are stored in the graph sorted by their source vertex, so the source vertex is implicit in the representation.  This makes for a compact representation of the graph, and also allows it to be stored contiguously in memory.  For example, to iterate over the outgoing edges for all nodes in the graph, you'd use the following code which makes use of convenient helper functions defined in `graph.h` (and implemented in `graph_internal.h`):

    for (int i=0; i<num_nodes(g); i++) {
      // Vertex is typedef'ed to an int. Vertex* points into g.outgoing_edges[]
      const Vertex* start = outgoing_begin(g, i);
      const Vertex* end = outgoing_end(g, i);
      for (const Vertex* v=start; v!=end; v++)
        printf("Edge %u %u\n", i, *v);
    }


## Part 1: Warm up: Implementing Page Rank (16 points) ##

As a simple warm up exercise to get comfortable using the graph data structures, and to get acquainted with a few OpenMP basics, we'd like you to begin by implementing a basic version of the well-known [page rank](https://en.wikipedia.org/wiki/PageRank) algorithm.  

Please take a look at the pseudocode provided to you in the function `pageRank()`, in the file `pagerank/page_rank.cpp.`.  You should implement the function, parallelizing the code with OpenMP.  Just like any other algorithm, first identify independent work and any necessary sychronization.

You can run your code, checking correctness and performance against the staff reference solution using:

    ./pr <PATH_TO_GRAPHS_DIRECTORY>/com-orkut_117m.graph 
    
If you are working on a myth machine, we've located a copy of the graphs directory at `/afs/ir.stanford.edu/class/cs149/data/asst3_graphs/`.  You can also download the graphs from <http://cs149.stanford.edu/cs149asstdata/all_graphs.tgz>. (On AWS, you can do: `wget http://cs149.stanford.edu/cs149asstdata/all_graphs.tgz` and then untar the resulting `all_graphs.tgz` file with `tar -xzvf all_graphs.tgz`. On your local machine, please paste the preceding link into your browser to download the .tgz file. In both cases, be careful, this is a 3 GB download.) Some interesting real-world graphs include:

 * com-orkut_117m.graph 
 * oc-pokec_30m.graph
 * soc-livejournal1_68m.graph
 
Your useful synthetic, but large graphs include:

 * random_500m.graph
 * rmat_200m.graph

There are also some very small graphs for testing.  If you look in the `/tools` directory of the starter code, you'll notice a useful program called `graphTools.cpp` that can be used to make your own graphs as well.

By default, the `pr` program runs your page rank algorithm with an increasing number of threads (so you can assess speedup trends).  However, since runtimes at low core counts can be long, you can explicitly specify the number of threads to only run your code under a single configuration.

    ./pr %GRAPH_FILENAME% 8

Your code should handle cases where there are no outgoing edges by distributing the probability mass on such vertices evenly among all the vertices in the graph. That is, your code should work as if there were edges from such a node to every node in the graph (including itself). The comments in the starter code describe how to handle this case.

You can also run our grading script via: `./pr_grader <path to graphs directory>`, which will report correctness and a performance points score for a number of graphs.

__NOTE__: a common pitfall students hit when implementing `page_rank` is they find their implementation fails the correctness check based on very small differences between their code's output values and the reference. Since the errors are very small, it's reasonable to (often incorrectly) assume these differences in value are due to differences in the order of floating point arithmetic between the student and reference solution, and that the checker should be more lenient in its checks.  However, our experience is that observing these differences is *almost, almost always an error in the student's code*. 

__Tips:__ 

Accumulating into a shared variable can be done by marking the variable as a "reduction" variable in an OpenMP loop.

     float A[100];
     float mySum = 0.0;
     #pragma omp parallel for reduction(+:mySum)
     for (int i=0; i<100; i++) {
         mySum += A[i];
     }

## Part 2: Parallel Breadth-First Search ("Top Down") ##

Breadth-first search (BFS) is a common algorithm that might have seen in a prior algorithms class (See [here](https://www.hackerearth.com/practice/algorithms/graphs/breadth-first-search/tutorial/) and [here](https://www.youtube.com/watch?v=oDqjPvD54Ss) for helpful references.)
Please familiarize yourself with the function `bfs_top_down()` in `bfs/bfs.cpp`, which contains a sequential implementation of BFS. The code uses BFS to compute the distance to vertex 0 for all vertices in the graph. You may wish to familiarize yourself with the graph structure defined in `common/graph.h` as well as the simple array data structure `vertex_set` (`bfs/bfs.h`), which is an array of vertices used to represent the current frontier of BFS.

You can run bfs using:

    ./bfs <PATH_TO_GRAPHS_DIRECTORY>/rmat_200m.graph
    
(as with page rank, bfs's first argument is a graph file, and an optional second argument is the number of threads.)

When you run `bfs`, you'll see execution time and the frontier size printed for each step in the algorithm.  Correctness will pass for the top-down version (since we've given you a correct sequential implementation), but it will be slow.  (Note that `bfs` will report failures for a "bottom up" and "hybrid" versions of the algorithm, which you will implement later in this assignment.)

In this part of the assignment your job is to parallelize top-down BFS. As with page rank, you'll need to focus on identifying parallelism, as well as inserting the appropriate synchronization to ensure correctness. We wish to remind you that you __should not__ expect to achieve near-perfect speedups on this problem (we'll leave it to you to think about why!). 

__Tips/Hints:__

* Always start by considering what work can be done in parallel.
* Some parts of the computation may need to be synchronized, for example, by wrapping the appropriate code within a critical region using `#pragma omp critical` or `#pragma omp atomic`.  __However, in this problem you should think about how to make use of the simple atomic operation called `compare and swap`.__  You can read about [GCC's implementation of compare and swap](http://gcc.gnu.org/onlinedocs/gcc-4.1.2/gcc/Atomic-Builtins.html), which is exposed to C code as the function `__sync_bool_compare_and_swap`.  If you can figure out how to use compare-and-swap for this problem, you will achieve much higher performance than using a critical region. 
* Updating a shared counter can be done efficiently using `#pragma omp atomic` before a line like `counter++;`. 
* Are there conditions where it is possible to avoid using `compare_and_swap`?  In other words, when you *know* in advance that the comparison will fail?
* There is a preprocessor macro `VERBOSE` to make it easy to disable useful print per-step timings in your solution (see the top of `bfs/bfs.cpp`).  In general, these printfs occur infrequently enough (only once per BFS step) that they do not notably impact performance, but if you want to disable the printfs during timing, you can use this `#define` as a convenience.

### Part 3: "Bottom Up" BFS ###

Think about what behavior might cause a performance problem in the BFS implementation from Part 1.2.  An alternative implementation of a breadth-first search step may be more efficient in these situations.  Instead of iterating over all vertices in the frontier and marking all vertices adjacent to the frontier, it is possible to implement BFS by having *each vertex check whether it should be added to the frontier!*  Basic pseudocode for the algorithm is as follows:

    for each vertex v in graph:
        if v has not been visited AND 
           v shares an incoming edge with a vertex u on the frontier:
              add vertex v to frontier;

This algorithm is sometimes referred to as a "bottom up" implementation of BFS, since each vertex looks "up the BFS tree" to find its ancestor. (As opposed to being found by its ancestor in a "top down" fashion, as was done in Part 1.2.)

Please implement a bottom-up BFS to compute the shortest path to all the vertices in the graph from the root (see `bfs_bottom_up()` in `bfs/bfs.cpp`). Start by implementing a simple sequential version. Then parallelize your implementation.

__Tips/Hints:__

* It may be useful to think about how you represent the set of unvisited nodes.  Do the top-down and bottom-up versions of the code lend themselves to different implementations?  
* How do the synchronization requirements of the bottom-up BFS change?

## Part 4: Hybrid BFS (70 points) ##

Notice that in some steps of the BFS, the "bottom up" BFS is signficantly faster than the top-down version.  In other steps, the top-down version is signficantly faster.  This suggests a major performance improvement in your implementation, if __you could dynamically choose between your "top down" and "bottom up" formulations based on the size of the frontier or other properties of the graph!__  If you want a solution competitive with the reference one, your implementation will likely have to implement this dynamic optimization.  Please provide your solution in `bfs_hybrid()` in `bfs/bfs.cpp`.

__Tips/Hints:__

* If you used different representations of the frontier in Parts 1.2 and 1.3, you may have to convert between these representations in the hybrid solution.  How might you efficiently convert between them? Is there an overhead in doing so?

You can run our grading script via: `./bfs_grader <path to graphs directory>`, which will report correctness and a performance points score for a number of graphs.

## Grading and Handin ##

We have a leaderboard for this assignment, which will be live at [http://34.218.250.164/](http://34.218.250.164/). For the leaderboard, we will run your code on a subset of the BFS tests.

Along with your code, we would like you to hand in a clear but concise high-level description of how your implementation works as well as a brief description of how you arrived at your solutions. Specifically address approaches you tried along the way, and how you went about determining how to optimize your code (For example, what measurements did you perform to guide your optimization efforts?).

Aspects of your work that you should mention in the write-up include:

1. Include both partners' names at the top of your write-up.
2. Run bfs_grader and pr_grader on AWS and insert a copy of the score table in your solutions.
3. For bfs, describe the process of optimizing your code:
 * In Part 2 (Top Down) and 3 (Bottom Up), where is the synchronization in each of your solutions? Do you do anything to limit the overhead of synchronization?
 * In Part 4 (Hybrid), did you decide to switch between the top-down and bottom-up BFS implementations dynamically? How did you decide which implementation to use?
 * Why do you think your code (and the staff reference) is unable to achieve perfect speedup? (Is it workload imbalance? communication/synchronization? data movement?)

## Points Distribution ##

The 100 points on this assignment are allotted as follows:

* 16 points:  Pagerank performance
* 70 points:  BFS performance
* 14 points:  Write-up

For your final grade, the above 100 points will be scaled by 0.94, with the other 0.06 of your grade coming from your performance on the BFS leaderboard.

## Hand-in Instructions ##

Please submit your work using Gradescope.

1. __Please submit your writeup as a PDF in the Gradescope assignment Programming Assignment 4 (Writeup Submission).__
2. __To submit your code, please name your assignment 4 directory `code` and compress the directory by running `tar -czvf asst4.tar.gz code`. Submit the resulting `asst4.tar.gz` in the Gradescope assignment Programming Assignment 4 (Code Submission).__  Just submit your full assignment 4 source tree. To keep submission sizes small, please do a `make clean` in the program directories prior to creating the archive, and remove any residual output, etc. Before submitting the source files, make sure that all code is compilable and runnable! We should be able to simply make, then execute your programs in the `/bfs` the `/pagerank` directories without manual intervention. 

Our grading scripts will rerun the checker code allowing us to verify your score matches what you submitted in the `writeup.pdf`.  We may also run your code on other datasets to further examine its correctness.
