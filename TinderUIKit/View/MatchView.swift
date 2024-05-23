//
//  MatchView.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/23/24.
//

import UIKit
import SDWebImage

protocol MatchViewDelegate :  AnyObject {
    func matchView(_ view: MatchView, wantToSendMessageTo user: User)
}

class MatchView: UIView {

    //MARK: - Properties
    private let viewModel: MatchViewViewModel
    weak var delegate : MatchViewDelegate?
    
    
    private let matchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let descriptionLabel: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.font = .systemFont(of: .title3, weight: .bold)
        lable.textColor = .white
        lable.numberOfLines = 0
        return lable
    }()
    
    private let currentUserImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 70
        iv.layer.cornerCurve = .continuous
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    private let matchedUserImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 70
        iv.layer.cornerCurve = .continuous
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    private lazy var sendMessageButton : BackgroundGradientButton = {
        let button = BackgroundGradientButton(type: .system)
        button.addTarget(self, action: #selector(sendMessageClicked), for: .touchUpInside)
        button.applyBackgroundGradient(colors: [#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1) , #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)], startPoint: .bottomLeading, endPoint: .topTrailing, cornerRadius: 16)
        button.setTitle("Send Message", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(of: .headline, weight: .medium)
        return button
    }()
    
    private lazy var keepSwipingButton : BorderGradientButton = {
        let button = BorderGradientButton(type: .system)
        button.addTarget(self, action: #selector(keepSwipingClicked), for: .touchUpInside)
        button.applyBorderGradient(colors: [#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1) , #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)],
                                   startPoint: .topTrailing,
                                   endPoint: .bottomLeading,
                                   borderWidth: 2, cornerRadius: 16)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(of: .headline, weight: .medium)
        
        return button
    }()
    
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    lazy var views = [
        matchImageView,
        descriptionLabel,
        currentUserImageView,
        matchedUserImageView,
        sendMessageButton,
        keepSwipingButton
    ]

    //MARK: - Life cycle
    init(viewModel: MatchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        currentUserImageView.sd_setImage(with: viewModel.currentUserImageURL)
        matchedUserImageView.sd_setImage(with: viewModel.matchedUserImageURL)
        descriptionLabel.text = viewModel.matchLableText
        configureBlurView()
        configureUI()
        configureAnimation()

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions
    @objc func sendMessageClicked() { delegate?.matchView(self, wantToSendMessageTo: viewModel.matchedUser) }
    @objc func keepSwipingClicked() { handleDismissal() }
    @objc func handleDismissal() {
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }

    }
    
    
    //MARK: Helpers

    func configureBlurView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        tap.numberOfTapsRequired = 1
        visualEffectView.addGestureRecognizer(tap)
        
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.visualEffectView.alpha = 1
        }
    }
    
    func configureUI() {
        views.forEach { view in
            addSubview(view)
            view.alpha = 0
        }
        
        currentUserImageView.anchor(right: centerXAnchor, paddingRight: 16)
        currentUserImageView.setDimensions(height: 140, width: 140)
        currentUserImageView.centerY(inView: self)
        
        matchedUserImageView.anchor(left: centerXAnchor, paddingLeft: 16)
        matchedUserImageView.setDimensions(height: 140, width: 140)
        matchedUserImageView.centerY(inView: self)
        
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                 paddingTop: 32, paddingLeft: 48, paddingRight: 48, height: 50)



        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, 
                                 left: leftAnchor, right: rightAnchor,
                                 paddingTop: 16, paddingLeft: 48, 
                                 paddingRight: 48, height: 50)
        

        
        descriptionLabel.anchor(left: leftAnchor, bottom: currentUserImageView.topAnchor, right: rightAnchor,
                                paddingBottom: 32 )
        

        matchImageView.anchor(bottom: descriptionLabel.topAnchor, paddingBottom: 16)
        matchImageView.setDimensions(height: 80, width: 300)
        matchImageView.centerX(inView: self)
        
    }
    
    
    func configureAnimation() {
        views.forEach( { $0.alpha = 1} )
        let angle = 30 * CGFloat.pi / 180
        
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        matchedUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        matchImageView.transform = CGAffineTransform(translationX: 0, y: -100)

        UIView.animateKeyframes(withDuration: 1.3, delay: 0,options: .calculationModeCubic) {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.matchedUserImageView.transform = CGAffineTransform(rotationAngle: angle)
                self.matchImageView.transform = .identity
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                self.currentUserImageView.transform = .identity
                self.matchedUserImageView.transform = .identity
            }
        }
        
        
        UIView.animate(withDuration: 0.75, delay: 0.5 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
        }
    }
}
