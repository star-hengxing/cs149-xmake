#include <stdlib.h>
#include <stdio.h>
#include <getopt.h>
#include <string>

#include "refRenderer.h"
#include "cudaRenderer.h"
#include "platformgl.h"

#define DEFAULT_IMAGE_SIZE 1024


void startRendererWithDisplay(CircleRenderer* renderer);
void startBenchmark(CircleRenderer* renderer, int startFrame, int totalFrames, const std::string& frameFilename);
void CheckBenchmark(CircleRenderer* ref_renderer, CircleRenderer* cuda_renderer,
                        int benchmarkFrameStart, int totalFrames, const std::string& frameFilename);


void usage(const char* progname) {
    printf("Usage: %s [options] scenename\n", progname);
    printf("Valid scenenames are: rgb, rgby, rand10k, rand100k, biglittle, littlebig, pattern,\n"
           "                      bouncingballs, fireworks, hypnosis, snow, snowsingle\n");
    printf("Program Options:\n");
    printf("  -r  --renderer <cpuref/cuda>  Select renderer: ref or cuda (default=cuda)\n");
    printf("  -s  --size  <INT>             Rendered image size: <INT>x<INT> pixels (default=%d)\n", DEFAULT_IMAGE_SIZE);    
    printf("  -b  --bench <START:END>       Run for frames [START,END) (default=[0,1))\n");
    printf("  -c  --check                   Check correctness of CUDA output against CPU reference\n");
    printf("  -i  --interactive             Render output to interactive display\n");
    printf("  -f  --file  <FILENAME>        Output file name (FILENAME_xxxx.ppm) (default=output)\n");
    printf("  -?  --help                    This message\n");
}


int main(int argc, char** argv)
{

    int benchmarkFrameStart = 0;
    int benchmarkFrameEnd = 1;
    int imageSize = DEFAULT_IMAGE_SIZE;

    std::string sceneNameStr;
    std::string frameFilename("output");
    SceneName sceneName;
    bool useRefRenderer = false;
    bool checkCorrectness = false;
    bool interactiveMode = false;
    
    // parse commandline options ////////////////////////////////////////////
    int opt;
    static struct option long_options[] = {
        {"help",        0, 0,  '?'},
        {"check",       0, 0,  'c'},
        {"bench",       1, 0,  'b'},
	{"interactive", 0, 0,  'i'},
        {"file",        1, 0,  'f'},
        {"renderer",    1, 0,  'r'},
        {"size",        1, 0,  's'},
        {0 ,0, 0, 0}
    };

    while ((opt = getopt_long(argc, argv, "b:f:r:s:ci?", long_options, NULL)) != EOF) {

        switch (opt) {
        case 'b':
            if (sscanf(optarg, "%d:%d", &benchmarkFrameStart, &benchmarkFrameEnd) != 2) {
                fprintf(stderr, "Invalid argument to -b option\n");
                usage(argv[0]);
                exit(1);
            }
            break;
	case 'i':
   	    interactiveMode = true;
	    break;
        case 'c':
            checkCorrectness = true;
            break;
        case 'f':
            frameFilename = optarg;
            break;
        case 'r':
            if (std::string(optarg).compare("cuda") == 0) {
                useRefRenderer = false;
            } else if (std::string(optarg).compare("cpuref") == 0) {
	      useRefRenderer = true;
	    } else {
	      fprintf(stderr, "ERROR: Unknown renderer type: %s\n", optarg);
	      usage(argv[0]);
	      return 1;
	    }
            break;
        case 's':
            imageSize = atoi(optarg);
            break;
        case '?':
        default:
            usage(argv[0]);
            return 1;
        }
    }
    // end parsing of commandline options //////////////////////////////////////


    if (optind + 1 > argc) {
        fprintf(stderr, "Error: missing scene name\n");
        usage(argv[0]);
        return 1;
    }

    sceneNameStr = argv[optind];

    if (sceneNameStr.compare("snow") == 0) {
        sceneName = SNOWFLAKES;
    } else if (sceneNameStr.compare("snowsingle") == 0) {
        sceneName = SNOWFLAKES_SINGLE_FRAME;
    } else if (sceneNameStr.compare("rgb") == 0) {
        sceneName = CIRCLE_RGB;
    } else if (sceneNameStr.compare("rgby") == 0) {
        sceneName = CIRCLE_RGBY;
    } else if (sceneNameStr.compare("rand10k") == 0) {
        sceneName = CIRCLE_TEST_10K;
    } else if (sceneNameStr.compare("rand100k") == 0) {
        sceneName = CIRCLE_TEST_100K;
    } else if (sceneNameStr.compare("pattern") == 0) {
        sceneName = PATTERN_;
    } else if (sceneNameStr.compare("biglittle") == 0) {
        sceneName = BIG_LITTLE;
    } else if (sceneNameStr.compare("littlebig") == 0) {
        sceneName = LITTLE_BIG;
    } else if (sceneNameStr.compare("bouncingballs") == 0) {
        sceneName = BOUNCING_BALLS;  
    } else if (sceneNameStr.compare("hypnosis") == 0) { 
        sceneName = HYPNOSIS;           
    } else if (sceneNameStr.compare("fireworks") == 0) { 
        sceneName = FIREWORKS;    
    }else {
        fprintf(stderr, "Unknown scene name (%s)\n", sceneNameStr.c_str());
        usage(argv[0]);
        return 1;
    }

    printf("Rendering to %dx%d image\n", imageSize, imageSize);

    CircleRenderer* renderer;

    if (checkCorrectness) {
        // Need both the renderers

        CircleRenderer* ref_renderer;
        CircleRenderer* cuda_renderer;

        ref_renderer = new RefRenderer();
        cuda_renderer = new CudaRenderer();

        ref_renderer->allocOutputImage(imageSize, imageSize);
        ref_renderer->loadScene(sceneName);
        ref_renderer->setup();
        cuda_renderer->allocOutputImage(imageSize, imageSize);
        cuda_renderer->loadScene(sceneName);
        cuda_renderer->setup();

        // Check the correctness
        CheckBenchmark(ref_renderer, cuda_renderer, 0, 1, frameFilename);
    }
    else {

        if (useRefRenderer)
            renderer = new RefRenderer();
        else
            renderer = new CudaRenderer();

        renderer->allocOutputImage(imageSize, imageSize);
        renderer->loadScene(sceneName);
        renderer->setup();

        if (!interactiveMode)
            startBenchmark(renderer, benchmarkFrameStart, benchmarkFrameEnd - benchmarkFrameStart, frameFilename);
        else {
            glutInit(&argc, argv);
            startRendererWithDisplay(renderer);
        }
    }

    return 0;
}
