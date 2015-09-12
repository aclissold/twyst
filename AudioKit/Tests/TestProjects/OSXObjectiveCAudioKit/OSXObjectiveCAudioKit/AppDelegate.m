//
//  AppDelegate.m
//  OSXObjectiveCAudioKit
//
//  Created by Aurelius Prochazka on 4/19/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _mathTestInstrument = [[MathTestInstrument alloc] init];
    [AKOrchestra addInstrument:_mathTestInstrument];
    [_mathTestInstrument start];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
