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

@interface ARTBottomViewController ()

- (IBAction)betslipButton:(id)sender;

@end

@implementation ARTBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)betslipButton:(UIButton *)sender;
{
  sender.selected = !sender.selected;
  [self.slideViewController openBottomPanel:sender.selected];
}


@end
