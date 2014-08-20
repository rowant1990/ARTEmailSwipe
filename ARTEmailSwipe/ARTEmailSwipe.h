
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

#import "UIViewController+ARTEmailSwipe.h"

typedef NS_ENUM(NSInteger, ARTOpenType) {
  ARTOpenTypeClosed,
  ARTOpenTypeFully,
  ARTOpenTypePartly
};

@protocol ARTSlideViewDelegate <NSObject>

- (void)bottomViewOpened:(ARTOpenType)type;
- (void)panGestureOffset:(CGPoint)offset state:(UIGestureRecognizerState)state;

@end

@interface ARTEmailSwipe : UIViewController

@property (nonatomic, strong) UIViewController *centerViewController;
@property (nonatomic, strong) UIViewController *bottomViewController;

// Optional - assign a delegate if you need to notify either panels when the bottom panel is open or closed.
@property (nonatomic, weak) id<ARTSlideViewDelegate>bottomDelegate;

// Optional - is the height of the bottom panel when closed.
@property (nonatomic, assign) CGFloat bottomViewClosedHeight;

// Optional - is the distance from the bottom view, when its open, to the top.
@property (nonatomic, assign) CGFloat bottomViewDistanceFromTop;

// Optional - the distance the bottom view bounces when it partially closes.
@property (nonatomic, assign) CGFloat bounceOffset;

// Optional - the duration of the bounce animation.
@property (nonatomic, assign) CGFloat bounceAnimationDuration;

// Optional - the gap between the center view and the bottom view when its partailly closed.
@property (nonatomic, assign) CGFloat bottomCenterViewOffset;

// Optional - disable status bar color change
@property (nonatomic, assign) BOOL disableStatusBarAnimation;

// call open bottom view when you want to show the bottom view controller. By default it will open fully if you only want it to open partially on launch then pass through the enum type ARTOpenTypePartly.
- (void)openBottomView;
- (void)openBottomView:(ARTOpenType)openType;

// close bottom panel
- (void)closeBottomView;

@end

