import UIKit

public protocol RectangleSelectorViewDelegate: AnyObject {
    func rectangleSelector(_ selector: RectangleSelectorView, willStartChanging rect: CGRect)
    func rectangleSelector(_ selector: RectangleSelectorView, didEndChanging rect: CGRect)
    func rectangleSelector(_ selector: RectangleSelectorView, didUpdate rect: CGRect)
}

extension RectangleSelectorViewDelegate {
    func rectangleSelector(_ selector: RectangleSelectorView, willStartChanging rect: CGRect) {}
    func rectangleSelector(_ selector: RectangleSelectorView, didEndChanging rect: CGRect) {}
    func rectangleSelector(_ selector: RectangleSelectorView, didUpdate rect: CGRect) {}
}

public final class RectangleSelectorView: UIView {

    public private(set) var config: Config = .default
    public var aspectMode: AspectMode = .free {
        didSet {
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
    private var bottomConstraint: NSLayoutConstraint!
    private var leftConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!

    private var minimumHeightConstraint: NSLayoutConstraint!
    private var minimumWidthConstraint: NSLayoutConstraint!

    public var defaultMinimumSize: CGSize {
        let minLength = config.handleConfig.size / 2 * 2 + config.handleConfig.size
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
            bottomConstraint,
            leftConstraint,
            rightConstraint
        ]
    }
}

extension RectangleSelectorView {
    public func apply(_ config: Config) {
        guideView.apply(config.guideConfig)
        gridView.apply(config.gridConfig)

        vertexHandles.forEach {
            $0.apply(config.handleConfig)
        }

        centerHandle.apply(config.handleConfig)

        edgeHandles.forEach {
            $0.apply(config.handleConfig)
        }
    }

    public func set(selectedFrameInsets insets: UIEdgeInsets) {
        topConstraint?.constant = insets.top
        bottomConstraint?.constant = -insets.bottom
        leftConstraint?.constant = insets.left
        rightConstraint?.constant = -insets.right
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
        bottomConstraint = guideView.bottomAnchor.constraint(equalTo: bottomAnchor)
        leftConstraint = guideView.leftAnchor.constraint(equalTo: leftAnchor)
        rightConstraint = guideView.rightAnchor.constraint(equalTo: rightAnchor)

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

        switch aspectMode {
        case .free:
            switch view {
            case topEdgeHandle:
                topConstraint.constant = vertical
            case bottomEdgeHandle:
                bottomConstraint.constant = vertical - self.frame.size.height
            case leftEdgeHandle:
                leftConstraint.constant = horizontal
            case rightEdgeHandle:
                rightConstraint.constant = horizontal - self.frame.size.width
            case centerHandle:
                break
            case topLeftHandle:
                topConstraint.constant = vertical
                leftConstraint.constant = horizontal
            case topRightHandle:
                topConstraint.constant = vertical
                rightConstraint.constant = horizontal - self.frame.size.width
            case bottomLeftHandle:
                bottomConstraint.constant = vertical - self.frame.size.height
                leftConstraint.constant = horizontal
            case bottomRightHandle:
                bottomConstraint.constant = vertical - self.frame.size.height
                rightConstraint.constant = horizontal - self.frame.size.width
            default:
                break
            }

        case let .fixed(aspectRatio):
            switch view {
            case topLeftHandle:
                let size = CGSize(
                    width: frame.width - horizontal + rightConstraint.constant,
                    height: frame.height - vertical + bottomConstraint.constant
                ).adjusted(with: aspectRatio)
                topConstraint.constant = frame.height - size.height + bottomConstraint.constant
                leftConstraint.constant = frame.width - size.width + rightConstraint.constant
            case topRightHandle:
                let size = CGSize(
                    width: frame.width - leftConstraint.constant + horizontal - frame.size.width,
                    height: frame.height - vertical + bottomConstraint.constant
                ).adjusted(with: aspectRatio)
                topConstraint.constant = frame.height - size.height + bottomConstraint.constant
                rightConstraint.constant = -(frame.width - size.width - leftConstraint.constant)
            case bottomLeftHandle:
                let size = CGSize(
                    width: frame.width - horizontal + rightConstraint.constant,
                    height: frame.height - topConstraint.constant + vertical - frame.size.height
                ).adjusted(with: aspectRatio)
                bottomConstraint.constant = -(frame.height - size.height - topConstraint.constant)
                leftConstraint.constant = frame.width - size.width + rightConstraint.constant
            case bottomRightHandle:
                let size = CGSize(
                    width: frame.width - leftConstraint.constant + horizontal - frame.size.width,
                    height: frame.height - topConstraint.constant + vertical - frame.size.height
                ).adjusted(with: aspectRatio)
                bottomConstraint.constant = -(frame.height - size.height - topConstraint.constant)
                rightConstraint.constant = -(frame.width - size.width - leftConstraint.constant)
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

        let locationInGuide = touch.location(in: view)

        if topConstraint.constant + vertical < 0 {
            bottomConstraint.constant -= topConstraint.constant
            topConstraint.constant = 0
            view.gestureStartPoint.y = locationInGuide.y
        } else if bottomConstraint.constant + vertical > 0 {
            topConstraint.constant -= bottomConstraint.constant
            bottomConstraint.constant = 0
            view.gestureStartPoint.y = locationInGuide.y
        } else {
            topConstraint.constant += vertical
            bottomConstraint.constant += vertical
        }

        if leftConstraint.constant + horizontal < 0 {
            rightConstraint.constant -= leftConstraint.constant
            leftConstraint.constant = 0
            view.gestureStartPoint.x = locationInGuide.x
        } else if rightConstraint.constant + horizontal > 0 {
            leftConstraint.constant -= rightConstraint.constant
            rightConstraint.constant = 0
            view.gestureStartPoint.x = locationInGuide.x
        } else {
            leftConstraint.constant += horizontal
            rightConstraint.constant += horizontal
        }

        delegate?.rectangleSelector(self, didUpdate: guideView.frame)
    }
}

private extension CGSize {
    func adjusted(
        with aspectRatio: CGFloat
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
//    ])
//
//    return v
//}
