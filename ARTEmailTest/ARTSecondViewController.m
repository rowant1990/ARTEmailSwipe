//
//  ARTSecondViewController.m
//  ARTEmailTest
//
//  Created by Rowan Townshend on 19/08/2014.
//  Copyright (c) 2014 Artie Entertainment. All rights reserved.
//

#import "ARTSecondViewController.h"
#import "ARTEmailSwipe.h"

@interface ARTSecondViewController ()

- (IBAction)changeCenterView:(id)sender;

@end

@implementation ARTSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)changeCenterView:(id)sender;
{
  UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ARTSecondCenterViewControllerIdentifier"];
  [self.emailSwipeViewController setCenterViewController:vc];
}

@end
