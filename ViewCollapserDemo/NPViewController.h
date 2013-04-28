//
//  NPViewController.h
//  VisualExploration
//
//  Created by Nebojsa Petrovic on 4/27/13.
//  Copyright (c) 2013 Nebojsa Petrovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISlider *slipSlider;
@property (weak, nonatomic) IBOutlet UIView *testView;

- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)sliderTouchUp:(id)sender;
- (IBAction)openButtonPressed:(id)sender;
- (IBAction)closeButtonPressed:(id)sender;

@end
