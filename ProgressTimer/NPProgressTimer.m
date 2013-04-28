//
//  NPProgressTimer.m
//  VisualExploration
//
//  Created by Nebojsa Petrovic on 4/27/13.
//  Copyright (c) 2013 Nebojsa Petrovic. All rights reserved.
//

#import "NPProgressTimer.h"

@interface NPProgressTimer ()
@property (nonatomic) NSTimer *timer;
@property (nonatomic) double currentProgress;
@property (nonatomic) double stepSize;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) BOOL descending;
@property (copy, nonatomic) NPProgressBlock progressBlock;
@end

@implementation NPProgressTimer

+ (NPProgressTimer *)timerWithDuration:(NSTimeInterval)duration
                              stepSize:(double)stepSize
                      progressCallback:(NPProgressBlock)progressBlock {
    NPProgressTimer *progressTimer = [[NPProgressTimer alloc] init];
    progressTimer.duration = duration;
    progressTimer.stepSize = stepSize;
    progressTimer.progressBlock = progressBlock;
    return progressTimer;
}

- (void)setCurrentProgress:(double)currentProgress {
    _currentProgress = currentProgress;

    _currentProgress = _currentProgress > 1.0f ? 1.0f : _currentProgress;
}

- (void)setStepSize:(double)stepSize {
    _stepSize = stepSize;

    _stepSize = _stepSize > 1.0f ? 1.0f : _stepSize;
    _stepSize = _stepSize <= 0.0f ? 0.1f : _stepSize;
}

- (void)start {
    [self startAtProgress:0.0f];
}

- (void)startAtProgress:(double)startProgress {
    [self startAtProgress:startProgress descending:NO];
}

- (void)startAtProgress:(double)startProgress descending:(BOOL)descending {
    self.descending = descending;

    if (self.timer || self.currentProgress != 0.0f) {
        [self stop];
    }

    if (self.duration <= 0.0f) {
        return;
    }

    self.currentProgress = self.descending ? 1.0f - startProgress : startProgress;

    NSInteger totalSteps = 1.0f / self.stepSize;
    NSTimeInterval stepDuration = self.duration / totalSteps;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:stepDuration
                                                  target:self
                                                selector:@selector(timerTick)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stop {
    [self.timer invalidate];
    self.timer = nil;
}

- (BOOL)finished {
    return (self.currentProgress >= 1.0f);
}

- (void)timerTick {
    self.currentProgress += self.stepSize;

    if ([self finished]) {
        [self stop];
    }

    if (self.progressBlock) {
        double directionalProgress = self.descending ? 1.0f - self.currentProgress : self.currentProgress;
        self.progressBlock([self finished], directionalProgress);
    }
}

- (void)dealloc {
    [self.timer invalidate];
}

@end
