//
//  ViewController.h
//  ARTEmailTest
//
//  Created by Rowan Townshend on 8/14/14.
//  Copyright (c) 2014 Artie Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTSlideViewController : UIViewController

@property (nonatomic, strong) UIViewController *centerPanel;
@property (nonatomic, strong) UIViewController *bottomPanel;

- (void)showBottomPanel:(BOOL)animated bounce:(BOOL)shouldBounce;

@end

