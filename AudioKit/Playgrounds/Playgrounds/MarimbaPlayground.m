//
//  VibraphonePlayground.m
//  AudioKit
//
//  Created by Aurelius Prochazka on 3/15/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

#import "Playground.h"
#import "Marimba.h"

@implementation Playground

- (void)run
{
    [super run];

    Marimba *marimba = [[Marimba alloc] initWithNumber:1];
    [AKOrchestra addInstrument:marimba];

    MarimbaNote *note = [[MarimbaNote alloc] init];

    [self addButtonWithTitle:@"Play Once" block:^{ [marimba playNote:note]; }];

    [self addSliderForProperty:marimba.amplitude        title:@"Amplitude"];
    [self addSliderForProperty:marimba.vibratoFrequency title:@"Vibrato Frequency"];
    [self addSliderForProperty:marimba.vibratoAmplitude title:@"Vibrato Amplitude"];

    AKPhrase *phrase = [[AKPhrase alloc] init];
    [phrase addNote:note];

    [self makeSection:@"Repeat Frequency"];
    [self addRepeatSliderForInstrument:marimba
                                phrase:phrase
                      minimumFrequency:0.0f
                      maximumFrequency:25.0f];

    [self addButtonWithTitle:@"Stop Loop" block:^{ [marimba stopPhrase]; }];

    [self makeSection:@"Parameters"];

    [self addSliderForProperty:note.frequency      title:@"Frequency"];
    [self addSliderForProperty:note.stickHardness  title:@"Stick Hardness"];
    [self addSliderForProperty:note.strikePosition title:@"Strike Position"];
    [self addSliderForProperty:note.amplitude      title:@"Amplitude"];

    [self addAudioOutputRollingWaveformPlot];
    [self addAudioOutputPlot];
    [self addAudioOutputFFTPlot];
}

@end
