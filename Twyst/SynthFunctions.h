//
//  SynthFunctions.h
//  Theory
//
//  Created by Andrew Clissold on 4/26/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef struct Synth {
    double     theta;
    double     frequency;
    double     sampleRate;
    NSUInteger state;
} Synth;

typedef NS_ENUM(NSInteger, State) {
    StateAttack,
    StateDecay,
    StateSustain,
    StateRelease,
    StateIdle
};

OSStatus SynthesizeSineTink(
                            void                       *inRefCon,
                            AudioUnitRenderActionFlags *ioActionFlags,
                            const AudioTimeStamp       *inTimeStamp,
                            UInt32                     inBusNumber,
                            UInt32                     inNumberFrames,
                            AudioBufferList            *ioData);

OSStatus SynthesizeTrumpet(
                           void                       *inRefCon,
                           AudioUnitRenderActionFlags *ioActionFlags,
                           const AudioTimeStamp       *inTimeStamp,
                           UInt32                     inBusNumber,
                           UInt32                     inNumberFrames,
                           AudioBufferList            *ioData);
