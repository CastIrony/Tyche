#ifndef TINY_PROFILER
#define TINY_PROFILER 1

#define TINY_PROFILER_SHOULD_RUN 1

#define TINY_PROFILER_LOG_INTERVAL 300
#define TINY_PROFILER_COUNT        32
#define TINY_PROFILER_TIMER        CFAbsoluteTimeGetCurrent()
#define TINY_PROFILER_TIME_TYPE    NSTimeInterval
#define TINY_PROFILER_LOG(...)     printf("%d, %d, %f5\n", __VA_ARGS__)

typedef struct 
{
    TINY_PROFILER_TIME_TYPE startTime;
    TINY_PROFILER_TIME_TYPE totalTime;
    int                     runCount;
} 
TinyProfiler;

TinyProfiler tinyProfilers[TINY_PROFILER_COUNT];

static inline void TinyProfilerStart(int profileIndex)
{
    #ifdef TINY_PROFILER_SHOULD_RUN

    tinyProfilers[profileIndex].startTime = TINY_PROFILER_TIMER; 
    
    #endif
}

static inline void TinyProfilerStop(int profileIndex)
{
    #ifdef TINY_PROFILER_SHOULD_RUN

    tinyProfilers[profileIndex].totalTime = TINY_PROFILER_TIMER - tinyProfilers[profileIndex].startTime;
    tinyProfilers[profileIndex].runCount++;

    #endif
}

static inline void TinyProfilerLog()
{
    #ifdef TINY_PROFILER_SHOULD_RUN

    static int tinyProfilerLogCounter = 0;
    
    if(++tinyProfilerLogCounter != TINY_PROFILER_LOG_INTERVAL) { return; }
    
    for(int profileIndex = 0; profileIndex < TINY_PROFILER_COUNT; profileIndex++)
    {
        if(!tinyProfilers[profileIndex].runCount) { continue; }
        
        TINY_PROFILER_LOG(profileIndex, tinyProfilers[profileIndex].runCount, tinyProfilers[profileIndex].totalTime);
        
        tinyProfilers[profileIndex].startTime = 0;
        tinyProfilers[profileIndex].totalTime = 0;
        tinyProfilers[profileIndex].runCount  = 0;
    }

    tinyProfilerLogCounter = 0;
    
    #endif
}

#endif