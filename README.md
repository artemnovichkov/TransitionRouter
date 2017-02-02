# TransitionRouter

![Swift 3.0+](https://img.shields.io/badge/Swift-3.0%2B-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/TransitionRouter.svg?style=flat)](http://cocoapods.org/pods/TransitionRouter)
[![License](https://img.shields.io/cocoapods/l/TransitionRouter.svg?style=flat)](https://github.com/lkzhao/TransitionRouter/blob/master/LICENSE?raw=true)

`TransitionRouter` поможет вам быстро и красиво реализовать кастомные переходы между контроллерами. Интерактивный прототип можно посмотреть [здесь](https://appetize.io/embed/4w292ufed47tfgeuq9ge9p7ce8?device=iphone5s&scale=75&orientation=portrait&osVersion=9.3).
## Using
Для того, чтобы использовать `TransitionRouter`, необходимо создать роутер с одним из существующих типов перехода, например:

```swift
let topRouter = TransitionRouter(type: .top)
```

Вы также можете использовать свой тип перехода. Для этого достаточно поддержать протокол `TransitionAnimator` и создать роутер с вашим аниматором:

```swift
let fadeRouter = TransitionRouter(type: .custom(animator: FadeTransitionAnimator()))
```

Когда вам будет необходимо сделать переход, достаточно передать созданный роутер в качестве `transitioningDelegate` контроллеру, который нужно показать:

```swift
let vc = SecondViewController()
vc.transitioningDelegate = selectedRouter
present(vc, animated: true)
```
**Внимание!** У вас должна быть сильная ссылка на роутер.
## Configuration
AnimationRouter позволяет настроить свойства анимации перехода:
* **duration:** продолжительность анимации
* **option:** `UIViewAnimationOptions`
* **delay:** задержка перед началом анимации
* **percentage:** максимальное значение для завершения интерактивной анимации

Параметры анимации можно изменить через свойство `options`. 
## Interactive transitions
Для реализации возможности интерактивного перехода необходимо создать роутер с параметром interactive:
```swift
let leftInteractiveRouter = TransitionRouter(type: .left, interactive: true)
```
или выставить напрямую через свойство у уже созданного роутера:
```swift
leftInteractiveRouter.interactive = true
```

Для того, чтобы управлять прогрессом перехода, необходимо создать `UIPanGestureRecognizer` или его сабкласс и настроить роутер:
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
Если вы хотите самостоятельно управлять прогрессом перехода, необходимо настроить роутер следующим образом:
```swift
leftInteractiveRouter.update { recognizer -> CGFloat in
    let translation = recognizer.translation(in: recognizer.view!)
    return translation.x / recognizer.view!.bounds.width * 0.5
}
```
Обратите внимание, что для кастомного аниматора вы обязательно должны указать логику прогресса.

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

Create a `Package.swift` in root directory.

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

