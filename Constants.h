//
//  ConstantsAndMacros.h
//  Particles
//

static int animate = 1;

#define TIMESCALE 1
#define ZOOMSCALE 1



// For setting up perspective, define near, far, and angle of view
#define kZNear                          0.01
#define kZFar                        1000.00
#define kFieldOfView                   45.00

// Defines whether to setup and use a depth buffer
#define USE_DEPTH_BUFFER                   0

// Set to 1 if you want it to attempt to create a 2.0 context
#define kAttemptToUseOpenGLES2             0

// Macros
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)