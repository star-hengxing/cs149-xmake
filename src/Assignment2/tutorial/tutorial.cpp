#include <condition_variable>
#include <mutex>
#include <thread>

#include <stdio.h>

/*
 Wrapper class around an integer counter and a mutex.
 */
class Counter {
    public:
        int counter_;
        std::mutex* mutex_;
        Counter() {
            counter_ = 0;
            mutex_ = new std::mutex();
        }
        ~Counter() {
            delete mutex_;
        }
};

void increment_counter_fn(Counter* counter) {
    for (int i = 0; i < 10000; i++) {
        // Call lock() method to acquire lock.
        counter->mutex_->lock();
        // Since multiple threads are trying to perform an increment, the
        // increment needs to be protected by a mutex.
        counter->counter_++;
        // Call unlock() method to release lock.
        counter->mutex_->unlock();
    }
}

/*
 * Threads increment a shared counter in a tight for loop 10,000 times.
 */
void mutex_example() {
    int num_threads = 8;

    printf("==============================================================\n");
    printf("Starting %d threads to increment counter...\n", num_threads);
    std::thread* threads = new std::thread[num_threads];
    Counter* counter = new Counter();
    // `num_threads` threads will call `increment_counter_fn`, trying to
    // increment `counter`.
    for (int i = 0; i < num_threads; i++) {
        threads[i] = std::thread(increment_counter_fn, counter);
    }
    // Wait for spawned threads to complete.
    for (int i = 0; i < num_threads; i++) {
        threads[i].join();
    }
    // Verify that final counter value is (10000 * `num_threads`).
    printf("Final counter value: %d...\n", counter->counter_);
    printf("==============================================================\n");

    delete counter;
    delete[] threads;
}

/*
 * Wrapper class around a counter, a condition variable, and a mutex.
 */
class ThreadState {
    public:
        std::condition_variable* condition_variable_;
        std::mutex* mutex_;
        int counter_;
        int num_waiting_threads_;
        ThreadState(int num_waiting_threads) {
            condition_variable_ = new std::condition_variable();
            mutex_ = new std::mutex();
            counter_ = 0;
            num_waiting_threads_ = num_waiting_threads;
        }
        ~ThreadState() {
            delete condition_variable_;
            delete mutex_;
        }
};

void signal_fn(ThreadState* thread_state) {
    // Acquire mutex to make sure the shared counter is read in a
    // consistent state.
    thread_state->mutex_->lock();
    while (thread_state->counter_ < thread_state->num_waiting_threads_) {
        thread_state->mutex_->unlock();
        // Release the mutex before calling `notify_all()` to make sure
        // waiting threads have a chance to make progress.
        thread_state->condition_variable_->notify_all();
        // Re-acquire the mutex to read the shared counter again.
        thread_state->mutex_->lock();
    }
    thread_state->mutex_->unlock();
}

void wait_fn(ThreadState* thread_state) {
    // A lock must be held in order to wait on a condition variable.
    // This lock is atomically released before the thread goes to sleep
    // when `wait()` is called. The lock is atomically re-acquired when
    // the thread is woken up using `notify_all()`.
    std::unique_lock<std::mutex> lk(*thread_state->mutex_);
    thread_state->condition_variable_->wait(lk);
    // Increment the shared counter with the lock re-acquired to inform the
    // signaling thread that this waiting thread has successfully been
    // woken up.
    thread_state->counter_++;
    printf("Lock re-acquired after wait()...\n");
    lk.unlock();
}

/*
 * Signaling thread spins until each waiting thread increments a shared
 * counter after being woken up from the `wait()` method.
 */
void condition_variable_example() {
    int num_threads = 3;

    printf("==============================================================\n");
    printf("Starting %d threads for signal-and-waiting...\n", num_threads);
    std::thread* threads = new std::thread[num_threads];
    ThreadState* thread_state = new ThreadState(num_threads-1);
    threads[0] = std::thread(signal_fn, thread_state);
    for (int i = 1; i < num_threads; i++) {
        threads[i] = std::thread(wait_fn, thread_state);
    }
    for (int i = 0; i < num_threads; i++) {
        threads[i].join();
    }
    printf("==============================================================\n");

    delete thread_state;
    delete[] threads;
}


int main(int argc, char** argv) {
   mutex_example();
   condition_variable_example();
}
