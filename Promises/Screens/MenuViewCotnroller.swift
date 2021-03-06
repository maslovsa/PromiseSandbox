//
//  MenuViewCotnroller.swift
//  PromiseToPromise
//
//  Copyright © 2018 Michał Warchał. All rights reserved.
//

import UIKit

final public class MenuViewController: UIViewController {
    
    private let menuView = MenuView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCallbacks()
    }
    
    private func setupView() {
        view.addSubview(menuView)
        LayoutBuilder().pin(menuView, to: view, edges: .init(top: 200, left: 80, bottom: -200, right: -80))
        title = "Promise Playground"
    }

    private func setupCallbacks() {
        menuView.imageButton.addTarget(self, action: #selector(imageButtonTapped), for: .touchUpInside)
        menuView.mapButton.addTarget(self, action: #selector(mapButtonTapped), for: .touchUpInside)
        menuView.multipleRequestButton.addTarget(self, action: #selector(multipleRequestButtonTapped), for: .touchUpInside)
    }
    
    @objc private func imageButtonTapped() {
        navigationController?.pushViewController(ImageAnimationViewController(), animated: true)
    }
    
    @objc private func mapButtonTapped() {
        navigationController?.pushViewController(MapViewController(), animated: true)
    }
    
    @objc private func multipleRequestButtonTapped() {
        navigationController?.pushViewController(MultipleRequestViewController(), animated: true)
    }
}
