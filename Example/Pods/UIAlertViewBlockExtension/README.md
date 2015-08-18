# UIAlertViewBlockExtension
UIAlertView category for block expression

## Installation
### Using cocoapods
<code>
pod 'UIAlertViewBlockExtension'
</code>

## Features
- Block expression can be used for handling UIAlertView's clicks.
- Similar with UIAlertController in iOS 8.0

## Examples
```
UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"title" message:@"message"];

[alertView addButtonWithTitle:@"OK" actionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
  NSLog(@"clicked button index : %lu", buttonIndex);
  NSLog(@"cancel button index : %lu", alertView.cancelButtonIndex);
}];
  
[alertView addCancelButtonWithTitle:@"Cancel" actionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
  NSLog(@"clicked button index : %lu", buttonIndex);
  NSLog(@"cancel button index : %lu", alertView.cancelButtonIndex);
}];
    
[alertView show];
```

## Requirements
- iOS version 4.0 or later
