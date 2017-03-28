DTImageScrollView
===========

[![Badge w/ Version](http://cocoapod-badges.herokuapp.com/v/DTImageScrollView/badge.png)](http://cocoadocs.org/docsets/DTImageScrollView)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Platform](https://img.shields.io/cocoapods/p/DTImageScrollView.svg?style=flat)](http://cocoadocs.org/docsets/DTImageScrollView)

An easy way to display multiple network images in a standard paging-scrollview style.

![](screenshot1.png)
![](screenshot2.png)
                    
## Features
* Display images from specified URLs
* Custom Placeholder image - while the image is loading
* Show paging indicator while images are swiped
* Automatically adjust images to fit the scrollview

## System Requirements
iOS 8.0+, Swift 3.0

## Installation

### CocoaPods

Add into your Podfile.

```:Podfile
pod "DTImageScrollView"
```

Then `$ pod install`

## How to use

Drag a new view to your storyboard or interface builder. Change its class to DTImageScrollView.
In `viewDidLoad()`, set the `datasource` and `placeholderImage`.

```swift
self.imageScrollView.datasource = self
self.imageScrollView.placeholderImage = UIImage(named: "placeholder")
```

Implement 2 datasource functions

```swift
func numberOfImages() -> Int {
    return 3
}

func imageURL(index: Int) -> URL {
    return NSURL(string: "http://www.boxzeed.com/wp-content/uploads/2015/09/1.1.3.jpg")!
}
```

Call `show()` to reload & display images

```swift
self.imageScrollView.show()
```

See more detail in the demo project

## Customizations

You can directly access and modify the scrollview propeties - `scrollView` `pageControl` `placeholderImage`
For example,
```swift
self.photosScrollView.pageControl.currentPageIndicatorTintColor = Utility.MAIN_RED_COLOR
self.photosScrollView.pageControl.pageIndicatorTintColor = UIColor.whiteColor()
```

## Author

**Daron Tancharoen**

- CONTACTS:
  - [Email](daront@gmail.com)

## License
DTImageScrollView is licensed under the MIT License, please see the [LICENSE](LICENSE) file.

