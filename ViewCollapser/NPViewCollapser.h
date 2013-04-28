//
//  NPViewCollapser.h
//  VisualExploration
//
//  Created by Nebojsa Petrovic on 4/27/13.
//  Copyright (c) 2013 Nebojsa Petrovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NPViewCollapser : NSObject

+ (NPViewCollapser *)collapserWithView:(UIView *)view;

/*
 Returns the view that is being processed.
 If the view is being collapsed, it returns the temporary overlay
 view.
 If the view isn't being collapsed it returns the original view.
 User this if you want to perform additional operations of the view.
 */
- (UIView *)view;

/*
 Collapse the view by amount.
 1: Fully collapsed
 0: Fully expanded (original view)
 */
- (void)collapseByAmount:(double)amount;

@end
