//
//  LoginViewController.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit
import JGProgressHUD

class LoginViewController: UIViewController {
    
    private var viewModel = LoginViewModel()
    
    //MARK: - Properties
    private let logoImageView : UIImageView = {
        let imageView = UIImageView()
        let logo = #imageLiteral(resourceName: "tinder")
        imageView.image = logo.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    private let emailTextField = CustomTextField(placeholder: "Email", keyboardType: .emailAddress)
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureTextEntry: true)
    private let signInButton = UIButton(type: .system)
    private let goToSignUpButton = UIButton(type: .system)
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFormStatus()
        configureGradientLayer()
        configureUI()
        configureTextFieldObservers()
    }
    //MARK: Helpers
    func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

    }
    
    @objc private func textDidChange(_ sender: UITextField) {
//        print("DEBUG: Text Text is \(sender.text)")
        
        if sender == emailTextField {
            viewModel.email = sender.text ?? ""
        } else {
            viewModel.password = sender.text ?? ""
        }
        checkFormStatus()
        print("DEBUG: Form is Valid \(viewModel.formIsValid)")
    }
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            signInButton.isEnabled = true
            signInButton.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        } else {
            signInButton.isEnabled = false
            signInButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
    
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        let attributedText = "Don't Have an account?".mutableAttributedString()
        attributedText.append("  Sign Up".attributedString(font: .systemFont(of: .body, weight: .black)))
        goToSignUpButton.configureButton(attributedTitle: attributedText,
                                         target: self,
                                         action: #selector(goToSignUpClicked))
        signInButton.configureButton(title: "Sign in",
                                     target: self,
                                     action: #selector(signInButtonClicked))
        
        configureViewLayout()
    }
    
    func configureViewLayout(){
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30)
        logoImageView.setDimensions(height: 100, width: 100)
        logoImageView.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, signInButton])
        stack.axis = .vertical
        stack.spacing = 12
        
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 24,
                     paddingLeft: 32,
                     paddingRight: 32)
        
        view.addSubview(goToSignUpButton)
        goToSignUpButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                                paddingLeft: 16, paddingBottom: 20, paddingRight: 16)
        

    }
    
    //MARK: -Action
    @objc func signInButtonClicked() {
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view, animated: true)
        AuthServices.signIn(withEmail: viewModel.email, password: viewModel.password) {[weak self] result in
            switch result {
            case .success( _ ):
                hud.dismiss(animated: true)
                self?.userLoggedIn()
            case .failure(let failure):
                print("Failed To Login \(failure.localizedDescription)")
            }
        }
    }
    
    /// Save the updated value of logged_in to UserDefaults
    private func userLoggedIn(){
        //        UserDefaults.standard.set(true, forKey: "logged_in")
        NotificationCenter.default.post(name: UserDefaults.didChangeNotification, object: nil)
    }
    
    @objc func goToSignUpClicked() { 
        navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
}
