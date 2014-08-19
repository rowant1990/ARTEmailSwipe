
/*  Copyright (c) 2014 Rowan Townshend. All rights reserved.

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


#import "UIViewController+ARTEmailSwipe.h"
#import "ARTEmailSwipe.h"

@implementation UIViewController (ARTEmailSwipe)

- (ARTEmailSwipe *)slideViewController;
{
  UIViewController *iter = self.parentViewController;
  while (iter) {
    if ([iter isKindOfClass:[ARTEmailSwipe class]]) {
      return (ARTEmailSwipe *)iter;
    } else if (iter.parentViewController && iter.parentViewController != iter) {
      iter = iter.parentViewController;
    } else {
      iter = nil;
    }
  }
  return nil;
}

@end