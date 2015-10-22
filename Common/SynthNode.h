//
//  SynthNode.h
//  Theory
//
//  Created by Andrew Clissold on 4/24/14.
//  Copyright (c) 2014 Andrew Clissold. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(int, SynthType) {
    SynthTypeSine,
    SynthTypeSineTink,
    SynthTypeTrumpet
};

@interface SynthNode : SKNode

@property (readonly, getter = isPlaying) BOOL playing;
@property (nonatomic) CGFloat frequency;
@property (nonatomic) SynthType synthType;

- (void)startPlaying;
- (void)stopPlaying;
- (void)destroy;

/// Singleton accessor. This class is a singleton to ensure that the underlying
/// audio unit stuff is only ever initialized once. Initializing it more than
/// once without destroying it in between causes audio anomalies.
+ (nonnull instancetype)sharedSynthNode;

@end
