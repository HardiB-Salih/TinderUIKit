//
//  RegistrationViewController.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import UIKit
import JGProgressHUD
class RegistrationViewController: UIViewController {
    
    private var viewModel = RegistrationViewModel()
    //MARK: - Properties
    private lazy var selectPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        let select = #imageLiteral(resourceName: "plus_photo")
        button.setImage( select, for: .normal)
        button.addTarget(self, action: #selector(selectPhotoButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email", keyboardType: .emailAddress)
    private let fullnameTextField = CustomTextField(placeholder: "Fullname", keyboardType: .alphabet)
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureTextEntry: true)
    private let signUpButton = UIButton(type: .system)
    
    private let goToSignInButton = UIButton(type: .system)
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFormStatus()
        configureTextFieldObservers()
        configureUI()
        
    }
    //MARK: Helpers
    
    //MARK: Helpers
    func configureTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc private func textDidChange(_ sender: UITextField) {
        switch sender {
        case emailTextField:
            viewModel.email = sender.text ?? ""
        case fullnameTextField:
            viewModel.fullname = sender.text ?? ""
        case passwordTextField:
            viewModel.password = sender.text ?? ""
        default:
            break
        }
        checkFormStatus()
    }
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
    func configureUI() {
        configureGradientLayer()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        let attributedText = "Alredy have an account?".mutableAttributedString()
        attributedText.append("  Sign In".attributedString(font: .systemFont(of: .body, weight: .black)))
        goToSignInButton.configureButton(attributedTitle: attributedText,
                                         target: self,
                                         action: #selector(goToSignInClicked))
        
        signUpButton.configureButton(title: "Sign up",
                                     target: self,
                                     action: #selector(signUpButtonClicked))
        
        
        configureViewLayout()
        
    }
    
    //MARK: - Layout
    private func configureViewLayout() {
        
        view.addSubview(selectPhotoButton)
        selectPhotoButton.anchor()
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30)
        selectPhotoButton.setDimensions(height: 275, width: 275)
        selectPhotoButton.centerX(inView: view)
        
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, fullnameTextField, passwordTextField, signUpButton])
        stack.axis = .vertical
        stack.spacing = 12
        
        
        view.addSubview(stack)
        stack.anchor(top: selectPhotoButton.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 24,
                     paddingLeft: 32,
                     paddingRight: 32)
        
        
        
        
        view.addSubview(goToSignInButton)
        goToSignInButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                                paddingLeft: 16, paddingBottom: 20, paddingRight: 16)
    }
    
    
    
    //MARK: -Action
    @objc private func selectPhotoButtonClicked() {
        print("DEBUG: Processing Image here")
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
        
        
        
        
    }
    
    @objc private func signUpButtonClicked() {
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view, animated: true)
        guard let image = selectPhotoButton.imageView?.image, image != #imageLiteral(resourceName: "plus_photo")  else {
            print("Please Select A Photo")
            hud.dismiss()
            return
        }
        let authCredential = AuthCredential(email: viewModel.email,
                                            fullname: viewModel.fullname,
                                            password: viewModel.password,
                                            profileImage: image)
        AuthServices.registerUser(withCredential: authCredential) {[weak self] error in
            if let error = error {
                print("Debug: Error Signing user up: \(error.localizedDescription)")
            }
            
            print("Success: Leave this page")
            hud.dismiss(animated: true)
            self?.userLoggedIn()
        }
        
    }
    
    @objc private func goToSignInClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    /// Save the updated value of logged_in to UserDefaults
    private func userLoggedIn(){
        //        UserDefaults.standard.set(true, forKey: "logged_in")
        NotificationCenter.default.post(name: UserDefaults.didChangeNotification, object: nil)
    }
    
}

//MARK: - UIImagePickerControllerDelegate
extension RegistrationViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        selectPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        selectPhotoButton.layer.cornerRadius = 8
        selectPhotoButton.layer.cornerCurve = .continuous
        selectPhotoButton.layer.borderWidth = 3
        selectPhotoButton.layer.borderColor = UIColor(white: 1, alpha: 0.7).cgColor
        selectPhotoButton.imageView?.contentMode = .scaleAspectFill
        selectPhotoButton.clipsToBounds = true
        
        dismiss(animated: true)
    }
}
