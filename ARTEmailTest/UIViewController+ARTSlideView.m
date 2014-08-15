//
//  UIViewController+ARTSlideView.m
//  ARTEmailTest
//
//  Created by Rowan Townshend on 15/08/2014.
//  Copyright (c) 2014 Artie Entertainment. All rights reserved.
//

#import "UIViewController+ARTSlideView.h"
#import "ARTSlideViewController.h"

@implementation UIViewController (ARTSlideView)

- (ARTSlideViewController *)slideViewController;
{
  UIViewController *iter = self.parentViewController;
  while (iter) {
    if ([iter isKindOfClass:[ARTSlideViewController class]]) {
      return (ARTSlideViewController *)iter;
    } else if (iter.parentViewController && iter.parentViewController != iter) {
      iter = iter.parentViewController;
    } else {
      iter = nil;
    }
  }
  return nil;
}

@end
