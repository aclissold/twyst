//
//  SynthNode.m
//  Theory
//
//  Created by Andrew Clissold on 4/24/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

#import "SynthNode.h"

#import <AVFoundation/AVFoundation.h>

#import "SynthFunctions.h"

@interface SynthNode () {
    AudioComponentInstance toneUnit;
}

@property (readwrite, getter = isPlaying) BOOL playing;

@end

static const double kSampleRate = 44100.0;
static const double A440        = 440.0;

int synthType = SynthTypeSine;

Synth synth = {
    .theta      = 0,
    .frequency  = A440,
    .sampleRate = 44100.0,
    .state      = StateIdle
};

@implementation SynthNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.name = @"synthNode";
        [self createToneUnit];
        [self prepareAudioPlayback];
    }
    return self;
}

+ (instancetype)sharedSynthNode {
    static SynthNode *synthNode = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        synthNode = [[self alloc] init];
    });
    return synthNode;
}

- (void)setSynthType:(SynthType)aSynthType {
    synthType = aSynthType;
    [self updateCallback];
}

- (void)setFrequency:(CGFloat)frequency {
    synth.frequency = frequency;
}

- (void)createToneUnit {
    OSStatus status;

    // Configure the search parameters to get the default output component...
    AudioComponentDescription desc;
    desc.componentType = kAudioUnitType_Output;
    desc.componentSubType = kAudioUnitSubType_RemoteIO;
    desc.componentManufacturer = kAudioUnitManufacturer_Apple;
    desc.componentFlags = 0;
    desc.componentFlagsMask = 0;
    // ...and use them to retrieve it
    AudioComponent outputComponent = AudioComponentFindNext(NULL, &desc);
    NSAssert(outputComponent, @"Can't find default output");

    // Create a new audio unit with the output component
    status = AudioComponentInstanceNew(outputComponent, &toneUnit);
    NSAssert1(toneUnit, @"Error creating tone unit: %d", (int)status);

    // Set the stream format to 32-bit, native-endian, floating-point LPCM
    const int fourBytesPerFloat = 4;
    const int eightBitsPerByte = 8;
    AudioStreamBasicDescription format = {
        .mSampleRate = kSampleRate,
        .mFormatID = kAudioFormatLinearPCM,
        .mFormatFlags = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved,
        .mBytesPerPacket = fourBytesPerFloat,
        .mFramesPerPacket = 1,
        .mBytesPerFrame = fourBytesPerFloat,
        .mChannelsPerFrame = 1,
        .mBitsPerChannel = eightBitsPerByte * fourBytesPerFloat,
        .mReserved = 0
    };
    status = AudioUnitSetProperty(toneUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Input,
                                  0, &format, sizeof(AudioStreamBasicDescription));
    NSAssert1(status == noErr, @"Error setting stream format: %d", (int)status);

    [self updateCallback];
}

/// Updates the synth struct's callback to reflect the current synth type.
- (void)updateCallback {
    // Set the audio renderer function
    AURenderCallbackStruct rendererCallback;
    switch (synthType) {
        case SynthTypeSine:
            rendererCallback.inputProc = SynthesizeSine;
            break;
        case SynthTypeSineTink:
            rendererCallback.inputProc = SynthesizeSineTink;
            break;
        case SynthTypeTrumpet:
            rendererCallback.inputProc = SynthesizeTrumpet;
            break;
        default:
            printf("Error, unknown SynthType: %d", synthType);
            break;
    }
    rendererCallback.inputProcRefCon = &synth;
    OSStatus status = AudioUnitSetProperty(toneUnit,
                                  kAudioUnitProperty_SetRenderCallback,
                                  kAudioUnitScope_Input,
                                  0, &rendererCallback, sizeof(AURenderCallbackStruct));
    NSAssert1(status == noErr, @"Error setting callback: %d", (int)status);
    
}

- (void)destroyToneUnit {
    AudioOutputUnitStop(toneUnit);
    AudioUnitUninitialize(toneUnit);
    AudioComponentInstanceDispose(toneUnit);
    toneUnit = nil;
}

- (void)prepareAudioPlayback {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setPreferredSampleRate:kSampleRate error:nil];
    [session setCategory:AVAudioSessionCategoryAmbient error:nil];
    [session setActive:YES error:nil];

    OSStatus status;

    status = AudioUnitInitialize(toneUnit);
    NSAssert1(status == noErr, @"Error starting unit: %d", (int)status);

    // Start playback
    status = AudioOutputUnitStart(toneUnit);
    NSAssert1(status == noErr, @"Error starting unit: %d", (int)status);
}

- (void)startPlaying {
    self.playing = YES;
    synth.state = StateAttack;
}

- (void)stopPlaying {
    synth.state = StateRelease;
    self.playing = NO;
}

- (void)destroy {
    [self stopPlaying];
    [self destroyToneUnit];
    [self removeFromParent];
}

@end
