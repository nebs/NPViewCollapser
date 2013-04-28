//
//  NPProgressTimer.h
//  VisualExploration
//
//  Created by Nebojsa Petrovic on 4/27/13.
//  Copyright (c) 2013 Nebojsa Petrovic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NPProgressBlock)(BOOL finished, double progress);

@interface NPProgressTimer : NSObject

/*
 Creates and returns a new progress timer.
 progressBlock will be called as often as is needed to satisfy the stepSize
 and total duration.
 The block is passed a progress value between 0.0 and 1.0.
 When the progress is complete, it will call progressBlock with 
 finished = YES and then stop itself.
 */
+ (NPProgressTimer *)timerWithDuration:(NSTimeInterval)duration
                              stepSize:(double)stepSize
                      progressCallback:(NPProgressBlock)progressBlock;

- (void)start;
- (void)startAtProgress:(double)startProgress;
- (void)startAtProgress:(double)startProgress descending:(BOOL)descending;
- (void)stop;
- (BOOL)finished;

@end
