
/*  Created by Rowan Townshend on 8/14/14.
 Copyright (c) 2014 Rowan Townshend. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 If you happen to meet one of the copyright holders in a bar you are obligated
 to buy them one pint of beer.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWAR
 */

#import "ARTEmailSwipe.h"

#define ISIOS6    ([[[UIDevice currentDevice] systemVersion] floatValue] < 7 && [[[UIDevice currentDevice] systemVersion] floatValue] >= 6)

static CGFloat const ARTDefaultBottomPanelDistanceFromTop = 40.f;
static CGFloat const ARTDefaultBottomPanelClosedHeight = 46.f;
static CGFloat const ARTDefaultBounceOffset = 5.f;
static CGFloat const ARTDefaultBounceDuration = 0.2f;
static CGFloat const ARTDefaultBottomCenterPanelOffset = 5.f;
static CGFloat const ARTStatusBar = 20.f;

@interface ARTEmailSwipe ()

@property (nonatomic, strong) UIView *centerViewContainer;
@property (nonatomic, strong) UIView *bottomViewContainer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecoginser;

@property (nonatomic, assign) ARTOpenType status;
@property (nonatomic, assign) CGFloat dragOffset;
@property (nonatomic, assign) CGFloat transformOffset;

@end

@implementation ARTEmailSwipe

- (id)initWithCoder:(NSCoder *)aDecoder;
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self configure];
  }
  return self;
}

- (id)init;
{
  self = [super init];
  if (self) {
    [self configure];
  }
  return self;
}

- (void)configure;
{
  self.status = ARTOpenTypeClosed;
  self.bottomPanelClosedHeight = ARTDefaultBottomPanelClosedHeight;
  self.bottomPanelDistanceFromTop = ARTDefaultBottomPanelDistanceFromTop - (ISIOS6 ? 20 : 0);
  self.bounceOffset = ARTDefaultBounceOffset;
  self.bounceAnimationDuration = ARTDefaultBounceDuration;
  self.bottomCenterPanelOffset = ARTDefaultBottomCenterPanelOffset;
}

- (void)viewDidLoad;
{
  self.dragOffset =  self.view.bounds.size.height - (self.view.bounds.size.height / 4);
  self.transformOffset =  self.view.bounds.size.height - (self.view.bounds.size.height / 2);
  
  self.centerViewContainer = [[UIView alloc] initWithFrame:self.view.bounds];
  self.centerViewContainer.frame =  self.view.bounds;
  
  self.bottomViewContainer = [[UIView alloc] initWithFrame:self.view.bounds];
  self.bottomViewContainer.frame =  self.view.bounds;
  self.bottomViewContainer.clipsToBounds = YES;
  //self.bottomViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  
  [self.view addSubview:self.bottomViewContainer];
  [self.view addSubview:self.centerViewContainer];
  
  [self addCenterPanel];
}

- (void)setCenterViewController:(UIViewController *)centerPanel;
{
  if (centerPanel != _centerViewController) {
    [_centerViewController willMoveToParentViewController:nil];
    [_centerViewController.view removeFromSuperview];
    [_centerViewController removeFromParentViewController];
    _centerViewController = centerPanel;
    if (_centerViewController) {
      [self addChildViewController:_centerViewController];
      [_centerViewController didMoveToParentViewController:self];
    }
  }
  [self addCenterPanel];
}

- (void)addCenterPanel;
{
  _centerViewController.view.frame = self.centerViewContainer.bounds;
  [self addChildViewController:_centerViewController];
  [self.centerViewContainer addSubview:_centerViewController.view];
  [_centerViewController didMoveToParentViewController:self];
  
}

- (void)setBottomViewController:(UIViewController *)bottomPanel;
{
  if (bottomPanel != _bottomViewController) {
    [_bottomViewController willMoveToParentViewController:nil];
    [_bottomViewController.view removeFromSuperview];
    [_bottomViewController removeFromParentViewController];
    _bottomViewController = bottomPanel;
    if (_bottomViewController) {
      [self addChildViewController:_bottomViewController];
      [_bottomViewController didMoveToParentViewController:self];
    }
  }
}

- (void)loadBottomPanel:(ARTOpenType)openType;
{
  if (self.bottomViewController) {
    
    if (!_bottomViewController.view.superview) {
      
      CGRect frame = self.bottomViewContainer.bounds;
      frame.origin.y = (self.view.bounds.size.height - self.bottomPanelClosedHeight) - (ISIOS6 ? ARTStatusBar : 0);
      frame.size.height = self.bottomPanelClosedHeight;
      self.bottomViewContainer.frame = frame;
      
      UIButton *tap = [UIButton buttonWithType:UIButtonTypeCustom];
      tap.frame = CGRectMake(0, 0, self.view.frame.size.width, self.bottomPanelClosedHeight);
      [tap addTarget:self action:@selector(bottomPanelOpen:) forControlEvents:UIControlEventTouchUpInside];
      tap.backgroundColor = [UIColor clearColor];
      [self.bottomViewController.view addSubview:tap];
      [self.bottomViewController.view sendSubviewToBack:tap];
      
      NSDictionary *constraintView = @{ @"tap" : tap};
      tap.translatesAutoresizingMaskIntoConstraints = NO;
      [self.bottomViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tap]-0-|" options:0 metrics:nil views:constraintView]];
      [self.bottomViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[tap(height)]" options:0 metrics:@{@"height": @(self.bottomPanelClosedHeight)} views:constraintView]];
      
      [self.bottomViewContainer addSubview:_bottomViewController.view];
    }
    
    self.status = ARTOpenTypePartly;
    [self bottomPanelOpen:openType];
  }
}

- (void)openBottomPanel;
{
  [self openBottomPanel:ARTOpenTypeFully];
}

- (void)openBottomPanel:(ARTOpenType)openType;
{
  [self animateCenterPanel:NO];
  self.status = openType;
  
  [self loadBottomPanel:openType];
}

- (void)closeBottomPanel;
{
  [self animateCenterPanel:YES];
  self.status = ARTOpenTypeClosed;
}

#pragma mark Animation

- (void)animateCenterPanel:(BOOL)close;
{
  if (close) {
    if (self.status == ARTOpenTypeFully) {
      [self bottomPanelOpen:ARTOpenTypeClosed];
    }
    [self animateCenterPanel];
  } else  {
    if (self.status == ARTOpenTypeClosed) {
      [self animateCenterPanel];
    }
  }
}

- (void)animateCenterPanel;
{
  BOOL open = self.status == ARTOpenTypeClosed;
  
  [UIView animateWithDuration:0.5f animations:^{
    CGRect frame = self.view.bounds;
    frame.size.height = open ? self.view.bounds.size.height - (self.bottomPanelClosedHeight + self.bottomCenterPanelOffset) : self.view.bounds.size.height;
    self.centerViewContainer.frame = frame;
  } completion:^(BOOL finished) {
    if (!open) {
      self.status = ARTOpenTypeClosed;
    }
  }];
}

- (void)bottomPanelOpen:(ARTOpenType)openType;
{
  
  if (openType != ARTOpenTypeClosed) {
    if (self.status == ARTOpenTypeFully) {
      openType = ARTOpenTypePartly;
    } else if (self.status == ARTOpenTypePartly) {
      openType = ARTOpenTypeFully;
    }
  }
  
  BOOL open = self.status == ARTOpenTypePartly && openType == ARTOpenTypeFully;
  
  if (open) {
    [self.view bringSubviewToFront:self.bottomViewContainer];
    [self addPanGestureToView:self.bottomViewController.view];
  } else {
    [self.bottomViewController.view removeGestureRecognizer:self.panGestureRecoginser];
  }
  
  [self.bottomDelegate bottomPanelOpened:openType];
  
  [UIView animateWithDuration:0.5f animations:^{
    CGRect frame = self.view.bounds;
    
    frame.origin.y = open ? self.bottomPanelDistanceFromTop : ((frame.size.height - self.bottomPanelClosedHeight) + self.bounceOffset) - (ISIOS6 ? ARTStatusBar : 0);
    frame.size.height = open ? frame.size.height - self.bottomPanelDistanceFromTop : self.bottomPanelClosedHeight + (ISIOS6 ? 20 : 0);
    self.bottomViewContainer.frame = frame;
    self.centerViewContainer.transform = open ? CGAffineTransformMakeScale(0.9, 0.9) : CGAffineTransformMakeScale(1, 1);
  } completion:^(BOOL finished) {
    self.status = openType;
    if (!open) {
      [self.view bringSubviewToFront:self.centerViewContainer];
      [UIView animateWithDuration:ARTDefaultBounceDuration animations:^{
        CGRect frame = self.bottomViewContainer.frame;
        frame.origin.y = frame.origin.y - self.bounceOffset;
        self.bottomViewContainer.frame = frame;
      }];
    }
  }];
}

#pragma mark Gestures

- (void)addPanGestureToView:(UIView *)view;
{
  [self.bottomViewController.view removeGestureRecognizer:self.panGestureRecoginser];
  self.panGestureRecoginser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
  self.panGestureRecoginser.maximumNumberOfTouches = 1;
  self.panGestureRecoginser.minimumNumberOfTouches = 1;
  [view addGestureRecognizer:self.panGestureRecoginser];
}

- (void)handlePan:(UIGestureRecognizer *)sender;
{
  if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    CGPoint translate = [pan translationInView:self.bottomViewContainer];
    self.bottomViewContainer.center = CGPointMake(self.bottomViewContainer.center.x, self.bottomViewContainer.center.y + translate.y);
    [pan setTranslation:CGPointZero inView:self.bottomViewContainer];
    
    CGFloat origin = self.bottomViewContainer.frame.origin.y;
    [self.bottomDelegate panGestureOffset:self.bottomViewContainer.frame.origin state:pan.state];
    
    if (origin < self.transformOffset) {
      CGFloat scale = ((origin / self.transformOffset) / 10) + 0.9;
      
      self.centerViewContainer.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
      
      if (origin > self.dragOffset) {
        self.status = ARTOpenTypeFully;
        [self bottomPanelOpen:ARTOpenTypePartly];
      } else {
        self.status = ARTOpenTypePartly;
        [self bottomPanelOpen:ARTOpenTypeFully];
      }
    }
  }
}


#pragma mark - Re-Sizing

- (void)willAnimateRotationToInterfaceOrientation:(__unused UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
{
  [self adjustCenterFrame];
  [self adjustBottomFrame];

  self.dragOffset =  self.view.frame.size.height - (self.view.frame.size.height / (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ? 3 : 4));
  self.transformOffset =  self.view.frame.size.height - (self.view.frame.size.height / 2);
}

- (void)adjustCenterFrame;
{
  CGRect frame = self.view.bounds;
  if (self.status == ARTOpenTypeClosed) {
    frame.origin.y = 0;
  } else if (self.status == ARTOpenTypeFully) {
    frame.size.height = self.view.bounds.size.height - (self.bottomPanelClosedHeight + self.bottomCenterPanelOffset);
    self.centerViewContainer.transform = CGAffineTransformIdentity;
    self.centerViewContainer.frame = frame;
    self.centerViewContainer.transform = CGAffineTransformMakeScale(0.9, 0.9);
    return;
  } else {
    frame.size.height = self.view.bounds.size.height - (self.bottomPanelClosedHeight + self.bottomCenterPanelOffset);
  }
  self.centerViewContainer.frame = frame;
}

- (void)adjustBottomFrame;
{
  CGRect frame = self.view.bounds;
  
 if (self.status == ARTOpenTypeFully) {
    frame.origin.y = self.bottomPanelDistanceFromTop;
    frame.size.height = frame.size.height - self.bottomPanelDistanceFromTop;
  } else {
    frame.origin.y = (frame.size.height - self.bottomPanelClosedHeight) - (ISIOS6 ? ARTStatusBar : 0);
    frame.size.height = self.bottomPanelClosedHeight + (ISIOS6 ? ARTStatusBar : 0);
  }
  self.bottomViewContainer.frame = frame;
}

@end
