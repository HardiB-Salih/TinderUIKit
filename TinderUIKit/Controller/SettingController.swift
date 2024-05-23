//
//  SettingViewController.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/21/24.
//

import UIKit
import JGProgressHUD
let Identifier = "SettingCell"

protocol SettingControllerDelegate: AnyObject {
    func settingController(_ controller: SettingController, wantsToUpdate user: User)
    func settingController( wantToUpdate user: User)
}


class SettingController: UITableViewController {
    private var user: User

    //MARK: - Properties

    private lazy var headerView = SettingHeader(user: user)
    private lazy var footerView = SettingFooter()
    private let imagePicker = UIImagePickerController()
    private var imageInex = 1
    weak var delegate: SettingControllerDelegate?
    init(user: User) {
        self.user = user
//        super.init(style: .plain)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    
    //MARK: - API
    func uploadImage(image: UIImage, index: Int) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Image"
        hud.show(in: view)
        
        if index >= 0 && index < user.imageURLs.count && user.imageURLs[index] != "" {
            Services.deleteFileFromFirebaseStorage(downloadUrl: user.imageURLs[index])
        }
        
        // Add new photo to the Storage
        Services.uploadImage(with: image) { result in
            switch result {
            case .success(let imageUrl):
                if index >= 0 && index < self.user.imageURLs.count && self.user.imageURLs[index] != "" {
                    self.user.imageURLs[index] = imageUrl
                } else {
                    self.user.imageURLs.append( imageUrl)
                }
                // Update ImageURLs For that user
                Services.updateUserImageUrlData(user: self.user) { error in
                    if let error = error  {
                        print("DEBUG: Failed to update User Data: \(error.localizedDescription)")
                        hud.dismiss()
                        return
                    }
                    hud.dismiss()
                    // Update the Home current user locally.
                    self.delegate?.settingController(wantToUpdate: self.user)
                }
            case .failure(let error):
                print("DEBUG: Error uploading image: \(error.localizedDescription)")
                hud.dismiss()
            }
        }
                

    }

    
    @objc func handleDone() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Image"
        hud.show(in: view)
        view.endEditing(true)
        Services.updateUserData(user: user) { error in
            if let error = error  {
                print("DEBUG: Failed to update User Data: \(error.localizedDescription)")
                hud.dismiss()
                return
            }
            hud.dismiss()
            self.delegate?.settingController(self, wantsToUpdate: self.user)
        }
    }
    
    
    
    
    //MARK: Helpers
    func configureUI() {
        navigationItem.title = "Setting"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(SettingCell.self, forCellReuseIdentifier: Identifier)
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        headerView.delegate = self
        
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 88)
        footerView.delegate = self
        
        
        imagePicker.delegate = self
    }
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    

}


//MARK: - DataSorce
extension SettingController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard 
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier, for: indexPath) as? SettingCell,
            let secton = SettingSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.selectionStyle = .none
        cell.viewModel = SettingViewModel(user: user, section: secton)
        return cell
    }
}

//Delegate
extension SettingController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let secton = SettingSection(rawValue: section) else { return nil}
        return secton.title
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let secton = SettingSection(rawValue: indexPath.section) else { return 0}

        return secton == .ageRange ? 96 : 44
    }
}




//MARK: - SettingHeaderDelegate
extension SettingController : SettingHeaderDelegate {
    func settingHeader(_ header: SettingHeader, didSelect index: Int) {
        self.imageInex = index
       present(imagePicker, animated: true)
    }
}

//MARK: - UIImagePickerControllerDelegate
extension SettingController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        setHeaderImage(image) { index in
            self.uploadImage(image: image, index: index)
        }
        dismiss(animated: true)
    }
    
    func setHeaderImage(_ image: UIImage?, completion: @escaping (Int) -> Void) {
        guard let image = image else { return }
        
        // Check if the clicked button has an image
        if let clickedButton = headerView.buttons.first(where: { $0.tag == imageInex && $0.currentImage != nil }) {
            clickedButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            print("Button Has Image")
            completion(clickedButton.tag)
           
        } else if let index = headerView.buttons.firstIndex(where: { $0.currentImage == nil }) {
            // If clicked button doesn't have an image, find the first button without an image
            headerView.buttons[index].setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            print("Button  is Empty")
            completion(index)
            
        }
    }
}


    //MARK: - SettingCellDelegate
extension SettingController : SettingCellDelegate {
    func settingCell(_ cell: SettingCell, updateAgeRangeWith sender: UISlider) {
        if sender == cell.minAgeSlider {
            user.minSeakingAge = Int(sender.value)
        } else {
            user.maxSeakingAge = Int(sender.value)
        }
    }
    
    func settingCell(_ cell: SettingCell, updateUserWith value: String, for section: SettingSection) {
        switch section {
        case .name:
            user.fullname = value
        case .profession:
            user.profession = value
        case .age:
            user.age = Int(value) ?? user.age
        case .bio:
            user.bio = value
        case .ageRange:
            break
        }
        
       
    }
}


//MARK: -SettingFooterDelegate is Logging the user out
extension SettingController : SettingFooterDelegate {
    
    /// Save the updated value of logged_in to UserDefaults
    private func userLogOut(){
        NotificationCenter.default.post(name: UserDefaults.didChangeNotification, object: nil)
    }
    
    func handleLogout() {
        AuthServices.signOut {[ weak self ] error in
            if error != nil {
                print("DEBUG: User Cond not Log out")
                return
            }
            self?.userLogOut()
        }
    }
}
