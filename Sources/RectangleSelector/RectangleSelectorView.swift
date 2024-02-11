import UIKit

public class RectangleSelectorView: UIView {

    var config: Config = .default

    private let topLeftHandle = HandleView()
    private let topRightHandle = HandleView()
    private let bottomLeftHandle = HandleView()
    private let bottomRightHandle = HandleView()

    private let centerHandle = HandleView()

    private let topEdgeHandle = HandleView()
    private let bottomEdgeHandle = HandleView()
    private let leftEdgeHandle = HandleView()
    private let rightEdgeHandle = HandleView()

    private let guideView = GuideView()

    private var topConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    private var leftConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!

    private var centerXConstraint: NSLayoutConstraint!
    private var centerYConstraint: NSLayoutConstraint!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    private func setup() {
        setupViews()
        setupViewConstraints()
    }

    private func setupViews() {
        backgroundColor = .yellow

        guideView.apply(config.guideConfig)

        // apply handle config
        vertexHandles.forEach {
            $0.apply(config.vertexHandleConfig)
        }

        centerHandle.apply(config.edgeHandleConfig)

        edgeHandles.forEach {
            $0.apply(config.edgeHandleConfig)
        }

        // set delegates
        handles.forEach {
            $0.delegate = self
        }

        // add subview
        addSubview(guideView)

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
        guideView.translatesAutoresizingMaskIntoConstraints = false

        topConstraint = guideView.topAnchor.constraint(equalTo: topAnchor)
        bottomConstraint = guideView.bottomAnchor.constraint(equalTo: bottomAnchor)
        leftConstraint = guideView.leftAnchor.constraint(equalTo: leftAnchor)
        rightConstraint = guideView.rightAnchor.constraint(equalTo: rightAnchor)

        guideEdgeConstraints.forEach {
            $0.priority = .defaultHigh
        }

        NSLayoutConstraint.activate(guideEdgeConstraints)

        NSLayoutConstraint.activate([
            guideView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            guideView.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
        ])

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

        NSLayoutConstraint.activate([
            centerHandle.centerXAnchor.constraint(equalTo: guideView.centerXAnchor),
            centerHandle.centerYAnchor.constraint(equalTo: guideView.centerYAnchor),
        ])

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
    }
}

extension RectangleSelectorView: HandleViewDelegate {
    func handleView(_ view: HandleView, updatePanState recognizer: UITouch) {
        var location = recognizer.location(in: self)
        location.x -= view.gestureStartPoint.x
        location.y -= view.gestureStartPoint.y

        let horizontal = location.x + view.frame.width / 2
        let vertical = location.y + view.frame.height / 2

        switch view {
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
        case topEdgeHandle:
            topConstraint.constant = vertical
        case bottomEdgeHandle:
            bottomConstraint.constant = vertical - self.frame.size.height
        case leftEdgeHandle:
            leftConstraint.constant = horizontal
        case rightEdgeHandle:
            rightConstraint.constant = horizontal - self.frame.size.width
        case centerHandle:
            let horizontal = location.x - view.frame.minX
            let vertical = location.y - view.frame.minY
            topConstraint.constant += vertical
            bottomConstraint.constant += vertical
            leftConstraint.constant += horizontal
            rightConstraint.constant += horizontal
        default:
            break
        }
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
