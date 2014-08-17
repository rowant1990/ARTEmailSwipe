
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

#import "ARTSlideViewController.h"

static CGFloat const ARTDefaultBottomPanelDistanceFromTop = 40.f;
static CGFloat const ARTDefaultBottomPanelClosedHeight = 55.f;

@interface ARTSlideViewController ()

@property (nonatomic, strong) UIView *centerPanelContainer;
@property (nonatomic, strong) UIView *bottomPanelContainer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecoginser;

@property (nonatomic, assign) ARTOpenType status;
@property (nonatomic, assign) CGFloat dragOffset;
@property (nonatomic, assign) CGFloat transformOffset;

@end

@implementation ARTSlideViewController

- (id)initWithCoder:(NSCoder *)aDecoder;
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.status = ARTOpenTypeClosed;
    self.bottomPanelClosedHeight = ARTDefaultBottomPanelClosedHeight;
    self.bottomPanelDistanceFromTop = ARTDefaultBottomPanelDistanceFromTop;
  }
  return self;
}

- (id)init;
{
  self = [super init];
  if (self) {
    self.status = ARTOpenTypeClosed;
    self.bottomPanelClosedHeight = ARTDefaultBottomPanelClosedHeight;
    self.bottomPanelDistanceFromTop = ARTDefaultBottomPanelDistanceFromTop;
  }
  return self;
}

- (void)viewDidLoad;
{
  self.dragOffset = self.view.bounds.size.height - (self.view.bounds.size.height / 4);
  self.transformOffset = self.view.bounds.size.height - (self.view.bounds.size.height / 2);
  
  self.centerPanelContainer = [[UIView alloc] initWithFrame:self.view.bounds];
  self.centerPanelContainer.frame =  self.view.bounds;
  
  self.bottomPanelContainer = [[UIView alloc] initWithFrame:self.view.bounds];
  self.bottomPanelContainer.frame =  self.view.bounds;
  
  [self.view addSubview:self.bottomPanelContainer];
  [self.view addSubview:self.centerPanelContainer];
  [self swapCenter:nil with:_centerPanel];
}

- (void)setCenterPanel:(UIViewController *)centerPanel;
{
  if (centerPanel != _centerPanel) {
    [_centerPanel willMoveToParentViewController:nil];
    [_centerPanel.view removeFromSuperview];
    [_centerPanel removeFromParentViewController];
    _centerPanel = centerPanel;
    if (_centerPanel) {
      [self addChildViewController:_centerPanel];
      [_centerPanel didMoveToParentViewController:self];
    }
  }
}

- (void)swapCenter:(UIViewController *)previous with:(UIViewController *)next {
  if (previous != next) {
    [previous willMoveToParentViewController:nil];
    [previous.view removeFromSuperview];
    [previous removeFromParentViewController];
    
    if (next) {
      _centerPanel.view.frame = self.centerPanelContainer.bounds;
      [self addChildViewController:next];
      [self.centerPanelContainer addSubview:next.view];
      [next didMoveToParentViewController:self];
    }
  }
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
  [self animateCenterPanel];
  self.status = openType == ARTOpenTypePartly ? ARTOpenTypePartly : ARTOpenTypeFully;
  
  [self loadBottomPanel:openType];
}

- (void)closeBottomPanel;
{
  [self animateCenterPanel];
}

- (void)loadBottomPanel:(ARTOpenType)openType;
{
  if (self.bottomPanel) {
    
    if (!_bottomPanel.view.superview) {
      
      CGRect frame = self.bottomPanelContainer.bounds;
      frame.origin.y = self.view.bounds.size.height - ARTDefaultBottomPanelClosedHeight;
      frame.size.height = ARTDefaultBottomPanelClosedHeight;
      self.bottomPanel.view.frame = frame;
      
      UIButton *tap = [UIButton buttonWithType:UIButtonTypeCustom];
      tap.frame = CGRectMake(0, 0, self.view.frame.size.width, ARTDefaultBottomPanelClosedHeight);
      [tap addTarget:self action:@selector(bottomPanelOpen:) forControlEvents:UIControlEventTouchUpInside];
      tap.backgroundColor = [UIColor redColor];
      [_bottomPanel.view addSubview:tap];
      [_bottomPanel.view sendSubviewToBack:tap];
      
      _bottomPanel.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      [self.bottomPanelContainer addSubview:_bottomPanel.view];
    }
    
    self.status = ARTOpenTypePartly;
    [self bottomPanelOpen:openType];
  }
}

#pragma mark Animation

- (void)animateCenterPanel;
{
  BOOL open = self.status == ARTOpenTypeClosed;
  if (self.status == ARTOpenTypeFully) {
    [self bottomPanelOpen:ARTOpenTypePartly];
  }
  
  [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionLayoutSubviews animations:^{
    CGRect frame = self.view.bounds;
    frame.size.height = open ? self.view.bounds.size.height - ARTDefaultBottomPanelClosedHeight : self.view.bounds.size.height;
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
  //openType = !openType || openType > ARTOpenTypeClosed ? ARTOpenTypeFully : openType;
  BOOL open = self.status == ARTOpenTypePartly && openType == ARTOpenTypeFully;
  
  if (open) {
    [self.view bringSubviewToFront:self.bottomPanelContainer];
    [self addPanGestureToView:self.bottomPanel.view];
  } else {
    [self.bottomPanel.view removeGestureRecognizer:self.panGestureRecoginser];
  }
  
  [self.delegate bottomPanelOpened:openType];
  
  [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionLayoutSubviews animations:^{
    CGRect frame = self.view.bounds;
    frame.origin.y = open ? self.bottomPanelDistanceFromTop : self.view.frame.size.height - self.bottomPanelClosedHeight;;
    frame.size.height = open ? frame.size.height - self.bottomPanelDistanceFromTop : self.bottomPanelClosedHeight;
    self.bottomPanel.view.frame = frame;
    self.bottomPanelContainer.center =  CGPointMake(self.bottomPanelContainer.center.x, self.view.bounds.size.height / 2);
    self.centerPanel.view.transform = open ? CGAffineTransformMakeScale(0.9, 0.9) : CGAffineTransformMakeScale(1, 1);
  } completion:^(BOOL finished) {
    self.status = open ? ARTOpenTypeFully : ARTOpenTypePartly;
    if (!open) {
      [self.view bringSubviewToFront:self.centerPanelContainer];
    }
  }];
}

#pragma mark Gestures

- (void)addPanGestureToView:(UIView *)view;
{
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
    
    if (origin < self.transformOffset) {
      CGFloat scale = ((origin / self.transformOffset) / 10) + 0.9;
      
      self.centerPanel.view.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
      
      NSLog(@"origin = %f", self.bottomPanelContainer.frame.origin.y);
      NSLog(@"Center = %f", self.bottomPanelContainer.center.y);
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

@end
