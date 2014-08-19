//
//  ARTSecondViewController.m
//  ARTEmailTest
//
//  Created by Rowan Townshend on 8/14/14.
//  Copyright (c) 2014 Artie Entertainment. All rights reserved.
//

#import "ARTBottomViewController.h"

#import "ARTEmailSwipe.h"
#import "UIViewController+ARTEmailSwipe.h"

@interface ARTBottomViewController () <ARTSlideViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

- (IBAction)cancelPrssed:(id)sender;

@end

@implementation ARTBottomViewController

- (void)viewDidLoad;
{
  [super viewDidLoad];
  self.slideViewController.bottomDelegate = self;
}

- (IBAction)cancelPrssed:(id)sender;
{
  [self.slideViewController closeBottomView];
}

#pragma mark ARTSlideViewDelegate

- (void)bottomViewOpened:(ARTOpenType)type;
{
  [UIView animateWithDuration:0.5f animations:^{
    self.cancelButton.alpha = type == ARTOpenTypeFully;
  } completion:nil];
}

#pragma mark Bottom Gesture Delegate

- (void)panGestureOffset:(CGPoint)offset state:(UIGestureRecognizerState)state;
{
  // Add code to react to pan gesture
}

@end
