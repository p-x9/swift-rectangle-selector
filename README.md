# RectangleSelector

A UI Component for selecting rectangular areas.

<!-- # Badges -->

[![Github issues](https://img.shields.io/github/issues/p-x9/swift-rectangle-selector)](https://github.com/p-x9/swift-rectangle-selector/issues)
[![Github forks](https://img.shields.io/github/forks/p-x9/swift-rectangle-selector)](https://github.com/p-x9/swift-rectangle-selector/network/members)
[![Github stars](https://img.shields.io/github/stars/p-x9/swift-rectangle-selector)](https://github.com/p-x9/swift-rectangle-selector/stargazers)
[![Github top language](https://img.shields.io/github/languages/top/p-x9/swift-rectangle-selector)](https://github.com/p-x9/swift-rectangle-selector/)

## Demo

https://github.com/user-attachments/assets/bfb1b0ce-74d7-4037-ad4b-1fb78ec693f0

## Usage

The basic usage is as follows.

```swift
let selector = RectangleSelectorView()
selector.delegate = self

// Set initial rectangle area
selector.set(
    selectedFrame: .init(
        origin: .init(x: 50, y: 50),
        size: .init(width: 100, height: 100)
    )
)

// Show selector ui for imageView
// (To select an area of the `imageView` range)
selector.show(for: imageView)

// Close
selector.dismiss()

// Selected rect
let selected: CGRect = selector.selectedRect
```

### Custom UI

Various properties can be customised by using the `Config` model.

```swift
var config: Config = .default

// Custom...
config.guideConfig.lineWidth = 2
config.guideConfig.lineColor = .cyan

// Apply customized config
selector.apply(config)
```

### Aspect Ratio

The aspect ratio can be fixed.

```swift
// Fixed aspect ratio (height / width)
selector.aspectMode = .fixed(0.5)

// Free
selector.aspectMode = .free
```

### Minimum Size

It is possible to specify the minimum size of the selection area.

```swift
selector.minimumSize = .init(width: 100, height: 100)
```

### UIControl Event

Selection area change events can be received via the delegate, but also via the UIControl `valueChanged` event.

```swift
selector.addTarget(
    self,
    action: #selector(valueChanged(_:)),
    for: .valueChanged
)

@objc
func valueChanged(_ sender: RectangleSelectorView) {
    print("value changed", sender.selectedRect)
}
```

## License

RectangleSelector is released under the MIT License. See [LICENSE](./LICENSE)
