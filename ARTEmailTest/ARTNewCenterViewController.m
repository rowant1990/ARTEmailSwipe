//
//  ARTNewSecondViewController.m
//  ARTEmailTest
//
//  Created by Rowan Townshend on 19/08/2014.
//  Copyright (c) 2014 Artie Entertainment. All rights reserved.
//

#import "ARTNewCenterViewController.h"
#import "ARTEmailSwipe.h"

@interface ARTNewCenterViewController ()

- (IBAction)emailClicked:(UIButton *)sender;

@end

@implementation ARTNewCenterViewController

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
  [self.slideViewController openBottomPanel];
}

@end
