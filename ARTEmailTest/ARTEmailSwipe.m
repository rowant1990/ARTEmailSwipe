
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

static CGFloat const ARTDefaultBottomPanelDistanceFromTop = 40.f;
static CGFloat const ARTDefaultBottomPanelClosedHeight = 55.f;
static CGFloat const ARTDefaultBounceOffset = 5.f;
static CGFloat const ARTDefaultBounceDuration = 0.2f;
static CGFloat const ARTDefaultBottomCenterPanelOffset = 5.f;

@interface ARTEmailSwipe ()

@property (nonatomic, strong) UIView *centerPanelContainer;
@property (nonatomic, strong) UIView *bottomPanelContainer;
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
  self.bottomPanelDistanceFromTop = ARTDefaultBottomPanelDistanceFromTop;
  self.bounceOffset = ARTDefaultBounceOffset;
  self.bounceAnimationDuration = ARTDefaultBounceDuration;
  self.bottomCenterPanelOffset = ARTDefaultBottomCenterPanelOffset;
}

- (void)viewDidLoad;
{
  self.dragOffset =  self.view.bounds.size.height - (self.view.bounds.size.height / 4);
  self.transformOffset =  self.view.bounds.size.height - (self.view.bounds.size.height / 2);
  
  self.centerPanelContainer = [[UIView alloc] initWithFrame:self.view.bounds];
  self.centerPanelContainer.frame =  self.view.bounds;
  
  self.bottomPanelContainer = [[UIView alloc] initWithFrame:self.view.bounds];
  self.bottomPanelContainer.frame =  self.view.bounds;
  
  [self.view addSubview:self.bottomPanelContainer];
  [self.view addSubview:self.centerPanelContainer];
  
  [self addCenterPanel];
}

//- (void)setCenterPanel:(UIViewController *)centerPanel;
//{
//  if (centerPanel != _centerPanel) {
//    [_centerPanel willMoveToParentViewController:nil];
//    [_centerPanel.view removeFromSuperview];
//    [_centerPanel removeFromParentViewController];
//    _centerPanel = centerPanel;
//    if (_centerPanel) {
//      //[self addChildViewController:_centerPanel];
//      //[_centerPanel didMoveToParentViewController:self];
//    }
//  }
//}

- (void)addCenterPanel;
{
  _centerPanel.view.frame = self.centerPanelContainer.bounds;
  [self addChildViewController:_centerPanel];
  [self.centerPanelContainer addSubview:_centerPanel.view];
  [_centerPanel didMoveToParentViewController:self];
  
}

- (void)setBottomPanel:(UIViewController *)bottomPanel;
{
  if (bottomPanel != _bottomPanel) {
    [_bottomPanel willMoveToParentViewController:nil];
    [_bottomPanel.view removeFromSuperview];
    [_bottomPanel removeFromParentViewController];
    _bottomPanel = bottomPanel;
    if (_bottomPanel) {
      [self addChildViewController:_bottomPanel];
      [_bottomPanel didMoveToParentViewController:self];
    }
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
}

- (void)loadBottomPanel:(ARTOpenType)openType;
{
  if (self.bottomPanel) {
    
    if (!_bottomPanel.view.superview) {
      
      CGRect frame = self.bottomPanelContainer.bounds;
      frame.origin.y = self.view.bounds.size.height - self.bottomPanelClosedHeight;
      frame.size.height = self.bottomPanelClosedHeight;
      self.bottomPanel.view.frame = frame;
      
      UIButton *tap = [UIButton buttonWithType:UIButtonTypeCustom];
      tap.frame = CGRectMake(0, 0, self.view.frame.size.width, self.bottomPanelClosedHeight);
      [tap addTarget:self action:@selector(bottomPanelOpen:) forControlEvents:UIControlEventTouchUpInside];
      tap.backgroundColor = [UIColor redColor];
      [_bottomPanel.view addSubview:tap];
      [_bottomPanel.view sendSubviewToBack:tap];
      tap.autoresizingMask = UIViewAutoresizingFlexibleWidth;
      
      [self.bottomPanelContainer addSubview:_bottomPanel.view];
      
      //  self.bottomPanel.view.translatesAutoresizingMaskIntoConstraints = NO;
      
      //      NSDictionary *views = @{ @"bottomPanel" : self.bottomPanelContainer};
      //
      //      [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[bottomPanel]-|" options:0 metrics:nil views:views]];
    }
    
    self.status = ARTOpenTypePartly;
    [self bottomPanelOpen:openType];
  }
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
  
  [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionLayoutSubviews animations:^{
    CGRect frame = self.view.bounds;
    frame.size.height = open ? self.view.bounds.size.height - (self.bottomPanelClosedHeight + self.bottomCenterPanelOffset) : self.view.bounds.size.height;
    self.centerPanelContainer.frame = frame;
  } completion:^(BOOL finished) {
    if (!open) {
      self.status = ARTOpenTypeClosed;
    }
  }];
}

- (void)bottomPanelOpen:(ARTOpenType)openType;
{
  if (self.status == ARTOpenTypeFully) {
    openType = ARTOpenTypePartly;
  } else {
    openType = ARTOpenTypeFully;
  }
  BOOL open = self.status == ARTOpenTypePartly && openType == ARTOpenTypeFully;
  
  if (open) {
    [self.view bringSubviewToFront:self.bottomPanelContainer];
    [self addPanGestureToView:self.bottomPanel.view];
  } else {
    [self.bottomPanel.view removeGestureRecognizer:self.panGestureRecoginser];
  }
  
  [self.bottomDelegate bottomPanelOpened:openType];
  
  [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionLayoutSubviews animations:^{
    CGRect frame = self.view.bounds;
    
    
    frame.origin.y = open ? self.bottomPanelDistanceFromTop : (self.view.frame.size.height - self.bottomPanelClosedHeight) + self.bounceOffset;
    frame.size.height = open ? frame.size.height - self.bottomPanelDistanceFromTop : self.bottomPanelClosedHeight;
    self.bottomPanel.view.frame = frame;
    self.bottomPanelContainer.center =  CGPointMake(self.bottomPanelContainer.center.x, self.view.bounds.size.height / 2);
    self.centerPanel.view.transform = open ? CGAffineTransformMakeScale(0.9, 0.9) : CGAffineTransformMakeScale(1, 1);
  } completion:^(BOOL finished) {
    self.status = openType;
    if (!open) {
      [self.view bringSubviewToFront:self.centerPanelContainer];
      [UIView animateWithDuration:ARTDefaultBounceDuration animations:^{
        CGRect frame = self.bottomPanel.view.frame;
        frame.origin.y = frame.origin.y - self.bounceOffset;
        self.bottomPanel.view.frame = frame;
      }];
    }
  }];
}

#pragma mark Gestures

- (void)addPanGestureToView:(UIView *)view;
{
  [self.bottomPanel.view removeGestureRecognizer:self.panGestureRecoginser];
  self.panGestureRecoginser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
  self.panGestureRecoginser.maximumNumberOfTouches = 1;
  self.panGestureRecoginser.minimumNumberOfTouches = 1;
  [view addGestureRecognizer:self.panGestureRecoginser];
}

- (void)handlePan:(UIGestureRecognizer *)sender;
{
  if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    CGPoint translate = [pan translationInView:self.bottomPanelContainer];
    self.bottomPanelContainer.center = CGPointMake(self.bottomPanelContainer.center.x, self.bottomPanelContainer.center.y + translate.y);
    [pan setTranslation:CGPointZero inView:self.bottomPanelContainer];
    
    CGFloat origin = self.bottomPanelContainer.frame.origin.y;
    [self.bottomDelegate panGestureOffset:self.bottomPanelContainer.frame.origin state:pan.state];
    
    NSLog(@"Origin %f Trasnform %f Drag Offset %f", origin, self.transformOffset, self.dragOffset);
    
    if (origin < self.transformOffset) {
      CGFloat scale = ((origin / self.transformOffset) / 10) + 0.9;
      
      self.centerPanel.view.transform = CGAffineTransformMakeScale(scale, scale);
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

- (void)willAnimateRotationToInterfaceOrientation:(__unused UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
{
  // self.bottomPanelContainer.frame = [self adjustCenterFrame];
  [self adjustCenterFrame];
  [self adjustBottomFrame];
  //self.view.frame = [self adjustCenterFrame];
  self.dragOffset =  self.view.frame.size.height - (self.view.frame.size.height / (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ? 3 : 4));
  self.transformOffset =  self.view.frame.size.height - (self.view.frame.size.height / 2);
}

#pragma mark - Panel Sizing

- (void)adjustCenterFrame;
{
  CGRect frame = self.view.bounds;
  if (self.status == ARTOpenTypeClosed) {
    frame.origin.y = 0;
  } else {
    frame.size.height = self.view.bounds.size.height - (self.bottomPanelClosedHeight + self.bottomCenterPanelOffset);
    frame.origin.y = 0;
  }
  self.centerPanelContainer.frame = frame;
}

- (void)adjustBottomFrame;
{
  CGRect frame = self.view.bounds;
 
  if (self.status == ARTOpenTypeClosed) {
    frame.origin.y = frame.size.height - self.bottomPanelClosedHeight;
    frame.size.height = self.bottomPanelClosedHeight;
    self.bottomPanel.view.frame = frame;
  } else if (self.status == ARTOpenTypeFully) {
    frame.origin.y = self.bottomPanelDistanceFromTop;
    frame.size.height = frame.size.height - self.bottomPanelDistanceFromTop;
  } else {
    frame.origin.y = (frame.size.height - self.bottomPanelClosedHeight) + self.bounceOffset;
    frame.size.height =  self.bottomPanelClosedHeight;
  }
  
  self.bottomPanelContainer.frame = frame;
}

@end
