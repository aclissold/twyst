//
//  SynthNode.h
//  Theory
//
//  Created by Andrew Clissold on 4/24/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(int, SynthType) {
    SynthTypeSineTink,
    SynthTypeTrumpet
};

@interface SynthNode : SKNode

@property (readonly, getter = isPlaying) BOOL playing;
@property (nonatomic) CGFloat frequency;

- (void)startPlaying;
- (void)stopPlaying;
- (void)destroy;

- (nonnull instancetype)initWithSynthType:(SynthType)synthType;

@end
