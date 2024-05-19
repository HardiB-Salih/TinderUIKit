//
//  HomeController.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/19/24.
//

import UIKit

class HomeController: UIViewController {
    
    
    //MARK: - Properties
    private let topStack = HomeNavigationStackView()
    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemMint
        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous
        return view
    }()
    private let bottomStack = ButtomControlsStackView()
    
    //MARK: - Life sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        let stack = UIStackView(arrangedSubviews: [topStack, deckView, bottomStack])
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                        left: view.leftAnchor,
                        bottom: view.safeAreaLayoutGuide.bottomAnchor,
                        right: view.rightAnchor)
        
//        stack.distribution = .equalCentering
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)

    }
}

