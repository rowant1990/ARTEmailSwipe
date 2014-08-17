//
//  ARTSecondViewController.m
//  ARTEmailTest
//
//  Created by Rowan Townshend on 8/14/14.
//  Copyright (c) 2014 Artie Entertainment. All rights reserved.
//

#import "ARTBottomViewController.h"

#import "ARTSlideViewController.h"
#import "UIViewController+ARTSlideView.h"

@interface ARTBottomViewController () <ARTSlideViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

- (IBAction)cancelPrssed:(id)sender;

@end

@implementation ARTBottomViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.slideViewController.delegate = self;
}

- (IBAction)cancelPrssed:(id)sender;
{
  [self.slideViewController closeBottomPanel];
}

#pragma mark ARTSlideViewDelegate

- (void)bottomPanelOpened:(ARTOpenType)type;
{
  [UIView animateWithDuration:0.5f animations:^{
    self.cancelButton.alpha = type == ARTOpenTypeFully;
  } completion:^(BOOL finished) {
    
  }];
}

@end
