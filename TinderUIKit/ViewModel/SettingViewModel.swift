//
//  SettingViewModel.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/21/24.
//

import UIKit

enum SettingSection: Int, CaseIterable {
    case name
    case profession
    case age
    case bio
    case ageRange

    var title: String {
        switch self {
        case .name: return "Name"
        case .profession: return "Profession"
        case .age: return "Age"
        case .bio: return "Bio"
        case .ageRange: return "Seeking Age range"
        }
    }
}

struct SettingViewModel {
    
    private let user: User
    let section: SettingSection
    
    var shouldHideInputField: Bool {
        return section == .ageRange
    }
    
    var shouldHideSlider: Bool {
        return section != .ageRange
    }
    
    let placeholderText: String
    var value: String?
    
    func minAgeSliderValue() -> Float {
        return Float(user.minSeakingAge)
    }
    
    func maxAgeSliderValue() -> Float {
        return Float(user.maxSeakingAge)
    }
    
    func minAgeLableText(forValue value: Float) -> String {
        return "Min: \(Int(value))"
    }
    
    func maxAgeLableText(forValue value: Float) -> String {
        return "Max: \(Int(value))"
    }
    
    init(user: User, section: SettingSection) {
        self.user = user
        self.section = section
        
        placeholderText = "Enter \(section.title.lowercased()) ..."
        switch section {
        case .name:
            value = user.fullname
        case .profession:
            value = user.profession
        case .age:
            value = String(user.age)
        case .bio:
            value = user.bio
        case .ageRange:
            break
        }
    }
    
}
