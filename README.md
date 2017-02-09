# TransitionRouter

![Swift 3.0+](https://img.shields.io/badge/Swift-3.0%2B-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/TransitionRouter.svg?style=flat)](http://cocoapods.org/pods/TransitionRouter)
[![License](https://img.shields.io/cocoapods/l/TransitionRouter.svg?style=flat)](https://github.com/lkzhao/TransitionRouter/blob/master/LICENSE?raw=true)

`TransitionRouter` helps you to create custom transitions between controllers fast and easy. Interactive prototype is available [here](https://appetize.io/embed/4w292ufed47tfgeuq9ge9p7ce8?device=iphone5s&scale=75&orientation=portrait&osVersion=9.3).
## Using
How to use `TransitionRouter`? Simple as ABC! You need to create a router with one of transition type like:

```swift
let topRouter = TransitionRouter(type: .top)
```

Also you can create your own custom transition. Just create an object that conforms `TransitionAnimator` protocol and create a router with your object:

```swift
let fadeRouter = TransitionRouter(type: .custom(animator: FadeTransitionAnimator()))
```

When you need to start any custom transition, set the router as `transitioningDelegate` of the controller you want to present:

```swift
let vc = SecondViewController()
vc.transitioningDelegate = selectedRouter
present(vc, animated: true)
```

**Don't forget about strong reference for the router!**
## Configuration
Of course, you can customize options of default transitions:
* **duration:** animation duration
* **option:** `UIViewAnimationOptions`
* **delay:** delay before animation
* **percentage:** max percentage to finish interactive transition.

Animation options can be changed via `options` property.
## Interactive transitions
To create interactive transition you need to create router with `interactive` parameter:
```swift
let leftInteractiveRouter = TransitionRouter(type: .left, interactive: true)
```
or set directly via property:
```swift
leftInteractiveRouter.interactive = true
```

Сertainly, you can control progress of transition. Create `UIPanGestureRecognizer` or its subclass and set the router:
```swift
let leftRecognizer = UIScreenEdgePanGestureRecognizer()
leftRecognizer.edges = .left
leftInteractiveRouter
.add(leftRecognizer)
.transition { [unowned self] router in
    let vc = ColorViewController(color: .green)
    vc.transitioningDelegate = router
    self.present(vc, animated: true)
}
view.addGestureRecognizer(leftRecognizer)
```
You can update progress of transition manually:
```swift
leftInteractiveRouter.update { recognizer -> CGFloat in
    let translation = recognizer.translation(in: recognizer.view!)
    return translation.x / recognizer.view!.bounds.width * 0.5
}
```
Pay attention - for your custom animator you must set updating logic manually.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

###Carthage###

`github "artemnovichkov/TransitionRouter"`

###CocoaPods###

`pod "TransitionRouter"`

###Swift Package Manager###

#####Step 1#####

`File > New > Project`

#####Step 2#####

Create a `Package.swift` in a root directory.

```swift
import PackageDescription

let package = Package(
    name: "NameOfYourPackage",
    dependencies: [
        .Package(url: "https://github.com/artemnovichkov/TransitionRouter", majorVersion: 0, minor: 1)
    ]
)
```
Run `swift package fetch`

#####Step 3#####

Open the Xcode Project File. File > New > Target > **Cocoa Touch Framework** If you don't need Obj-C support remove the .h files in the navigator.

#####Step 4#####

Go in Finder and drag & drop the sources from `Packages/TransitionRouter/Sources` into your project and add it to the TransitionRouter target.

#####Step 5#####

Link your Project to the TransitionRouter dependency. Select your main target and add the CocoaTouchFramework to the Linked Frameworks and Libraries in the General Tab.

###Manual###

Drag the Sources folder into your project. [Download](https://github.com/artemnovichkov/TransitionRouter/releases)

## Author

Artem Novichkov, novichkoff93@gmail.com

## License

TransitionRouter is available under the MIT license. See the LICENSE file for more info.

