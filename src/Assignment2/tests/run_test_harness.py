import argparse
import platform
import re
import subprocess
import multiprocessing

STUDENT_BINARY_NAME = "runtasks"
REFERENCE_BINARY_NAME = "runtasks_ref"

TASKSYS_DEFAULT_NUM_THREADS = 8
UNSPECIFIED_NUM_THREADS = -1

PERF_THRESHOLD = 1.2
NUM_TEST_RUNS = 5

LIST_OF_TESTS = [
    ("super_super_light", UNSPECIFIED_NUM_THREADS),
    ("super_light", UNSPECIFIED_NUM_THREADS),
    ("ping_pong_equal", UNSPECIFIED_NUM_THREADS),
    ("ping_pong_unequal", UNSPECIFIED_NUM_THREADS),
    ("recursive_fibonacci", UNSPECIFIED_NUM_THREADS),
    ("math_operations_in_tight_for_loop", UNSPECIFIED_NUM_THREADS),
    ("math_operations_in_tight_for_loop_fewer_tasks", UNSPECIFIED_NUM_THREADS),
    ("math_operations_in_tight_for_loop_fan_in", UNSPECIFIED_NUM_THREADS),
    ("math_operations_in_tight_for_loop_reduction_tree", UNSPECIFIED_NUM_THREADS),
    ("spin_between_run_calls", UNSPECIFIED_NUM_THREADS),
    ("mandelbrot_chunked", UNSPECIFIED_NUM_THREADS),
]

LIST_OF_IMPLEMENTATIONS_ORIG = [
    "REFERENCE [Serial]",
    "REFERENCE [Parallel + Always Spawn]",
    "REFERENCE [Parallel + Thread Pool + Spin]",
    "REFERENCE [Parallel + Thread Pool + Sleep]",
    "STUDENT [Serial]",
    "STUDENT [Parallel + Always Spawn]",
    "STUDENT [Parallel + Thread Pool + Spin]",
    "STUDENT [Parallel + Thread Pool + Sleep]",
]

AUTHORS = ["STUDENT", "REFERENCE"]

LIST_OF_IMPLEMENTATIONS = [
    "[Serial]",
    "[Parallel + Always Spawn]",
    "[Parallel + Thread Pool + Spin]",
    "[Parallel + Thread Pool + Sleep]",
]


def run_test(cmd, is_reference):
    runtimes = {}
    try:
        output = subprocess.check_output(cmd, shell=True).decode('utf-8')
        for line in output.split('\n'):
            m = re.match(r'\[(.*)\]:\s+\[(\d+\.\d+)\] ms', line)
            if m is not None:
                implementation = m.group(1)
                if is_reference:
                    implementation = "REFERENCE [%s]" % implementation
                else:
                    implementation = "STUDENT [%s]" % implementation
                runtime = float(m.group(2))
                runtimes[implementation] = [runtime]
    except Exception as e:
        print(e)
        print("%s solution failed correctness check!" % ("REFERENCE" if is_reference else "STUDENT"))
    return runtimes

def pretty_print(test_name, runtimes):
    print("Results for: %s" % test_name)
    for implementation in LIST_OF_IMPLEMENTATIONS_ORIG:
        if implementation in runtimes:
            print("%s\t%.3f" % (implementation, runtimes[implementation]))

def pretty_print_with_comparison(test_name, runtimes, perf_threshold, impl_perf_ok):
    print("Results for: %s" % test_name)
    
    print("%s%s%sPERF?" % (" " * 40, "{:<10}".format(AUTHORS[0]), "{:<12}".format(AUTHORS[1])))
    for impl in LIST_OF_IMPLEMENTATIONS:
        student_impl = AUTHORS[0] + " " + impl 
        ref_impl = AUTHORS[1] + " " + impl 
        student_time = runtimes[student_impl] if student_impl in runtimes else "Missing"
        ref_time = runtimes[ref_impl] if ref_impl in runtimes else "Missing"

        try:
            relative_perf = student_time / ref_time
        except:
            continue

        # Check the threshold
        perf_ok = relative_perf < perf_threshold
        feedback = "(OK)" if perf_ok else "(NOT OK)"

        if not perf_ok:
            impl_perf_ok[impl] = False

        print("{:<40}{:<10}{:<12}{:.2f}  {}".format(impl, student_time, ref_time, relative_perf, feedback))



if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Run task system performance tests')
    
    parser.add_argument('-n', '--num_threads', type=int,
                        default=TASKSYS_DEFAULT_NUM_THREADS,
                        help="Max number of threads that the task system can use. (%d by default)" % TASKSYS_DEFAULT_NUM_THREADS)
    parser.add_argument('-t', '--test_names', type=str, nargs='+',
                        default=[x[0] for x in LIST_OF_TESTS],
                        help='List of tests to run: %s' % ", ".join([
                            x[0] for x in LIST_OF_TESTS]))
    parser.add_argument('-a', '--run_async', action='store_true',
                        help='Run async tests')

    args = parser.parse_args()

    test_names_and_num_threads = []

    # Some tests directly specify the number of threads the task system should use. 
    # Other tests should configure the task system to use the default number of threads 
    for x in LIST_OF_TESTS:
        if x[0] not in args.test_names:
            continue

        if x[1] == UNSPECIFIED_NUM_THREADS:
            num_threads = args.num_threads
        else:
            num_threads = x[1]
        test_names_and_num_threads.append( (x[0], num_threads) )
        if args.run_async:
            test_names_and_num_threads.append( (x[0] + "_async", num_threads) )

    print("==============================================================="
          "=================")
    print("Running task system grading harness... (%d total tests)" % len(test_names_and_num_threads))
    print("  - Detected CPU with %d execution contexts" % multiprocessing.cpu_count())
    print("  - Task system configured to use at most %d threads" % args.num_threads)
    print("==============================================================="
          "=================")

    runtimes_of_test = {}
    impl_perf_ok = {impl: True for impl in LIST_OF_IMPLEMENTATIONS}

    # run all tests
    for (test_name, num_threads) in test_names_and_num_threads:
        
        print("==============================================================="
              "=================")
        print("Executing test: %s..." %  test_name)

        # Use the right binary for OSX / Linux
        if platform.system() == 'Darwin':
            # distinguish x86 and ARM
            if platform.machine() == "arm64":
                print("Reference binary: ./runtasks_ref_osx_arm")
                ref_cmd = "./%s_osx_arm -n %d" % (REFERENCE_BINARY_NAME, num_threads);
            else:
                print("Reference binary: ./runtasks_ref_osx_x86")
                ref_cmd = "./%s_osx_x86 -n %d" % (REFERENCE_BINARY_NAME, num_threads);
        else:
            print("Reference binary: ./runtasks_ref_linux")
            ref_cmd = "./%s_linux -n %d" % (REFERENCE_BINARY_NAME, num_threads);
        student_cmd = "./%s -n %d" % (STUDENT_BINARY_NAME, num_threads);

        cmds = [ref_cmd, student_cmd]
        is_references = [True, False]
        all_runtimes = {}
        for i in range(NUM_TEST_RUNS):
            for (cmd, is_reference) in zip(cmds, is_references):
                cmd = "%s %s" % (cmd, test_name)
                runtimes = run_test(cmd, is_reference=is_reference)
                for key in runtimes:
                    if key not in all_runtimes:
                        all_runtimes[key] = []
                    all_runtimes[key] += runtimes[key]
        for key in all_runtimes:
            all_runtimes[key] = min(all_runtimes[key])
        pretty_print_with_comparison(test_name, all_runtimes, PERF_THRESHOLD, impl_perf_ok)
        
        runtimes_of_test[test_name] = all_runtimes

    # Compare student's implementation against reference
    print("==============================================================="
          "=================")
    print("Overall performance results")
    for impl in LIST_OF_IMPLEMENTATIONS:
        final_feedback = "All passed Perf" if impl_perf_ok[impl] else "Perf did not pass all tests"
        print("{:<40}: {}".format(impl, final_feedback))
