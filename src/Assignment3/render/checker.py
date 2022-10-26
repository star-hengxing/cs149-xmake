#!/usr/bin/python3

import subprocess
import os
import shutil
import re
import math

perf_pts = 10
correctness_pts = 2

# scene_names = ["rand100k"]
# score_scene_names = {"rand100k"}
scene_names = ["rgb", "rgby", "rand10k", "rand100k", "biglittle", "littlebig", "pattern", "bouncingballs", "hypnosis", "fireworks", "snow", "snowsingle"]
score_scene_names_list = ["rgb", "rand10k", "rand100k", "pattern", "snowsingle", "biglittle"]
score_scene_names = set(score_scene_names_list)

#### LOGS MANAGEMENT ####
# Set up a new logs dir (remove old logs dir, create new logs dir)
if os.path.isdir('logs'):
    shutil.rmtree('logs')
os.mkdir('logs')

# Helper functions to convert scene names to appropriate log file names
def correctness_log_file(scene):
    return "./logs/correctness_%s.log" % scene

def time_log_file(scene):
    return "./logs/time_%s.log" % scene
#### END OF LOGS MANAGEMENT ####

#### RUNNING THE RENDERERS ####
def check_correctness(render_cmd, scene):
    cmd_string = "./%s -c %s -s 1024 > %s" % (render_cmd, scene, correctness_log_file(scene))
    # print("Checking correctness: %s" % cmd_string)

    # Actually run it
    result = subprocess.run([cmd_string], shell=True)

    return result.returncode == 0

# Run a renderer one time and get the time taken
def get_time(render_cmd, scene):
    # print("get_time %s %s" % (render_cmd, scene))
    cmd_string = "./%s -r cuda -b 0:4 %s -s 1024 | tee %s | grep Total:" % (render_cmd, scene, time_log_file(scene))

    # Actually run the renderer
    result = subprocess.run([cmd_string], shell=True, capture_output=True)

    # Extract the time taken
    time = float(re.search(r'\d+\.\d+', str(result.stdout)).group())
    return time
#### END OF RUNNING THE RENDERERS ####


# Run all scenes. Some of them are for performance.
def run_scenes(n_runs):
    correct = {}
    stu_times = {}
    ref_times = {}
    for scene in scene_names:
        print("\nRunning scene: %s..." % (scene))

        # Check for correctness
        correct[scene] = check_correctness("render", scene)
        if not correct[scene]:
            print("[%s] Correctness failed ... Check %s" % (scene, correctness_log_file(scene)))
        else:
            print("[%s] Correctness passed!" % scene)

        # Check for performance
        if scene in score_scene_names:

            # Do multiple perf runs
            stu_times[scene] = [get_time("render", scene) for _ in range(n_runs)]
            ref_times[scene] = [get_time("render_ref", scene) for _ in range(n_runs)]

            print("[%s] Student times: " % (scene), stu_times[scene])
            print("[%s] Reference times: " % (scene), ref_times[scene])

    return correct, stu_times, ref_times

# Compute scores
def score_table(correct, stu_times, ref_times):
    print("------------")
    print("Score table:")
    print("------------")
    header = "| %-15s | %-16s | %-15s | %-15s |" % ("Scene Name", "Ref Time (T_ref)", "Your Time (T)", "Score")
    dashes = "-"*len(header)
    print(dashes)
    print(header)
    print(dashes)

    total_score = 0

    for scene in score_scene_names_list:
        stu_time = min(stu_times[scene])
        ref_time = min(ref_times[scene])
        if correct[scene]:
            if stu_time <= 1.2 * ref_time:
                score = perf_pts + correctness_pts
            elif stu_time > 10 * ref_time:
                score = correctness_pts
            else:
                score = correctness_pts + math.ceil(perf_pts * (ref_time / stu_time))
        else:
            score = 0

        print("| %-15s | %-16s | %-15s | %-15s |" % (scene, ref_time, stu_time if correct[scene] else "(F)", score));
        total_score += score

    print(dashes)

    max_total_score = (perf_pts + correctness_pts) * len(score_scene_names)
    score_string = "%s/%s" % (total_score, max_total_score)
    print("| %-15s   %-16s | %-15s | %-15s |" % ("", "", "Total score:", score_string))

    print(dashes)

correct, stu_times, ref_times = run_scenes(3)
score_table(correct, stu_times, ref_times)
