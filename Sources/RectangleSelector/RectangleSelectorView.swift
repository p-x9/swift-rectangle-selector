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
    private func setup() {
        setupViews()
        setupViewConstraints()
    }

    private func setupViews() {
        backgroundColor = .yellow

        guideView.apply(config.guideConfig)

        topLeftHandle.apply(config.vertexHandleConfig)
        topRightHandle.apply(config.vertexHandleConfig)
        bottomLeftHandle.apply(config.vertexHandleConfig)
        bottomRightHandle.apply(config.vertexHandleConfig)

        centerHandle.apply(config.edgeHandleConfig)

        topEdgeHandle.apply(config.edgeHandleConfig)
        bottomEdgeHandle.apply(config.edgeHandleConfig)
        leftEdgeHandle.apply(config.edgeHandleConfig)
        rightEdgeHandle.apply(config.edgeHandleConfig)


        topLeftHandle.delegate = self
        topRightHandle.delegate = self
        bottomLeftHandle.delegate = self
        bottomRightHandle.delegate = self

        centerHandle.delegate = self

        topEdgeHandle.delegate = self
        bottomEdgeHandle.delegate = self
        leftEdgeHandle.delegate = self
        rightEdgeHandle.delegate = self

        guideView.translatesAutoresizingMaskIntoConstraints = false

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
        topConstraint = guideView.topAnchor.constraint(equalTo: topAnchor)
        bottomConstraint = guideView.bottomAnchor.constraint(equalTo: bottomAnchor)
        leftConstraint = guideView.leftAnchor.constraint(equalTo: leftAnchor)
        rightConstraint = guideView.rightAnchor.constraint(equalTo: rightAnchor)

        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            leftConstraint,
            rightConstraint
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
    func handleView(_ view: HandleView, updatePanState recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: self)
        switch view {
        case topLeftHandle:
            topConstraint.constant = location.y
            leftConstraint.constant = location.x
        case topRightHandle:
            topConstraint.constant = location.y
            rightConstraint.constant = location.x - self.frame.size.width
        case bottomLeftHandle:
            bottomConstraint.constant = location.y - self.frame.size.height
            leftConstraint.constant = location.x
        case bottomRightHandle:
            bottomConstraint.constant = location.y - self.frame.size.height
            rightConstraint.constant = location.x - self.frame.size.width
        case topEdgeHandle:
            topConstraint.constant = location.y
        case bottomEdgeHandle:
            bottomConstraint.constant = location.y - self.frame.size.height
        case leftEdgeHandle:
            leftConstraint.constant = location.x
        case rightEdgeHandle:
            rightConstraint.constant = location.x - self.frame.size.width
        case centerHandle:
            let horizontal = location.x - centerHandle.frame.minX
            let vertical = location.y - centerHandle.frame.minY
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
