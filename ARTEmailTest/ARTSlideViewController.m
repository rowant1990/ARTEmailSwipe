//
//  ViewController.m
//  ARTEmailTest
//
//  Created by Rowan Townshend on 8/14/14.
//  Copyright (c) 2014 Artie Entertainment. All rights reserved.
//

#import "ARTSlideViewController.h"

@interface ARTSlideViewController ()

@property (nonatomic, strong) UIView *centerPanelContainer;
@property (nonatomic, strong) UIView *bottomPanelContainer;

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
      frame.origin.y = 300;
      frame.size.height = 50;
      self.bottomPanel.view.frame = frame;
      
      _bottomPanel.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      [self.bottomPanelContainer addSubview:_bottomPanel.view];
    }
  }
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
  frame.size.height = 300;
  _restingFrame = frame;
  return _restingFrame;
}

#pragma mark Animation

- (void)_animateCenterPanel:(BOOL)shouldBounce completion:(void (^)(BOOL finished))completion;
{
  [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionLayoutSubviews animations:^{
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



@end
