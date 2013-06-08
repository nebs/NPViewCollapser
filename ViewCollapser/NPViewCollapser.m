//
//  NPViewCollapser.m
//  VisualExploration
//
//  Created by Nebojsa Petrovic on 4/27/13.
//  Copyright (c) 2013 Nebojsa Petrovic. All rights reserved.
//

#import "NPViewCollapser.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kNPViewCollapserOverlayZPosition = 10000.0f;
static const CGFloat kNPViewCollapserMaxFoldAngle = 87.75;
static const CGFloat kNPViewCollapserM34 = -1.0f / 2000.0f;

@interface NPViewCollapser ()
@property (nonatomic) UIView *viewToCollapse;
@property (nonatomic) UIView *overlayView;
@property (nonatomic) CALayer *leftLayer;
@property (nonatomic) CALayer *rightLayer;
- (void)refreshOverlay;
@end

@implementation NPViewCollapser

+ (NPViewCollapser *)collapserWithView:(UIView *)view {
    NPViewCollapser *collapser = [[NPViewCollapser alloc] init];
    collapser.viewToCollapse = view;
    return collapser;
}

- (UIView *)view {
    if (self.overlayView && !self.overlayView.hidden) {
        return self.overlayView;
    }

    return self.viewToCollapse;
}

- (void)refreshOverlay {
    // Remove the overlay if it exists
    if (self.overlayView) {
        [self.overlayView removeFromSuperview];
        self.overlayView = nil;
    }

    // Shortcuts for readability
    CGFloat w = self.viewToCollapse.frame.size.width;
    CGFloat h = self.viewToCollapse.frame.size.height;

    // Create a new overlay and place it on top of the target view
    self.overlayView = [[UIView alloc] initWithFrame:self.viewToCollapse.bounds];
    [self.overlayView setBackgroundColor:[UIColor clearColor]];
    [self.viewToCollapse.superview addSubview:self.overlayView];

    /**********************************
     Configure the left side
     **********************************/
    self.leftLayer = [[CALayer alloc] init];
    self.leftLayer.frame = CGRectMake(0.0f, 0.0f, w/2.0f, h);
    [self.leftLayer setBackgroundColor:[UIColor blackColor].CGColor];
    self.leftLayer.shouldRasterize = YES;
    self.leftLayer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
    self.leftLayer.actions = @{@"transform": [NSNull null]};
    self.leftLayer.zPosition = kNPViewCollapserOverlayZPosition;
    [self.overlayView.layer addSublayer:self.leftLayer];

    // Prepare the image sublayer
    CALayer *leftLayerImage = [[CALayer alloc] init];
    leftLayerImage.frame = CGRectMake(0.0f, 0.0f, w/2.0f, h);
    [self.leftLayer addSublayer:leftLayerImage];

    // Grab the sub-image
    UIGraphicsBeginImageContext(self.leftLayer.frame.size);
    [self.viewToCollapse.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *leftImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    leftLayerImage.contents = (id)leftImage.CGImage;
    leftLayerImage.actions = @{@"opacity": [NSNull null]};

    /**********************************
     Configure the right side
     **********************************/
    self.rightLayer = [[CALayer alloc] init];
    self.rightLayer.frame = CGRectMake(w/2.0f, 0.0f, w/2.0f, h);
    [self.rightLayer setBackgroundColor:[UIColor blackColor].CGColor];
    self.rightLayer.actions = @{@"transform": [NSNull null]};
    self.rightLayer.shouldRasterize = YES;
    self.rightLayer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
    self.rightLayer.zPosition = kNPViewCollapserOverlayZPosition;
    [self.overlayView.layer addSublayer:self.rightLayer];

    //Prepare the image sublayer
    CALayer *rightLayerImage = [[CALayer alloc] init];
    rightLayerImage.frame = CGRectMake(0.0f, 0.0f, w/2.0f, h);
    [self.rightLayer addSublayer:rightLayerImage];

    // Grab the sub-image
    UIGraphicsBeginImageContext(self.rightLayer.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, -self.rightLayer.frame.size.width, 0.0f);
    [self.viewToCollapse.layer renderInContext:ctx];
    UIImage *rightImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    rightLayerImage.contents = (id)rightImage.CGImage;
    rightLayerImage.actions = @{@"opacity": [NSNull null]};
}

- (void)collapseByAmount:(double)amount {
    if (amount <= 0.0f) {
        self.viewToCollapse.hidden = NO;
        [self.overlayView removeFromSuperview];
        self.overlayView = nil;
        return;
    }

    if (!self.overlayView) {
        [self refreshOverlay];
    }

    self.viewToCollapse.hidden = YES;
    self.overlayView.hidden = NO;

    // Slowly fade out as the view collapse
    CALayer *leftSublayer = [self.leftLayer.sublayers objectAtIndex:0];
    leftSublayer.opacity = (1.1f - amount);
    CALayer *rightSublayer = [self.rightLayer.sublayers objectAtIndex:0];
    rightSublayer.opacity = (1.2f - amount);

    CGFloat translateX = self.viewToCollapse.frame.size.width / 4.0f;
    CGFloat rotationAngle = amount * kNPViewCollapserMaxFoldAngle * M_PI / 180.0f;

    CATransform3D leftFoldTransform = CATransform3DIdentity;
    leftFoldTransform.m34 = kNPViewCollapserM34;
    leftFoldTransform = CATransform3DTranslate(leftFoldTransform, translateX, 0.0f, 0.0f);
    leftFoldTransform = CATransform3DRotate(leftFoldTransform, rotationAngle, 0.0f, 1.0f, 0.0f);
    leftFoldTransform = CATransform3DTranslate(leftFoldTransform, -translateX, 0.0f, 0.0f);
    self.leftLayer.transform = leftFoldTransform;

    CATransform3D rightFoldTransform = CATransform3DIdentity;
    rightFoldTransform.m34 = kNPViewCollapserM34;
    rightFoldTransform = CATransform3DTranslate(rightFoldTransform, -translateX, 0.0f, 0.0f);
    rightFoldTransform = CATransform3DRotate(rightFoldTransform, -rotationAngle, 0.0f, 1.0f, 0.0f);
    rightFoldTransform = CATransform3DTranslate(rightFoldTransform, translateX, 0.0f, 0.0f);
    self.rightLayer.transform = rightFoldTransform;
}

@end
