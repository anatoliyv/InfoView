# InfoView

View to show small text information blocks with arrow pointed to another view.In most cases it will be a button that was pressed.

![infoview](https://cloud.githubusercontent.com/assets/1595032/15214074/9bcf9a1a-1853-11e6-826f-ee56bc19017e.gif)

[![CI Status](http://img.shields.io/travis/Anatoliy Voropay/InfoView.svg?style=flat)](https://travis-ci.org/Anatoliy Voropay/InfoView)
[![Version](https://img.shields.io/cocoapods/v/InfoView.svg?style=flat)](http://cocoapods.org/pods/InfoView)
[![License](https://img.shields.io/cocoapods/l/InfoView.svg?style=flat)](http://cocoapods.org/pods/InfoView)
[![Platform](https://img.shields.io/cocoapods/p/InfoView.svg?style=flat)](http://cocoapods.org/pods/InfoView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

InfoView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "InfoView"
```
## Simple appearance

 ```
 let infoView = InfoView(text: "Your message here")
 infoView.show(onView: view, centerView: button)
 ```
 
 where `view` is view of your visible view controller, `centerView` is a view where arrow will be pointed to
 
## Delegation
 
 You can set a delegate and get events when view will appear/hide:
 
 ```
 infoView.delegate = self
 
 // In your delegate class
 func infoViewDidShow(view: InfoView) {
     print("Now visible")
 }
 ```
 
## Customization
 
 Set arrow position. In this case you will be responsible for possible errors (for example if there are not enough space to show text etc.)
 ```
 infoView.arrowPosition = .Left
 ```
 
 Set animation:
 ```
 infoView.animation = InfoViewAnimation.None                // Without animation
 infoView.animation = InfoViewAnimation.FadeIn              // FadeIn animation
 infoView.animation = InfoViewAnimation.FadeInAndScale      // FadeIn and Scale animation
 ```
 
 Set custom font:
 ```
 infoView.font = UIFont(name: "AvenirNextCondensed-Regular", size: 16)
 ```
 
 Set custom text color:
 ```
 infoView.textColor = UIColor.grayColor()
 ```
 
 Set custom background color:
 ```
 infoView.backgroundColor = UIColor.blackColor()
 ```

 Set custom layer properties:
 ```
 infoView.layer.shadowColor = UIColor.whiteColor().CGColor
 infoView.layer.cornerRadius = 15
 infoView.layer.shadowRadius = 5
 infoView.layer.shadowOffset = CGPoint(x: 2, y: 2)
 infoView.layer.shadowOpacity = 0.5
 ```
 
## Hide with a delay
 
 Hide InfoView after delay automatically

 ```
 infoView.hideAfterDelay = 2
 ```

## ToDo

- More animations
- Support long text messages
- Support NSAttributedString's for formatted text

## Author

Anatoliy Voropay, anatoliy.voropay@gmail.com

## License

InfoView is available under the MIT license. See the LICENSE file for more info.
