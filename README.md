# AnimationRouter
AnimationRouter поможет вам быстро и красиво реализовать кастомные переходы между контроллерами. Интерактивный прототип можно посмотреть [здесь](https://appetize.io/embed/4w292ufed47tfgeuq9ge9p7ce8?device=iphone5s&scale=75&orientation=portrait&osVersion=9.3).
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
vc.transitioningDelegate = selectedRouter
present(vc, animated: true)
 ```
 **Внимание!** У вас должна быть сильная ссылка на роутер.
# Настройка
AnimationRouter позволяет настроить свойства анимации перехода:
* **duration:** продолжительность анимации
* **option:** `UIViewAnimationOptions`
* **delay:** задержка перед началом анимации
* **percentage:** максимальное значение для завершения интерактивной анимации

Параметры анимации можно изменить через свойство `options`. 
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
