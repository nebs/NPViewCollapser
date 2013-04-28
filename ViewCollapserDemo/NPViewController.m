//
//  NPViewController.m
//  VisualExploration
//
//  Created by Nebojsa Petrovic on 4/27/13.
//  Copyright (c) 2013 Nebojsa Petrovic. All rights reserved.
//

#import "NPViewController.h"
#import "NPProgressTimer.h"
#import "NPViewCollapser.h"
#import <QuartzCore/QuartzCore.h>

@interface NPViewController ()
@property (nonatomic) NPProgressTimer *progressTimer;
@property (nonatomic) NPViewCollapser *viewCollapser;
@end

@implementation NPViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.viewCollapser = [NPViewCollapser collapserWithView:self.testView];

    if (!self.progressTimer) {
        self.progressTimer = [NPProgressTimer timerWithDuration:0.3f
                                                       stepSize:0.01f
                                               progressCallback:^(BOOL finished, double progress) {
                                                   self.slipSlider.value = progress;
                                                   [self.viewCollapser collapseByAmount:progress];
                                               }];
    }
}

#pragma mark - Actions
- (IBAction)sliderValueChanged:(id)sender {
    [self.viewCollapser collapseByAmount:self.slipSlider.value];
}

- (IBAction)sliderTouchUp:(id)sender {
    [self.progressTimer startAtProgress:self.slipSlider.value descending:YES];
}

- (IBAction)openButtonPressed:(id)sender {
    [self.progressTimer startAtProgress:self.slipSlider.value descending:YES];
}

- (IBAction)closeButtonPressed:(id)sender {
    [self.progressTimer startAtProgress:self.slipSlider.value];
}

@end
