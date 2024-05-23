//
//  MessageViewController.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/23/24.
//

import UIKit

protocol MessageViewControllerDelegate: AnyObject {
    func handleDismiss()
}

class MessageViewController: UITableViewController {

    var user: User
    private let headerView = MatchHeader()
    weak var delegate: MessageViewControllerDelegate?
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMatches()
        configureTableView()
        configureNavigationBar()
        
    }
    
    func configureTableView() {
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 160)
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        
        
    }
    
    func configureNavigationBar() {
        let leftButton = UIImageView()
        leftButton.setDimensions(height: 28, width: 28)
        leftButton.isUserInteractionEnabled = true
        leftButton.image = #imageLiteral(resourceName: "tinder").withRenderingMode(.alwaysTemplate)
        leftButton.tintColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        tap.numberOfTapsRequired = 1
        leftButton.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysTemplate)
        icon.tintColor = .systemPink
        navigationItem.titleView = icon
    }
    
    @objc func handleDismissal() {
        dismiss(animated: true)
    }
    
    
    //MARK: API
    func fetchMatches() {
        Services.fetchMatches { matches in
            self.headerView.matches = matches
        }
    }
}


// MARK: - Datasource
extension MessageViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}


// MARK: - Delegate
extension MessageViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let lable = UILabel()
        lable.textColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        lable.text = "Messages"
        lable.font = .systemFont(of: .headline, weight: .heavy)
        view.addSubview(lable)
        lable.centerY(inView: view, leftAnchor: view.leftAnchor, paddingLeft: 12)
        
        return view
    }
}

// MARK: MatchHeaderDelegate
extension MessageViewController: MatchHeaderDelegate {
    func matchHeader(_ header: MatchHeader, wantToStartChatWith uid: String) {
        Services.fetchUser(with: uid) { result in
            switch result {
            case .success( let user):
                print("DEBUG: User is \(user.fullname)")
            case .failure(let error):
                print("DEBUG: Error feaching selected User: \(error.localizedDescription)")
            }
        }
    }
    
    
}
