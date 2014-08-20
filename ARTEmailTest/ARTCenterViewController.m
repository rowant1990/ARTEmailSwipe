//
//  ARTCenterViewController.m
//  ARTEmailTest
//
//  Created by Rowan Townshend on 8/14/14.
//  Copyright (c) 2014 Artie Entertainment. All rights reserved.
//

#import "ARTCenterViewController.h"
#import "UIViewController+ARTEmailSwipe.h"
#import "ARTEmailSwipe.h"

@interface ARTCenterViewController ()

- (IBAction)emailClicked:(id)sender;

@end

@implementation ARTCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)emailClicked:(UIButton *)sender;
{
  [self.emailSwipeViewController openBottomView];
}

@end
