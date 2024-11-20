//
//  ViewController.swift
//  Example
//
//  Created by p-x9 on 2024/11/18
//  
//


import UIKit
import RectangleSelector
import SwiftUI

class ViewController: UIViewController {

    let imageView = UIImageView()
    let selector = RectangleSelectorView()

    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: UIFont.smallSystemFontSize)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        setupViews()
        configure()

//        selector.aspectMode = .fixed(0.5)

        var config = selector.config
        let color: UIColor = .cyan
        config.gridConfig.lineColor = color
        config.guideConfig.lineColor = color
        config.handleConfigs.vertex.lineColor = color
        config.handleConfigs.edge.lineColor = color
        config.handleConfigs.center.lineColor = .clear
        selector.clipsToBounds = false
        imageView.clipsToBounds = false

        selector.apply(config)

        selector.isEnabled = false
        selector.isEnabled = true

        selector.addTarget(
            self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }

    @objc
    func valueChanged(_ sender: RectangleSelectorView) {
        let rect = sender.selectedRect
        let x = String(format: "%.0lf", rect.minX)
        let y = String(format: "%.0lf", rect.minY)
        let w = String(format: "%.0lf", rect.width)
        let h = String(format: "%.0lf", rect.height)
        label.text = "(x, y, width, height) = (\(x), \(y), \(w), \(h))"
    }

}

extension ViewController {
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(selector)
        view.addSubview(label)

        selector.delegate = self
        selector.set(selectedFrame: .init(origin: .init(x: 50, y: 50), size: .init(width: 100, height: 100)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        selector.translatesAutoresizingMaskIntoConstraints = false

        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white.cgColor

        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: UIScreen.main.bounds.width / UIScreen.main.bounds.height)
        ])

        NSLayoutConstraint.activate([
            selector.topAnchor.constraint(equalTo: imageView.topAnchor),
            selector.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            selector.leftAnchor.constraint(equalTo: imageView.leftAnchor),
            selector.rightAnchor.constraint(equalTo: imageView.rightAnchor),
        ])

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            label.leftAnchor.constraint(equalTo: imageView.leftAnchor),
            label.rightAnchor.constraint(equalTo: imageView.rightAnchor),
        ])
    }

    private func configure() {
        imageView.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "image", ofType: "png")!)
    }
}

extension ViewController: @preconcurrency RectangleSelectorViewDelegate {
    func rectangleSelector(_ selector: RectangleSelectorView, willStartChanging rect: CGRect) {
//        print("Start", rect)
    }

    func rectangleSelector(_ selector: RectangleSelectorView, didEndChanging rect: CGRect) {
//        print("End", rect)
    }

    func rectangleSelector(_ selector: RectangleSelectorView, didUpdate rect: CGRect) {
//        print("Update", rect)
    }
}


struct ViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController

    func makeUIViewController(context: Context) -> UIViewControllerType {
        .init()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
