//
//  HomeController.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/19/24.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    
    //MARK: - Properties
    private var users = [User]()
    private var currentUser : User?
    
    private var viewModels = [CardViewModel]() {
        didSet{
            configureCards()
        }
    }
    
    private let topStack = HomeNavigationStackView()
    private let deckView = UIView()
    private let bottomStack = ButtomControlsStackView()
    
    //Setting Like and Dislike the user
    private var topCardView : CardView?
    private var cardViews = [CardView]()
    
    //MARK: - Life sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        topStack.delegate = self
        bottomStack.delegate = self
        configureUI()
        fetchCurrentUser()
    }

    
    //MARK: Helpers
    func fetchUsers(forUser user: User) {
        Services.fetchUsers(forUser: user) { [self] result in
            switch result {
            case .success( let usersData):
                self.viewModels = usersData.map({ CardViewModel(user: $0 )})
            case .failure( let error):
                print("DEBUG: Error is \(error)")
            }
        }
    }
    
    func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Services.fetchUser(with: uid, completion: { result in
            switch result {
            case .success(let user):
                self.fetchUsers(forUser: user)
                self.currentUser = user
            case .failure(_): break
            }
        })
    }
    

    
    func configureCards() {
        viewModels.forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)
            cardView.delegate = self
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        cardViews = deckView.subviews.compactMap { $0 as? CardView }
        topCardView = cardViews.last
    }
    
    func configureUI() {
        
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


//MARK: - HomeNavigationStackViewDelegate
extension HomeController: HomeNavigationStackViewDelegate {
    func showSettings() {
        print("Message Sent")
        DispatchQueue.main.async {
            guard let user = self.currentUser else { return }
            let vc = SettingController(user: user)
            let navVC = UINavigationController(rootViewController: vc)
            vc.delegate = self
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
    }
    
    func showMessages() {
        DispatchQueue.main.async {
            guard let user = self.currentUser else { return }
            let controller = MessageViewController(user: user)
            controller.delegate = self
            let navVC = UINavigationController(rootViewController: controller)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
    }
}

//MARK: - SettingControllerDelegate
extension HomeController: SettingControllerDelegate {
    func settingController(wantToUpdate user: User) {
        self.currentUser = user
    }
    
    func settingController(_ controller: SettingController, wantsToUpdate user: User) {
        controller.dismiss(animated: true)
        self.currentUser = user
    }
}

//MARK: - CardViewDelegate
extension HomeController: CardViewDelegate {
    func cardView(_ View: CardView, didLikeUser: Bool) {
        View.removeFromSuperview()
        self.cardViews.removeAll(where: { View == $0 })
        guard let user = topCardView?.cardViewModel.user else { return }
//        print(user.fullname)
        self.saveSwipeAndCheckForMatch(forUser: user, didLike: didLikeUser)
//        Services.saveSwipe(forUser: user, isLike: didLikeUser, completion: nil)
        topCardView = cardViews.last
    }
    
    func cardView(_ View: CardView, wantToShowProfileFor user: User) {
        let vc = ProfileController(user: user)
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: - ButtomControlsStackViewDelegate
extension HomeController: ButtomControlsStackViewDelegate {
    func handleLike() {
        guard let topCard = topCardView  else {return }
        performSwipeAnimation(shouldLike: true)
        self.saveSwipeAndCheckForMatch(forUser: topCard.cardViewModel.user, didLike: true)
//        Services.saveSwipe(forUser: topCard.cardViewModel.user, isLike: true, completion: nil)
//        print(topCard.cardViewModel.user.fullname)
    }
    
    func handleDislike() {
        guard let topCard = topCardView  else {return }
        performSwipeAnimation(shouldLike: false)
        Services.saveSwipe(forUser: topCard.cardViewModel.user, isLike: false, completion: nil)
//        print(topCard.cardViewModel.user.fullname)

    }
    
    func handleRefresh() {
        print("handleRefresh")
    }
    
    
    func presentMatchView(forUser user: User) {
        guard let currentUser = self.currentUser else { return }
        let viewModel = MatchViewViewModel(currentUser: currentUser, matchedUser: user)
        let matchView = MatchView(viewModel: viewModel)
        matchView.delegate = self
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    func saveSwipeAndCheckForMatch(forUser user: User, didLike: Bool) {
        Services.saveSwipe(forUser: user, isLike: didLike) { error in
            if let error = error {
                print(error)
                return
            }
            
            self.topCardView = self.cardViews.last
            guard didLike == true else { return }
            Services.checkIfMatchExists(forUser: user) { didMatch in
                if didMatch {
                    print("DEBUG: User did Match")
                    self.presentMatchView(forUser: user)
                    guard let currentUser = self.currentUser else { return }
                    print(currentUser.fullname)
                    print(user.fullname)
                    Services.uploadMatch(currentUser: currentUser, matchUser: user)
                }
            }
        }
    }
    
    func performSwipeAnimation(shouldLike: Bool) {
        let translation: CGFloat = shouldLike ? 700 : -700
        let rotationAngle: CGFloat = shouldLike ? .pi / 16 : -.pi / 16 // Adjust the angle as needed
        
        topCardView?
            .bounceAnimation {
                // Apply translation and rotation transforms
                let translationTransform = CGAffineTransform(translationX: translation, y: 0)
                let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)
                self.topCardView?.transform = translationTransform.concatenating(rotationTransform)
            } completion: {
                self.topCardView?.removeFromSuperview()
                guard !self.cardViews.isEmpty else { return }
                self.cardViews.removeLast()
                // cardViews.remove(at: cardViews.count - 1)
                // topCardView = cardViews.last
                self.topCardView = self.cardViews.last
            }
    }
    
    
}


extension HomeController: ProfileControllerDelegate {
    func profileController(_ controller: ProfileController, didLikeUser user: User) {
        print("DEBUG : Handle Like User: \(user.fullname)")
        dismiss(animated: true) {
            self.performSwipeAnimation(shouldLike: true)
            self.saveSwipeAndCheckForMatch(forUser: user, didLike: true)
        }
    }
    
    func profileController(_ controller: ProfileController, didDislikeUser user: User) {
        print("DEBUG : Handle Dis Like User: \(user.fullname)")
        dismiss(animated: true) {
            self.performSwipeAnimation(shouldLike: false)
            Services.saveSwipe(forUser: user, isLike: false, completion: nil)
        }
    }
}

extension HomeController : MessageViewControllerDelegate {
    func handleDismiss() {
        dismiss(animated: true)
    }
}


//MARK: MatchViewDelegate
extension HomeController : MatchViewDelegate {
    func matchView(_ view: MatchView, wantToSendMessageTo user: User) {
        print("DEBUG: Start conversation with \(user.fullname)")
    }
}
