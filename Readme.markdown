ARTEmailSwipe
===

ARTEmailSwipe is a UIViewController container, which allows you to have one view controller at the bottom, whilst keeping your main navigation separate. This is based on the iOS 8 emails implementation where you can have your new email open at the bottom whilst still viewing all your old emails above it. I also took a lot of inspiration from the JASidePanels project.

Demo
---
![alt tag](https://github.com/rowant1990/ARTEmailSwipe/blob/development/Resources/artswipeviewscreencast.gif)

Example 1: Code
---

```  objc

#import "ARTEmailSwipe.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	self.viewController = [[ARTEmailSwipe alloc] init];
  
  // you will want to use your own custom classes here, but for the example I have just instantiated it with the UIViewController class.
	self.viewController.centerViewController = [[UIViewController alloc] init];
	self.viewController.bottomViewController = [[UIViewController alloc] init];
  
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end

```

Example 2: Storyboards
---

1. Create a subclass of `ARTEmailSwipe`. In this example we call it `ARTRootViewController`.
2. In the Storyboard designate the root view's owner as `ARTRootViewController`.
3. Make sure to `#import "ARTEmailSwipe.h"` in `ARTRootViewController.h`.
4. Add more view controllers to your Storyboard, and give them identifiers "centerViewController" and "bottomViewController".
5. Add a method `awakeFromNib` to `ARTRootViewController.m` with the following code:

```  objc

-(void) awakeFromNib
{
  [self setCenterViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"centerViewController"]];
  [self setBottomViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"bottomViewController"]];
}

```

Usage
---

If you are not using cocoapods yet then here is a link http://cocoapods.org.
To install using cocoapods just add the below to your Podfile,

    pod 'ARTEmailSwipe'
  
If you are not using cocoapods check out that link again :).
Or just add ARTEmailSwipe class and UIViewController+ARTEmailSwipe category to your project.


To open and close the bottom view call one of the three methods below.

```  objc
// call open bottom view when you want to show the bottom view controller. By default it will open fully if you only want it to open partially on launch then pass through the enum type ARTOpenTypePartly.
- (void)openBottomView;
- (void)openBottomView:(ARTOpenType)openType;

// close bottom panel
- (void)closeBottomView;
```

To get a reference to the email swipe view controller, in this case the ARTRootViewController, you can use the UIViewController+ARTEmailSwipe category, which will return your ARTEmailSwipe class. From there you will be able to call the methods above. This category was taken from JASidePanels. 

You can also configure many of the settings used in the ARTEmailSwipe its all documented in ARTEmailSwipe.h.


Requirements
---

ARTEmailSwipe requires iOS 6.0+ and Xcode 5.1.1+ The projects uses ARC, but it may be used with non-ARC projects by setting the: ` -fobjc-arc ` compiler flag on ` ARTEmailSwipe.m `. You can set this flag under Target -> Build Phases -> Compile Sources

Futher Work
---

In the future it will allow you to open multiple email views like in iOS8 Emails, and you will be able to slide through each view like with the tabs in safari, to choose which one you want.

License
---

```

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
 
 ```

Insipiration
---
A big shout has to go to the JASidePanels project, which is what I based this project on.

* JASidePanels - [https://github.com/gotosleep/JASidePanels](https://github.com/gotosleep/JASidePanels)
