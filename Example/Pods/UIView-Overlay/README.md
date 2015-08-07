UIView-Overlay
===============

Plain and simple UIView category that adds overlay layer with specific color the the sublayers of the UIView.

##Requirements

* Xcode 5 (or higher)
* Apple LLVM compiler
* ARC
* iOS 6.1 (or higher)

##Installation

Recommended way to install AGToggleFieldSetView is via [CocoaPods](http://cocoapods.org/). Add the following line to your Podfile:

```ruby
pod 'UIView-Overlay'
```

##Usage

Just call methods methods to add or remove the overlay

```objc
[view ag_addOverlayWithColor: [[UIColor blackColor] colorWithAlphaComponent: 0.3]];
[view ag_removeOverlay];
```
