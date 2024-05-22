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
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        configureUI()
        fetchCurrentUser()
        fetchUsers()
        
        
        
//        // Usage Example
//        let downloadUrl = "https://firebasestorage.googleapis.com:443/v0/b/tinderuikit.appspot.com/o/images%2Fprofile%2FCBBEB38D-1280-4C88-A057-280123D8A9F2.jpeg?alt=media&token=80f054ea-e149-422f-a28f-6a8158392c57"
//        
//        let path = Services.extractPathFromUrl(downloadUrl)
//        print("DEBUG: THE PATH IS: \(path!)")
    }
    
    //MARK: Helpers
    func fetchUsers() {
        Services.fetchUsers { [self] result in
            switch result {
            case .success( let usersData):
                self.viewModels = usersData.map({ CardViewModel(user: $0 )})
//                self.users = usersData
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
                self.currentUser = user
            case .failure(_): break
            }
        })
    }
    
    func configureCards() {
        viewModels.forEach { viewModel in
            let cardView = CardView(viewModel: viewModel)
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    func configureUI() {
        topStack.delegate = self
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
        guard let user = currentUser else { return }
        let vc = SettingController(user: user)
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navVC.modalPresentationStyle = .fullScreen
        vc.navigationItem.backBarButtonItem = backButtonItem
        present(navVC, animated: true)
    }
    
    func showMessages() {
        print("Message Sent")
    }
}

//MARK: - HomeNavigationStackViewDelegate
extension HomeController: SettingControllerDelegate {
    func settingController(wantToUpdate user: User) {
        self.currentUser = user
    }
    
    func settingController(_ controller: SettingController, wantsToUpdate user: User) {
        controller.dismiss(animated: true)
        self.currentUser = user
    }
    
    
}
