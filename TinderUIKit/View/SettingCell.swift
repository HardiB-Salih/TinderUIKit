//
//  SettingCell.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/21/24.
//

import UIKit

protocol SettingCellDelegate: AnyObject {
    func settingCell(_ cell: SettingCell,
                     updateUserWith value: String,
                     for section: SettingSection)
    
    func settingCell(_ cell: SettingCell, updateAgeRangeWith sender: UISlider)
}

class SettingCell : UITableViewCell {
    //MARK: - Properties
    var viewModel: SettingViewModel! {
        didSet { configure() }
    }
    
    weak var delegate: SettingCellDelegate?
    
    lazy var inputField : UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = .systemFont(of: .body)
        tf.keyboardType = .default
        tf.addTarget(self, action: #selector(inputEditingDidEnd), for: .editingDidEnd)
        
        // Adding left padding
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 28)
        tf.leftView = spacer
        tf.leftViewMode = .always
        
        // Adding right padding
        tf.rightView = spacer
        tf.rightViewMode = .always
        return tf
    }()
    var sliderStack = UIStackView()
    
    let minAgeLabe = UILabel()
    let maxAgeLabe = UILabel()
    
    lazy var minAgeSlider = creatAgeRangeSlider()
    lazy var maxAgeSlider = creatAgeRangeSlider()

    
    //MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Helpers
    
    func configure() {
        setUpUI()
        
        inputField.isHidden = viewModel.shouldHideInputField
        sliderStack.isHidden = viewModel.shouldHideSlider
        inputField.placeholder = viewModel.placeholderText
        inputField.text = viewModel.value
    }
    
    func setUpUI() {
        addSubview(inputField)
        inputField.fillSuperview()
        
        minAgeLabe.text = viewModel.minAgeLableText(forValue: viewModel.minAgeSliderValue())
        maxAgeLabe.text = viewModel.maxAgeLableText(forValue: viewModel.maxAgeSliderValue())

        
        minAgeSlider.setValue(viewModel.minAgeSliderValue(), animated: true)
        maxAgeSlider.setValue(viewModel.maxAgeSliderValue(), animated: true)

        let minStack = UIStackView(arrangedSubviews: [minAgeLabe, minAgeSlider])
        minStack.spacing = 24
        
        
        let maxStack = UIStackView(arrangedSubviews: [maxAgeLabe, maxAgeSlider])
        maxStack.spacing = 24
        
        sliderStack = .init(arrangedSubviews: [minStack, maxStack])
        sliderStack.axis = .vertical
        sliderStack.spacing = 16
        addSubview(sliderStack)
        sliderStack.centerY(inView: self)
        sliderStack.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 24, paddingRight: 24)
    }
    
    func creatAgeRangeSlider() -> UISlider{
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 80
        slider.addTarget(self, action: #selector(handleAgeRangeChange), for: .valueChanged)
        return slider
    }
    
    
    @objc func handleAgeRangeChange(sender: UISlider) {
        if sender == minAgeSlider {
            minAgeLabe.text = viewModel.minAgeLableText(forValue: sender.value)
        } else {
            maxAgeLabe.text = viewModel.maxAgeLableText(forValue: sender.value)
        }
        
        delegate?.settingCell(self, updateAgeRangeWith: sender)
    }
    
    @objc func inputEditingDidEnd(sender: UITextField) {
        guard let value = sender.text else { return }
        delegate?.settingCell(self, updateUserWith: value, for: viewModel.section)
    }
}

