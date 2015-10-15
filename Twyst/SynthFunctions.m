//
//  SynthFunctions.m
//  Theory
//
//  Created by Andrew Clissold on 4/26/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

#import "SynthFunctions.h"

#import <AudioToolbox/AudioToolbox.h>

#define TWO_PI 2.0*M_PI

static const int channel = 0;

static const Float32 kMaxAmplitude = 0.7;
static const Float32 kMinAmplitude = 0.0;

static const Float32 kSineAttackDelta  = 0.002;
static const Float32 kSineReleaseDelta = 0.002;

static const Float32 kSineTinkAttackDelta  = 0.004;
static const Float32 kSineTinkReleaseDelta = 0.00002;

static const Float32 kTrumpetAttackDelta  = 0.002;
static const Float32 kTrumpetDecayDelta   = 0.0005;
static const Float32 kTrumpetReleaseDelta = 0.00003;

double amplitude;

OSStatus SynthesizeSine(
                        void *inRefCon,
                        AudioUnitRenderActionFlags *ioActionFlags,
                        const AudioTimeStamp *inTimeStamp,
                        UInt32 inBusNumber,
                        UInt32 inNumberFrames,
                        AudioBufferList *ioData) {

    Synth *synth = (Synth *)inRefCon;
    double theta = synth->theta;
    double thetaIncrement = TWO_PI * synth->frequency / synth->sampleRate;

    Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;

    for (UInt32 frame = 0; frame < inNumberFrames; frame++) {
        buffer[frame] = amplitude * sin(theta);

        theta += thetaIncrement;
        if (theta > TWO_PI) {
            theta -= TWO_PI;
        }

        switch (synth->state) {
            case StateAttack:
                amplitude += kSineAttackDelta;
                if (amplitude > kMaxAmplitude) {
                    amplitude = kMaxAmplitude;
                    synth->state = StateDecay;
                }
                break;
            case StateDecay:
                synth->state = StateSustain;
                break;
            case StateSustain:
                break;
            case StateRelease:
                amplitude -= kSineReleaseDelta;
                if (amplitude < kMinAmplitude) {
                    amplitude = kMinAmplitude;
                    synth->state = StateIdle;
                }
                break;
            case StateIdle:
                break;
            default:
                printf("Unknown state: %ld\n", (long)synth->state);
                break;
        }
    }

    synth->theta = theta;

    return noErr;
}

OSStatus SynthesizeSineTink(
                            void                       *inRefCon,
                            AudioUnitRenderActionFlags *ioActionFlags,
                            const AudioTimeStamp       *inTimeStamp,
                            UInt32                     inBusNumber,
                            UInt32                     inNumberFrames,
                            AudioBufferList            *ioData) {

    Synth *synth = (Synth *)inRefCon;
    double theta = synth->theta;
    double thetaIncrement = TWO_PI * synth->frequency / synth->sampleRate;

    Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;

    for (UInt32 frame = 0; frame < inNumberFrames; frame++) {
        buffer[frame] = amplitude * sin(theta);

        theta += thetaIncrement;
        if (theta > TWO_PI) {
            theta -= TWO_PI;
        }

        switch (synth->state) {
            case StateAttack:
                amplitude += kSineTinkAttackDelta;
                if (amplitude > kMaxAmplitude) {
                    amplitude = kMaxAmplitude;
                    synth->state = StateDecay;
                }
                break;
            case StateDecay:
                synth->state = StateSustain;
                break;
            case StateSustain:
                synth->state = StateRelease;
                break;
            case StateRelease:
                amplitude -= kSineTinkReleaseDelta;
                if (amplitude < kMinAmplitude) {
                    amplitude = kMinAmplitude;
                    synth->state = StateIdle;
                }
                break;
            case StateIdle:
                break;
            default:
                printf("Unknown state: %ld\n", (long)synth->state);
                break;
        }
    }

    synth->theta = theta;

    return noErr;
}

OSStatus SynthesizeTrumpet(
                           void                       *inRefCon,
                           AudioUnitRenderActionFlags *ioActionFlags,
                           const AudioTimeStamp       *inTimeStamp,
                           UInt32                     inBusNumber,
                           UInt32                     inNumberFrames,
                           AudioBufferList            *ioData) {

    Synth *synth = (Synth *)inRefCon;
    double theta = synth->theta;
    double thetaIncrement = TWO_PI * synth->frequency / synth->sampleRate;

    Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;

    for (UInt32 frame = 0; frame < inNumberFrames; frame++) {
        buffer[frame] = 0.305 * amplitude * sin(2*theta) +
                        0.15  * amplitude * sin(3*theta) +
                        0.05  * amplitude * sin(4*theta) +
                        0.025 * amplitude * sin(5*theta);

        theta += thetaIncrement;
        if (theta > TWO_PI) {
            theta -= TWO_PI;
        }

        switch (synth->state) {
            case StateAttack:
                amplitude += kTrumpetAttackDelta;
                if (amplitude > kMaxAmplitude) {
                    synth->state = StateDecay;
                }
                break;
            case StateDecay:
                amplitude -= kTrumpetDecayDelta;
                if (amplitude < kMaxAmplitude) {
                    amplitude = kMaxAmplitude;
                    synth->state = StateSustain;
                }
                break;
            case StateSustain:
                break;
            case StateRelease:
                amplitude -= kTrumpetReleaseDelta;
                if (amplitude < kMinAmplitude) {
                    amplitude = kMinAmplitude;
                    synth->state = StateIdle;
                }
                break;
            case StateIdle:
                break;
            default:
                printf("Unknown state: %ld\n", (long)synth->state);
                break;
        }
    }

    synth->theta = theta;

    return noErr;
}
