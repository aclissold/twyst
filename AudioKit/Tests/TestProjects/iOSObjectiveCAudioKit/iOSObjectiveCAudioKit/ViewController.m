//
//  ViewController.m
//  iOSObjectiveCAudioKit
//
//  Created by Aurelius Prochazka on 4/18/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _mathTestInstrument = [[MathTestInstrument alloc] init];
    [AKOrchestra addInstrument:_mathTestInstrument];
    [_mathTestInstrument start];
    
    _tableTestInstrument= [[TableTestInstrument alloc] init];
    [AKOrchestra addInstrument:_tableTestInstrument];
}

@end
