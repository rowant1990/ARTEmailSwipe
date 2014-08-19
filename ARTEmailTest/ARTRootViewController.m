//
//  ARTRootViewController.m
//  ARTEmailTest
//
//  Created by Rowan Townshend on 8/14/14.
//  Copyright (c) 2014 Artie Entertainment. All rights reserved.
//

#import "ARTRootViewController.h"
#import "ARTCenterViewController.h"

@implementation ARTRootViewController

- (void)awakeFromNib;
{
  [self setCenterViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ARTCenterViewControllerIdentifier"]];
  [self setBottomViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ARTBottomViewControllerIdentifier"]];
}

@end
