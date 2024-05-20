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
//        view.clipsToBounds = true
        return view
    }()
    private let bottomStack = ButtomControlsStackView()
    
    //MARK: - Life sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCards()
    }
    
    
    //MARK: Helpers
    func configureCards() {
        let user1 = User(name: "Jane Doe", age: 22, images: [#imageLiteral(resourceName: "jane1.jpg") , #imageLiteral(resourceName: "jane2.jpg") , #imageLiteral(resourceName: "jane3.jpg")])
        let user2 = User(name: "Kelly John", age: 25, images: [#imageLiteral(resourceName: "kelly1.jpg"), #imageLiteral(resourceName: "kelly2.jpg"), #imageLiteral(resourceName: "kelly3.jpg")])
        
        let cardView1 = CardView(viewModel: CardViewModel(user: user1))
        let cardView2 = CardView(viewModel: CardViewModel(user: user2))

        
        deckView.addSubview(cardView1)
        deckView.addSubview(cardView2)
        
        cardView1.fillSuperview()
        cardView2.fillSuperview()
    }
    
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

