import UIKit

public protocol RectangleSelectorViewDelegate: AnyObject {
    func rectangleSelector(_ selector: RectangleSelectorView, willStartChanging rect: CGRect)
    func rectangleSelector(_ selector: RectangleSelectorView, didEndChanging rect: CGRect)
    func rectangleSelector(_ selector: RectangleSelectorView, didUpdate rect: CGRect)
}

extension RectangleSelectorViewDelegate {
    public func rectangleSelector(_ selector: RectangleSelectorView, willStartChanging rect: CGRect) {}
    public func rectangleSelector(_ selector: RectangleSelectorView, didEndChanging rect: CGRect) {}
    public func rectangleSelector(_ selector: RectangleSelectorView, didUpdate rect: CGRect) {}
}

public final class RectangleSelectorView: UIView {

    public private(set) var config: Config = .default
    public var aspectMode: AspectMode = .free {
        didSet {
            switch aspectMode {
            case .free:
                edgeHandles.forEach { $0.isHidden = false }
            case .fixed:
                edgeHandles.forEach { $0.isHidden = true }
            }
            updateMinimumSizeConstraints()
        }
    }
    public var minimumSize: CGSize? {
        didSet {
            updateMinimumSizeConstraints()
        }
    }

    public var selectedRect: CGRect {
        guideView.frame
    }

    public weak var delegate: RectangleSelectorViewDelegate?

    private let topLeftHandle = HandleView()
    private let topRightHandle = HandleView()
    private let bottomLeftHandle = HandleView()
    private let bottomRightHandle = HandleView()

    private let centerHandle = HandleView()

    private let topEdgeHandle = HandleView()
    private let bottomEdgeHandle = HandleView()
    private let leftEdgeHandle = HandleView()
    private let rightEdgeHandle = HandleView()

    private let gridView = GridView()

    private let guideView = GuideView()

    private let overlayView = OverlayView()

    private var topConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!
    private var leftConstraint: NSLayoutConstraint!
    private var widthConstraint: NSLayoutConstraint!

    private var minimumHeightConstraint: NSLayoutConstraint!
    private var minimumWidthConstraint: NSLayoutConstraint!

    public var defaultMinimumSize: CGSize {
        let minLength = max(
            config.handleConfigs.vertex.size / 2 * 2 + config.handleConfigs.edge.size,
            config.handleConfigs.edge.size / 2 * 2 + config.handleConfigs.center.size
        )
        switch aspectMode {
        case .free:
            return .init(width: minLength, height: minLength)
        case .fixed(let ratio):
            if ratio < 1 { // width > height
                return .init(width: minLength / ratio, height: minLength)
            } else { // width <= height
                return .init(width: minLength, height: minLength * ratio)
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        overlayView.apply(masked: guideView.frame)
    }
}

extension RectangleSelectorView {
    var vertexHandles: [HandleView] {
        [
            topLeftHandle,
            topRightHandle,
            bottomLeftHandle,
            bottomRightHandle,
        ]
    }

    var edgeHandles: [HandleView] {
        [
            topEdgeHandle,
            bottomEdgeHandle,
            leftEdgeHandle,
            rightEdgeHandle,
        ]
    }

    var handles: [HandleView] {
        vertexHandles +
        [centerHandle] +
        edgeHandles
    }

    var guideEdgeConstraints: [NSLayoutConstraint] {
        [
            topConstraint,
            heightConstraint,
            leftConstraint,
            widthConstraint
        ]
    }
}

extension RectangleSelectorView {
    public func apply(_ config: Config) {
        guideView.apply(config.guideConfig)
        gridView.apply(config.gridConfig)

        vertexHandles.forEach {
            $0.apply(config.handleConfigs.vertex)
        }

        centerHandle.apply(config.handleConfigs.center)

        edgeHandles.forEach {
            $0.apply(config.handleConfigs.edge)
        }
    }

    public func set(selectedFrame frame: CGRect) {
        topConstraint?.constant = frame.minY
        heightConstraint?.constant = frame.height
        leftConstraint?.constant = frame.minX
        widthConstraint?.constant = frame.width
    }

    public func show(for view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            self.constraintEdges(equalTo: view)
        )
    }
}

extension RectangleSelectorView {
    private func setup() {
        setupViews()
        setupViewConstraints()

        topEdgeHandle.set(.top)
        bottomEdgeHandle.set(.bottom)
        leftEdgeHandle.set(.left)
        rightEdgeHandle.set(.right)
        topLeftHandle.set(.topLeft)
        topRightHandle.set(.topRight)
        bottomLeftHandle.set(.bottomLeft)
        bottomRightHandle.set(.bottomRight)
        centerHandle.set(.center)
    }

    private func setupViews() {
        addSubview(overlayView)

        apply(config)

        centerHandle.isUserInteractionEnabled = false

        // set delegates
        guideView.delegate = self
        handles.forEach {
            $0.delegate = self
        }

        // add subview
        addSubview(guideView)

        guideView.addSubview(gridView)

        addSubview(topLeftHandle)
        addSubview(topRightHandle)
        addSubview(bottomLeftHandle)
        addSubview(bottomRightHandle)

        addSubview(centerHandle)

        addSubview(topEdgeHandle)
        addSubview(bottomEdgeHandle)
        addSubview(leftEdgeHandle)
        addSubview(rightEdgeHandle)
    }

    private func setupViewConstraints() {
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        guideView.translatesAutoresizingMaskIntoConstraints = false
        gridView.translatesAutoresizingMaskIntoConstraints = false

        topConstraint = guideView.topAnchor.constraint(equalTo: topAnchor)
        heightConstraint = guideView.heightAnchor.constraint(equalToConstant: 0)
        leftConstraint = guideView.leftAnchor.constraint(equalTo: leftAnchor)
        widthConstraint = guideView.widthAnchor.constraint(equalToConstant: 0)

        guideEdgeConstraints.forEach {
            $0.priority = .defaultHigh
        }

        // Grid constraints
        NSLayoutConstraint.activate(guideEdgeConstraints)

        // Overlay
        NSLayoutConstraint.activate(
            overlayView.constraintEdges(equalTo: self)
        )

        // Minimum size
        minimumHeightConstraint = guideView.heightAnchor.constraint(
            greaterThanOrEqualToConstant: 0
        )
        minimumWidthConstraint = guideView.widthAnchor.constraint(
            greaterThanOrEqualToConstant: 0
        )
        updateMinimumSizeConstraints()

        // Guide threshold Constraints
        NSLayoutConstraint.activate([
            // Constraints to allow selection only within an area.
            guideView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            guideView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            guideView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor),
            guideView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor),
            // Constraints for minimum size
            minimumHeightConstraint,
            minimumWidthConstraint
        ])

        // Grid Constraints
        NSLayoutConstraint.activate(
            gridView.constraintEdges(equalTo: guideView)
        )

        // Vertex Handle center
        NSLayoutConstraint.activate([
            topLeftHandle.centerXAnchor.constraint(equalTo: guideView.leftAnchor),
            topLeftHandle.centerYAnchor.constraint(equalTo: guideView.topAnchor),
            topRightHandle.centerXAnchor.constraint(equalTo: guideView.rightAnchor),
            topRightHandle.centerYAnchor.constraint(equalTo: guideView.topAnchor),

            bottomLeftHandle.centerXAnchor.constraint(equalTo: guideView.leftAnchor),
            bottomLeftHandle.centerYAnchor.constraint(equalTo: guideView.bottomAnchor),
            bottomRightHandle.centerXAnchor.constraint(equalTo: guideView.rightAnchor),
            bottomRightHandle.centerYAnchor.constraint(equalTo: guideView.bottomAnchor),
        ])

        // Vertex Handle size
        NSLayoutConstraint.activate(
            vertexHandles.map {
                $0.constraintSize(equalTo: $0.visualView)
            }.flatMap { $0 }
        )

        // Center Handle
        NSLayoutConstraint.activate([
            centerHandle.centerXAnchor.constraint(equalTo: guideView.centerXAnchor),
            centerHandle.centerYAnchor.constraint(equalTo: guideView.centerYAnchor),
        ])

        // Edge Handle center
        NSLayoutConstraint.activate([
            topEdgeHandle.centerXAnchor.constraint(equalTo: guideView.centerXAnchor),
            topEdgeHandle.centerYAnchor.constraint(equalTo: guideView.topAnchor),
            bottomEdgeHandle.centerXAnchor.constraint(equalTo: guideView.centerXAnchor),
            bottomEdgeHandle.centerYAnchor.constraint(equalTo: guideView.bottomAnchor),

            leftEdgeHandle.centerXAnchor.constraint(equalTo: guideView.leftAnchor),
            leftEdgeHandle.centerYAnchor.constraint(equalTo: guideView.centerYAnchor),
            rightEdgeHandle.centerXAnchor.constraint(equalTo: guideView.rightAnchor),
            rightEdgeHandle.centerYAnchor.constraint(equalTo: guideView.centerYAnchor),
        ])

        // Edge Handle size
        NSLayoutConstraint.activate([
            topEdgeHandle.leftAnchor.constraint(equalTo: topLeftHandle.rightAnchor),
            topEdgeHandle.rightAnchor.constraint(equalTo: topRightHandle.leftAnchor),

            bottomEdgeHandle.leftAnchor.constraint(equalTo: bottomLeftHandle.rightAnchor),
            bottomEdgeHandle.rightAnchor.constraint(equalTo: bottomRightHandle.leftAnchor),

            leftEdgeHandle.topAnchor.constraint(equalTo: topLeftHandle.bottomAnchor),
            leftEdgeHandle.bottomAnchor.constraint(equalTo: bottomLeftHandle.topAnchor),

            rightEdgeHandle.topAnchor.constraint(equalTo: topRightHandle.bottomAnchor),
            rightEdgeHandle.bottomAnchor.constraint(equalTo: bottomRightHandle.topAnchor),
        ])
    }

    private func updateMinimumSizeConstraints() {
        var minimumSize = self.defaultMinimumSize
        if let _minumumSize = self.minimumSize {
            minimumSize.height = max(minimumSize.height, _minumumSize.height)
            minimumSize.width = max(minimumSize.width, _minumumSize.width)
        }
        minimumHeightConstraint.constant = minimumSize.height
        minimumWidthConstraint.constant = minimumSize.width
    }
}

extension RectangleSelectorView: HandleViewDelegate {
    func handleView(_ view: HandleView, start touch: UITouch) {
        delegate?.rectangleSelector(self, willStartChanging: guideView.frame)
    }

    func handleView(_ view: HandleView, end touch: UITouch) {
        delegate?.rectangleSelector(self, didEndChanging: guideView.frame)
    }

    func handleView(_ view: HandleView, moved touch: UITouch) {
        var location = touch.location(in: self)

        // consider touched position in handle
        location.x -= view.gestureStartPoint.x
        location.y -= view.gestureStartPoint.y

        // Absolute handle position in self
        let horizontal = location.x + view.frame.width / 2
        let vertical = location.y + view.frame.height / 2

        let minimumSize = minimumSize ?? defaultMinimumSize

        switch aspectMode {
        case .free:
            if [topEdgeHandle, topLeftHandle, topRightHandle].contains(view) {
                let diff = (vertical - topConstraint.constant)
                if heightConstraint.constant - diff < minimumSize.height {
                    topConstraint.constant += heightConstraint.constant - minimumSize.height
                    heightConstraint.constant = minimumSize.height
                } else if vertical < 0 {
                    heightConstraint.constant += topConstraint.constant
                    topConstraint.constant = 0
                } else {
                    heightConstraint.constant -= diff
                    topConstraint.constant = vertical
                }
            }

            if [bottomEdgeHandle, bottomLeftHandle, bottomRightHandle].contains(view) {
                let diff = vertical - topConstraint.constant - heightConstraint.constant
                if heightConstraint.constant + diff < minimumSize.height {
                    heightConstraint.constant = minimumSize.height
                } else if topConstraint.constant + heightConstraint.constant + diff > frame.height {
                    heightConstraint.constant = frame.height - topConstraint.constant
                } else {
                    heightConstraint.constant += diff
                }
            }

            if [leftEdgeHandle, topLeftHandle, bottomLeftHandle].contains(view) {
                let diff = (horizontal - leftConstraint.constant)
                if widthConstraint.constant - diff < minimumSize.width {
                    leftConstraint.constant += widthConstraint.constant - minimumSize.width
                    widthConstraint.constant = minimumSize.width
                } else if horizontal < 0 {
                    widthConstraint.constant += leftConstraint.constant
                    leftConstraint.constant = 0
                } else {
                    widthConstraint.constant -= diff
                    leftConstraint.constant = horizontal
                }
            }

            if [rightEdgeHandle, topRightHandle, bottomRightHandle].contains(view) {
                let diff = horizontal - leftConstraint.constant - widthConstraint.constant
                if widthConstraint.constant + diff < minimumSize.width {
                    widthConstraint.constant = minimumSize.width
                } else if leftConstraint.constant + widthConstraint.constant + diff > frame.width {
                    widthConstraint.constant = frame.width - leftConstraint.constant
                } else {
                    widthConstraint.constant += diff
                }
            }

        case let .fixed(aspectRatio):
            switch view {
            case topLeftHandle:
                let diffX = (horizontal - leftConstraint.constant)
                let diffY = (vertical - topConstraint.constant)
                let max: CGSize = .init(
                    width: guideView.frame.maxX,
                    height: guideView.frame.maxY
                )
                let size = CGSize(
                    width: widthConstraint.constant - diffX,
                    height: heightConstraint.constant - diffY
                ).adjusted(        withAspect: aspectRatio, max: max, min: minimumSize)
                topConstraint.constant -= size.height - heightConstraint.constant
                leftConstraint.constant -= size.width - widthConstraint.constant
                widthConstraint.constant = size.width
                heightConstraint.constant = size.height
            case topRightHandle:
                let diffX = (horizontal - leftConstraint.constant - widthConstraint.constant)
                let diffY = (vertical - topConstraint.constant)
                let max: CGSize = .init(
                    width: frame.width - guideView.frame.minX,
                    height: guideView.frame.maxY
                )
                let size = CGSize(
                    width: widthConstraint.constant + diffX,
                    height: heightConstraint.constant - diffY
                ).adjusted(        withAspect: aspectRatio, max: max, min: minimumSize)
                topConstraint.constant -= size.height - heightConstraint.constant
                widthConstraint.constant = size.width
                heightConstraint.constant = size.height
            case bottomLeftHandle:
                let diffX = (horizontal - leftConstraint.constant)
                let diffY = (vertical - topConstraint.constant - heightConstraint.constant)
                let max: CGSize = .init(
                    width: guideView.frame.maxX,
                    height: frame.height - guideView.frame.minY
                )
                let size = CGSize(
                    width: widthConstraint.constant - diffX,
                    height: heightConstraint.constant + diffY
                ).adjusted(        withAspect: aspectRatio, max: max, min: minimumSize)
                leftConstraint.constant -= size.width - widthConstraint.constant
                widthConstraint.constant = size.width
                heightConstraint.constant = size.height
            case bottomRightHandle:
                let diffX = (horizontal - leftConstraint.constant - widthConstraint.constant)
                let diffY = (vertical - topConstraint.constant - heightConstraint.constant)
                let max: CGSize = .init(
                    width: frame.width - guideView.frame.minX,
                    height: frame.height - guideView.frame.minY
                )
                let size = CGSize(
                    width: widthConstraint.constant + diffX,
                    height: heightConstraint.constant + diffY
                ).adjusted(        withAspect: aspectRatio, max: max, min: minimumSize)
                widthConstraint.constant = size.width
                heightConstraint.constant = size.height
            default:
                break
            }
        }

        delegate?.rectangleSelector(self, didUpdate: guideView.frame)
    }
}

extension RectangleSelectorView: GuideViewDelegate {
    func guideView(_ view: GuideView, start touch: UITouch) {
        delegate?.rectangleSelector(self, willStartChanging: guideView.frame)
    }

    func guideView(_ view: GuideView, end touch: UITouch) {
        delegate?.rectangleSelector(self, didEndChanging: guideView.frame)
    }

    func guideView(_ view: GuideView, moved touch: UITouch) {
        var location = touch.location(in: self)
        location.x -= view.gestureStartPoint.x
        location.y -= view.gestureStartPoint.y

        let horizontal = location.x - view.frame.minX
        let vertical = location.y - view.frame.minY

        var shouldUpdateStartPointX = false
        var shouldUpdateStartPointY = false

        if topConstraint.constant + vertical < 0 {
            topConstraint.constant = 0
            shouldUpdateStartPointY = true
        } else if topConstraint.constant + vertical + heightConstraint.constant >= frame.height {
            topConstraint.constant = frame.height - heightConstraint.constant
            shouldUpdateStartPointY = true
        } else {
            topConstraint.constant += vertical
        }

        if leftConstraint.constant + horizontal < 0 {
            leftConstraint.constant = 0
            shouldUpdateStartPointX = true
        } else if leftConstraint.constant + horizontal + widthConstraint.constant >= frame.width {
            leftConstraint.constant = frame.width - widthConstraint.constant
            shouldUpdateStartPointX = true
        } else {
            leftConstraint.constant += horizontal
        }

        if shouldUpdateStartPointX || shouldUpdateStartPointY {
            setNeedsLayout()
            layoutIfNeeded()
            let locationInGuide = touch.location(in: view)
            if shouldUpdateStartPointX { view.gestureStartPoint.x = locationInGuide.x }
            if shouldUpdateStartPointY { view.gestureStartPoint.y = locationInGuide.y }
        }

        delegate?.rectangleSelector(self, didUpdate: guideView.frame)
    }
}

private extension CGSize {
    func adjusted(
        withAspect aspectRatio: CGFloat
    ) -> CGSize {
        var width = width
        var height = height
        if width * aspectRatio < height {
            height = width * aspectRatio
        } else if width * aspectRatio > height {
            width = height / aspectRatio
        }

        return .init(width: width, height: height)
    }

    func adjusted(
        withAspect aspectRatio: CGFloat,
        max: CGSize,
        min: CGSize
    ) -> CGSize {
        var size = adjusted(withAspect: aspectRatio)
        if size.height > max.height { size.height = max.height }
        if size.width > max.width { size.width = max.width }
        if size.height < min.height { size.height = min.height }
        if size.width < min.width { size.width = min.width }
        return size.adjusted(withAspect: aspectRatio)
    }
}

//
//@available(iOS 17.0, *)
//#Preview {
//    let v = RectangleSelectorView()
//    NSLayoutConstraint.activate([
//        v.heightAnchor.constraint(
//            equalToConstant: UIScreen.main.bounds.height
//        ),
//        v.widthAnchor.constraint(
//            equalToConstant: UIScreen.main.bounds.width
//        )
//
//    return v
//}
