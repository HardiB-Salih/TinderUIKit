//
//  AuthenticationViewModel.swift
//  TinderUIKit
//
//  Created by HardiB.Salih on 5/20/24.
//

import Foundation

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationViewModel {
    var email = ""
    var password = ""
    
    var formIsValid: Bool {
        return !email.isEmpty && !password.isEmpty && password.count >= 6
    }
}

struct RegistrationViewModel : AuthenticationViewModel {
    var email = ""
    var fullname = ""
    var password = ""
    
    var formIsValid: Bool {
        return !email.isEmpty && !fullname.isEmpty && fullname.count > 3  && !password.isEmpty && password.count >= 6
    }
}
