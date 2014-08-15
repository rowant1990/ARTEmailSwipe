//
//  UIViewController+ARTSlideView.h
//  ARTEmailTest
//
//  Created by Rowan Townshend on 15/08/2014.
//  Copyright (c) 2014 Artie Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTSlideViewController;

@interface UIViewController (ARTSlideView)

@property (nonatomic, weak, readonly) ARTSlideViewController *slideViewController;

@end
