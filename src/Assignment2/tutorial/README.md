
# A Primer on C++ Synchronization #

Your programming assignment 2 solutions will certainly need to create threads, and may need to make use of two types of synchronization primitives: mutexes and condition variables.  The following notes explain these two types of synchronization.

We provide you basic examples of creating C++ threads, locking/unlocking mutexes, and using condition variables in the file `tutorial/tutorial.cpp` provided in the starter code.

## Creating C++ Threads ##

Creating new threads in C++ is simple.  To create threads, an application constructs new instances of the `std::thread` object.  For example, in the code below, the main thread creates two threads that run the function `my_func`. (Observe that the function `my_func` is used as an argument to the `std::thread` constructor.)  The main thread invokes `join()` to determine when the execution of a spawned thread has completed.

    #include <thread>
    #include <stdio.h>

    void my_func(int thread_id, int num_threads) {
    	printf("Hello from spawned thread %d of %d\n", thread_id, num_threads);
    }

    int main(int argc, char** argv) {
    
      std::thread t0 = std::thread(my_func, 0, 2);
      std::thread t1 = std::thread(my_func, 1, 2);
    
      printf("The main thread is running concurrently with spawned threads.\n");
    
      t0.join();
      t1.join();
    
      printf("Spawned threads have terminated at this point.\n");
    
      return 0;
    }

Full documentation of `std::thread` can be found here: <https://en.cppreference.com/w/cpp/thread/thread>.

Useful tutorials on creating threads in C++ 11:

 * <https://www.geeksforgeeks.org/multithreading-in-cpp/>
 * <https://thispointer.com/c-11-multithreading-part-1-three-different-ways-to-create-threads/>

## Mutexes ##

C++ standard library provides a mutex synchronization primitive, `std::mutex`, for protecting shared data from simultaneous access by multiple application threads. (Note: mutex is short for "mutual exclusion").  

<https://en.cppreference.com/w/cpp/thread/mutex>

You have already encountered mutexes in prior courses like CS110.  A thread locks the mutex using `mutex::lock()`. The calling thread will block until the mutex lock can be acquired.  When `lock()` returns to the caller, the calling thread is guaranteed to have the lock.  A thread unlocks the mutex using `mutex::unlock()`.

For those interested, C++ provides a number of wrapper classes that are designed to reduce bugs when using locks (e.g., forgetting to unlock a mutex).  You may wish to look at the definitions of [`std::unique_lock`](https://en.cppreference.com/w/cpp/thread/unique_lock) and [`std::lock_guard`](https://en.cppreference.com/w/cpp/thread/lock_guard).  For example `lock_guard` automatically locks a specified mutex on construction, and unlocks the mutex when it is goes out of scope.

We recommend that you take a look at the function `mutex_example()` in `tutorial/tutorial.cpp` for a simple example of using a mutex to protect updates to a shared counter.  In this example, the mutex is used to ensure the read-modify-write to the counter is performed atomically.

## Condition Variables ##

A condition variable manages a list of threads waiting for a condition to hold (e.g., an event to occur), and allows other threads to notify the waiting threads that the event of interest has occurred. A condition variable, when used in conjunction with a mutex, provides an easy way to send notifications between threads.

There are two major operations on a condition variable: `wait()` and `notify()`.

A thread calls `wait(lock)` to indicate it wishes to wait until a notfication from another thread.  Notice that a mutex (wrapped in a `std::unique_lock`) is passed to the call to `wait()`.  When the thread is notified, the condition variable will acquire the lock.  This means that when a call to `wait()` returns, the calling thread is the current holder of the lock.  Typically the lock is used to protect a shared variable that the thread now needs to check to ensure the condition it is waiting for is true.  

For example, the code in `tutorial/tutorial.cpp` creates N threads.  N-1 of the threads wait for notification from thread 0, and then when notified, atomically increment a counter that is protected by a shared mutex.

A thread calls `notify()` on a condition variable to notify exactly one thread waiting on the condition variable and `notify_all()` to notify all threads waiting on the condition variable.  Notice how in `tutorial/tutorial.cpp`, thread 0 releases the lock protecting the counter prior to signaling all the waiting threads.

In your task execution system implementation, how might you use `notify_all()`?  Consider a situation where all worker threads are currently waiting for a new bulk task launch, and the application makes a call to `run()`, providing new tasks to execute.


Additional references:

* <https://thispointer.com/c11-multithreading-part-7-condition-variables-explained>
* <https://www.modernescpp.com/index.php/condition-variables>

## C++ Atomics ##

C++ also provides a simple way to make operations on a variable atomic---just create a variable of the type `std::atomic<T>`. For example to create an integer that supports atomic increment, just create a variable of type:

    std::atomic<int> my_counter;

Now operations on `my_counter`, like `my_counter++` are guaranteed to be performed atomically.  For more detail see: <https://en.cppreference.com/w/cpp/atomic/atomic>.
