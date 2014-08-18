
/*
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
 SOFTWARE.
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ARTOpenType) {
  ARTOpenTypeClosed,
  ARTOpenTypeFully,
  ARTOpenTypePartly
};

@protocol ARTSlideViewDelegate <NSObject>

- (void)bottomPanelOpened:(ARTOpenType)type;
- (void)panGestureOffset:(CGPoint)offset state:(UIGestureRecognizerState)state;

@end

@interface ARTEmailSwipe : UIViewController

@property (nonatomic, strong) UIViewController *centerPanel;
@property (nonatomic, strong) UIViewController *bottomPanel;

// Optional - assign a delegate if you need to notify either panels when the bottom panel is open or closed.
@property (nonatomic, weak) id<ARTSlideViewDelegate>bottomDelegate;

// Optional - is the height of the bottom panel when closed.
@property (nonatomic, assign) CGFloat bottomPanelClosedHeight;

// Optional - is the distance from the bottom panel, when its open, to the top.
@property (nonatomic, assign) CGFloat bottomPanelDistanceFromTop;

// Optional - the distance the bottom view bounces when it partially closes.
@property (nonatomic, assign) CGFloat bounceOffset;

// Optional - the duration of the bounce animation.
@property (nonatomic, assign) CGFloat bounceAnimationDuration;

// Optional - the gap between the center panel and the bottom panel when its partailly closed.
@property (nonatomic, assign) CGFloat bottomCenterPanelOffset;

// show bottom panel if you only want the panel to open partially on luanch the pass through the enum type ARTOpenTypePartly.
- (void)openBottomPanel;
- (void)openBottomPanel:(ARTOpenType)openType;

// close bottom panel
- (void)closeBottomPanel;

@end

