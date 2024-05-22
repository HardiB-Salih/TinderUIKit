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
}


class SettingController: UITableViewController {
    private var user: User

    //MARK: - Properties
    let hud = JGProgressHUD(style: .dark)

    private lazy var headerView = SettingHeader(user: user)
    private let imagePicker = UIImagePickerController()
    private var imageInex = 1
    weak var delegate: SettingControllerDelegate?
    init(user: User) {
        self.user = user
        super.init(style: .plain)
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
    func uploadImage(image: UIImage) {
        
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
        imagePicker.delegate = self
    }
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleDone() {
        view.endEditing(true)
        delegate?.settingController(self, wantsToUpdate: user)
        
        // Upload Data
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
        setHeaderImage(image)
        dismiss(animated: true)
    }
    
    func setHeaderImage(_ image: UIImage? ) {
        guard let image = image else { return }
        if let selectedButton = headerView.buttons.first(where: { $0.tag == imageInex }) {
            selectedButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
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
