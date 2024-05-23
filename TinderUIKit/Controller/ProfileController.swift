//
//  ProfileController.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/22/24.
//

import UIKit
import SDWebImage


let ProfileCellIdentifier = "ProfileCell"

protocol ProfileControllerDelegate: AnyObject {
    func profileController(_ controller: ProfileController, didLikeUser user: User)
    func profileController(_ controller: ProfileController, didDislikeUser user: User)

}


class ProfileController: UIViewController {
    //MARK: - Properties
    
    
    weak var delegate: ProfileControllerDelegate?
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + 100)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCellIdentifier)
        return cv
    }()
    
    lazy var closeButton : UIButton = {
        let b = UIButton(type: .system)
        let bImage = #imageLiteral(resourceName: "dismiss_down_arrow")
        b.setImage(bImage.withRenderingMode(.alwaysOriginal), for: .normal)
        b.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return b
    }()
    
    private lazy var infoLable : UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = .systemFont(of: .title2, weight: .semibold)
        return lable
    }()
    private var profitionLable : UILabel = {
        let lable = UILabel()
        lable.isHidden = true
        lable.font = .systemFont(of: .body, weight: .thin)
        return lable
    }()
    
    private var bioLable : UILabel = {
        let lable = UILabel()
        lable.numberOfLines = 0
        lable.font = .systemFont(of: .body)
        lable.isHidden = true
        return lable
    }()
    
    
    
    lazy var disslikeButton : UIButton = {
        let b = UIButton(type: .system)
        let bImage = #imageLiteral(resourceName: "dismiss_circle")
        b.setImage(bImage.withRenderingMode(.alwaysOriginal), for: .normal)
        b.imageView?.contentMode = .scaleAspectFill
        b.addTarget(self, action: #selector(handleDisLikeButton), for: .touchUpInside)
        return b
    }()
    
    lazy var superLikeButton : UIButton = {
        let b = UIButton(type: .system)
        let bImage = #imageLiteral(resourceName: "super_like_circle")
        b.setImage(bImage.withRenderingMode(.alwaysOriginal), for: .normal)
        b.imageView?.contentMode = .scaleAspectFill
        b.addTarget(self, action: #selector(handleSuperLikeButton), for: .touchUpInside)
        return b
    }()
    
    lazy var likeButton : UIButton = {
        let b = UIButton(type: .system)
        let bImage = #imageLiteral(resourceName: "like_circle")
        b.setImage(bImage.withRenderingMode(.alwaysOriginal), for: .normal)
        b.imageView?.contentMode = .scaleAspectFill
        b.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
        return b
    }()
    
    
    private var user : User
    private lazy var viewModel = ProfileViewModel(user: user)
    private lazy var barStackView = SegmentedBarView(numberOfSegments: user.imageURLs.count)
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        
        
        
        infoLable.attributedText = user.attributedNameWithAge(textColor: .black)
        
        if user.profession.isNotEmpty {
            profitionLable.isHidden = false
            profitionLable.text = user.profession
        }
        
        if user.bio.isNotEmpty {
            bioLable.isHidden = false
            bioLable.text = user.bio
        }
    }
    
    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 50)
        configureBarStackView()
        view.addSubview(closeButton)
        closeButton.setDimensions(height: 40, width: 40)
        closeButton.anchor(top: collectionView.bottomAnchor, right: view.rightAnchor, paddingTop: -20, paddingRight: 16)
        
        let infoStack = UIStackView(arrangedSubviews: [infoLable, profitionLable, bioLable])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        
        view.addSubview(infoStack)
        infoStack.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                         paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        
        let buttomControllerStack = UIStackView(arrangedSubviews: [disslikeButton, superLikeButton, likeButton])
        view.addSubview(buttomControllerStack)
        buttomControllerStack.spacing = 12
        buttomControllerStack.alignment = .center
        buttomControllerStack.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        buttomControllerStack.centerX(inView: view)
    

    }
    
    func configureBarStackView() {
        view.addSubview(barStackView)
        barStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                       paddingTop: 24 ,paddingLeft: 30 ,paddingRight: 30 ,
                            height: 8 )
    }
    
    //MARK: - Action
    @objc func handleDismiss() {
        dismiss(animated: true)
    }
    
    @objc func handleDisLikeButton() { delegate?.profileController(self, didDislikeUser: user) }
    @objc func handleLikeButton() { delegate?.profileController(self, didLikeUser: user)}
    @objc func handleSuperLikeButton() {}

}

    //MARK: - UICollectionViewDataSource
extension ProfileController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCellIdentifier, for: indexPath) as? ProfileCell else {
            return UICollectionViewCell()
        }
        
        let imageString = user.imageURLs[indexPath.item]
        cell.imageView.sd_setImage(with: URL(string: imageString))
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ProfileController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if user.imageURLs.count > 1 {
            barStackView.setHighlighted(index: indexPath.row)
        }
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.width + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
