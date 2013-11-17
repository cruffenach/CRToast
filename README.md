# CWStatusBarNotification

`CWStatusBarNotification` is a library that allows you to easily create text-based notifications that appear on the status bar.

![demo](screenshots/demo.gif)

## Requirements

`CWStatusBarNotification` uses ARC and requires iOS 7.0+.

Works for iPhone and iPad.

## Installation

### CocoaPods

`pod 'CWStatusBarNotification', '~> 2.0.0'`

### Manual

Copy the folder `CWStatusBarNotification` to your project.

## Usage

***Note:** The previous version of this library implemented the notifications using a category. This version uses an object instead.*

Firstly, you need the following import statement:

```
#import "CWStatusBarNotification.h"
```

Now, you need to create a `CWStatusBarNotification` object. It is recommended that you do so by attaching it as a property to a `UIViewController`.

```
CWStatusBarNotification *notification = [CWStatusBarNotification new];
```
After you have a `CWStatusBarNotification` object, you can simply call the `displayNotificationMessage:forDuration:` method:

```
[self.notification displayNotificationWithMessage:@"Hello, World!"
                   forDuration:1.0f];
```

If you prefer to manually choose when to display and dismiss the notification, you can do so as well:

```
[self.notification displayNotificationWithMessage:@"Hello" completion:nil];
// wait until you need to dismiss
[self.notofication dismissNotification];
```

## Customizing Appearance

First of all, you can customize the background color and text color using the following properties: `notificationLabelBackgroundColor` and `notificationLabelTextColor`.

Example:

```
notification.notificationLabelBackgroundColor = [UIColor blackColor];
notification.notificationLabelTextColor = [UIColor greenColor];
```

![custom colors](screenshots/ss1.gif)

The default value of `notificationLabelBackgroundColor` is `[[UIApplication sharedApplication] delegate].window.tintColor`.

The default value of `notification.notificationLabelTextColor` is `[UIColor whiteColor]`.

Finally, you can also choose from two styles - a notification the size of the status bar, or a notification the size of the status bar and a navigation bar. Simply change the `notificationStyle` property of the `CWStatusBarNotification` object to either `CWNotificationStyleStatusBarNotification` or `CWNotificationStyleNavigationBarNotification`.

![custom style](screenshots/ss2.gif)

The default value of `notificationStyle` is `CWNotificationStyleStatusBarNotification`.

## Customizing Animation

There are two properties that determine the animation style of the notification: `notificationAnimationInStyle` and `notificationAnimationOutStyle`. Each can take on one of four values:

* `CWNotificationAnimationStyleTop`
* `CWNotificationAnimationStyleBottom`
* `CWNotificationAnimationStyleLeft`
* `CWNotificationAnimationStyleRight`

The `notificationAnimationInStyle` describes where the notification comes from, whereas the `notificationAnimationOutStyle` describes where the notification will go.

The default value for `notificationAnimationInStyle` is `CWNotificationAnimationStyleTop`.

The default value for `notificationAnimationOutStyle` is `CWNotificationAnimationStyleTop`.

### Additional Remarks

The notifications will work in both screen orientations, however, screen rotation while a notification is displayed is not yet fully supported.

## License

    The MIT License (MIT)

    Copyright (c) 2013 Cezary Wojcik <http://www.cezarywojcik.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.


