//
//  ViewController.m
//  ARTEmailTest
//
//  Created by Rowan Townshend on 8/14/14.
//  Copyright (c) 2014 Artie Entertainment. All rights reserved.
//

#import "ARTSlideViewController.h"


static CGFloat const ARTTopOffset = 40.f;
static CGFloat const ARTBottomOffset = 55.f;

@interface ARTSlideViewController ()

@property (nonatomic, strong) UIView *centerPanelContainer;
@property (nonatomic, strong) UIView *bottomPanelContainer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecoginser;

@property (nonatomic, assign) CGRect restingFrame;

@end

@implementation ARTSlideViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
  }
  return self;
}

- (id)init {
  if (self = [super init]) {
  }
  return self;
}

- (void)viewDidLoad;
{
  self.centerPanelContainer = [[UIView alloc] initWithFrame:self.view.bounds];
  self.centerPanelContainer.frame =  self.view.bounds;
  
  self.bottomPanelContainer = [[UIView alloc] initWithFrame:self.view.bounds];
  self.bottomPanelContainer.frame =  self.view.bounds;
  
  [self.view addSubview:self.bottomPanelContainer];
  [self.view addSubview:self.centerPanelContainer];
  
  [self _swapCenter:nil with:_centerPanel];
}

- (void)setCenterPanel:(UIViewController *)centerPanel;
{
  UIViewController *previous = _centerPanel;
  
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

- (void)loadBottomPanel {
  if (self.bottomPanel) {
    
    if (!_bottomPanel.view.superview) {
      
      CGRect frame = self.bottomPanelContainer.bounds;
      frame.origin.y = self.view.bounds.size.height - 55;
      frame.size.height = 55;
      self.bottomPanel.view.frame = frame;
      
      _bottomPanel.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      [self.bottomPanelContainer addSubview:_bottomPanel.view];
    }
  }
}

- (void)_swapCenter:(UIViewController *)previous with:(UIViewController *)next {
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

#pragma mark - Panel Sizing

- (CGRect)_adjustCenterFrame;
{
  CGRect frame = self.view.bounds;
  frame.size.height = self.view.bounds.size.height - ARTBottomOffset;
  _restingFrame = frame;
  return _restingFrame;
}


#pragma mark Animation

- (void)_animateCenterPanel:(BOOL)shouldBounce completion:(void (^)(BOOL finished))completion;
{
  [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionLayoutSubviews animations:^{
    self.centerPanelContainer.frame = self.restingFrame;
  } completion:^(BOOL finished) {
    
  }];
}


#pragma mark - Showing Panels

- (void)showBottomPanel:(BOOL)animated bounce:(BOOL)shouldBounce {
  
  [self loadBottomPanel];
  [self _adjustCenterFrame];
  [self _animateCenterPanel:shouldBounce completion:nil];
}

- (void)openBottomPanel:(BOOL)open;
{
  if (open) {
    [self.view bringSubviewToFront:self.bottomPanelContainer];
    [self addPanGestureToView:self.bottomPanel.view];
  } else {
    [self.bottomPanel.view removeGestureRecognizer:self.panGestureRecoginser];
  }
  
  [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionLayoutSubviews animations:^{
    CGRect frame = self.view.bounds;
    frame.origin.y = open ? ARTTopOffset : frame.size.height - ARTBottomOffset;
    frame.size.height = open ? frame.size.height - ARTTopOffset : ARTBottomOffset;
    self.bottomPanel.view.frame = frame;
    self.bottomPanelContainer.center =  CGPointMake(self.bottomPanelContainer.center.x, self.view.bounds.size.height / 2);
    NSLog(@"center = %f", self.bottomPanelContainer.center.y);
    self.centerPanel.view.transform = open ? CGAffineTransformMakeScale(0.9, 0.9) : CGAffineTransformMakeScale(1, 1);
  } completion:^(BOOL finished) {
    if (!open) {
      [self.view bringSubviewToFront:self.centerPanelContainer];
    }
  }];
}

#pragma mark Gestures

- (void)addPanGestureToView:(UIView *)view {
  self.panGestureRecoginser = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePan:)];
  self.panGestureRecoginser.delegate = self;
  self.panGestureRecoginser.maximumNumberOfTouches = 1;
  self.panGestureRecoginser.minimumNumberOfTouches = 1;
  [view addGestureRecognizer:self.panGestureRecoginser];
}

- (void)_handlePan:(UIGestureRecognizer *)sender;
{
  if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
    
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    CGPoint translate = [pan translationInView:self.bottomPanelContainer];
    self.bottomPanelContainer.center = CGPointMake(self.bottomPanelContainer.center.x, self.bottomPanelContainer.center.y + translate.y);
    [pan setTranslation:CGPointZero inView:self.bottomPanelContainer];
    
    CGFloat origin = self.bottomPanelContainer.frame.origin.y;
    
    if (origin < 200) {
      CGFloat scale = (origin / 200) + 0.9;
      self.centerPanel.view.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
      
      NSLog(@"origin = %f", self.bottomPanelContainer.frame.origin.y);
      NSLog(@"Center = %f", self.bottomPanelContainer.center.y);
      if (origin > 200) {
        [self openBottomPanel:NO];
      } else {
        [self openBottomPanel:YES];
      }
    }
  }
}

@end
