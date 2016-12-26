# AnimationRouter
AnimationRouter поможет вам быстро и красиво реализовать кастомные переходы между контроллерами. Интерактивный прототип можно посмотреть [тут](https://appetize.io/embed/4w292ufed47tfgeuq9ge9p7ce8?device=iphone5s&scale=75&orientation=portrait&osVersion=9.3).
# Использование
Для того, чтобы использовать AnimationRouter, необходимо создать роутер с одним из существующих типов перехода, например:

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
vc.transitioningDelegate = topRouter
self.present(vc, animated: true, completion: nil)
 ```
# Интерактивные переходы
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
            .present { router in
                let vc = SecondViewController()
                vc.transitioningDelegate = router
                self.present(vc, animated: true, completion: nil)
            }
            .update { recognizer -> CGFloat in
                let translation = recognizer.translation(in: recognizer.view!)
                return translation.x / recognizer.view!.bounds.width * 0.5
        }
view.addGestureRecognizer(leftRecognizer)
  ```
