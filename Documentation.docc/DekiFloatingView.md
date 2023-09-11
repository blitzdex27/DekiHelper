# DekiFloatingView

A view that float and snaps.

## Overview

Create a floating view using DekiFloatingView class or subclass it. Treat it as a normal view, with floating bonus!

## Topics

### Simple use case

```swift
import UIKit
import DekiHelper

class ViewController: UIViewController {

    private lazy var floatingView: DekiFloatingView = {
        let view = DekiFloatingView(
            referenceView: view,
            frame: .init(x: 0, y: 0, width: 100, height: 100)
        )
        view.layer.cornerRadius = 50
        view.center = self.view.center
        view.backgroundColor = .yellow
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(floatingView)

    }

}
```

### Floating view with subview

```swift
class ViewController: UIViewController {

    private lazy var floatingView: DekiFloatingView = {
        let view = DekiFloatingView(
            referenceView: view,
            frame: .init(x: 0, y: 0, width: 100, height: 100)
        )
        view.layer.cornerRadius = 50
        view.center = self.view.center
        view.backgroundColor = .yellow
        return view
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Hi"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 50)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(floatingView)
        floatingView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: floatingView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: floatingView.centerYAnchor).isActive = true
    }
}

```
