//
//  RectangleSelectorController.swift
//
//
//  Created by p-x9 on 2024/07/15
//  
//

import UIKit

public protocol RectangleSelectorDelegate: AnyObject {
    func rectangleSelector(_ selector: RectangleSelectorController, willStartChanging rect: CGRect)
    func rectangleSelector(_ selector: RectangleSelectorController, didEndChanging rect: CGRect)
    func rectangleSelector(_ selector: RectangleSelectorController, didUpdate rect: CGRect)
}

extension RectangleSelectorDelegate {
    public func rectangleSelector(_ selector: RectangleSelectorController, willStartChanging rect: CGRect) {}
    public func rectangleSelector(_ selector: RectangleSelectorController, didEndChanging rect: CGRect) {}
    public func rectangleSelector(_ selector: RectangleSelectorController, didUpdate rect: CGRect) {}
}

public final class RectangleSelectorController: UIViewController {
    public let selectorView: RectangleSelectorView = .init()

    public private(set) var config: Config = .default
    public weak var delegate: RectangleSelectorDelegate?

    public var aspectMode: AspectMode {
        get { selectorView.aspectMode }
        set { selectorView.aspectMode = newValue }
    }
    public var minimumSize: CGSize? {
        get { selectorView.minimumSize }
        set { selectorView.minimumSize = newValue }
    }

    public var selectedRect: CGRect {
        selectorView.selectedRect
    }

    public init() {
        super.init(nibName: nil, bundle: nil)

        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        view = self.selectorView
    }
}

extension RectangleSelectorController {
    private func setup() {
        selectorView.delegate = self
        apply(config)

        definesPresentationContext = true
        modalPresentationStyle = .fullScreen
    }
}
extension RectangleSelectorController {
    public func apply(_ config: Config) {
        selectorView.apply(config)
    }
}

extension RectangleSelectorController: RectangleSelectorViewDelegate {
    public func rectangleSelector(_ selector: RectangleSelectorView, willStartChanging rect: CGRect) {
        delegate?.rectangleSelector(self, willStartChanging: rect)
    }

    public func rectangleSelector(_ selector: RectangleSelectorView, didEndChanging rect: CGRect) {
        delegate?.rectangleSelector(self, didEndChanging: rect)
    }

    public func rectangleSelector(_ selector: RectangleSelectorView, didUpdate rect: CGRect) {
        delegate?.rectangleSelector(self, didUpdate: rect)
    }
}
