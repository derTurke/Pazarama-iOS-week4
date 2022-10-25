//
//  AuthViewModel.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 18.10.2022.
//

import Foundation
import FirebaseAuth

enum AuthViewModelChange {
    case didErrorOccurred(_ error: Error)
}

final class AuthViewModel {
    private let defaults = UserDefaults.standard
    
    var changeHandler: ((AuthViewModelChange) -> Void)?
    
    func signUp(credential: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: credential, password: password) { result, error in
            if let error {
                self.changeHandler?(.didErrorOccurred(error))
                return
            }
            guard let id = result?.user.uid else {
                return
            }
            self.defaults.set(id, forKey: "uid")
            completion()
        }
    }
    
    func signIn(credential: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: credential, password: password) { result, error in
            if let error {
                self.changeHandler?(.didErrorOccurred(error))
                return
            }
            guard let id = result?.user.uid else {
                return
            }
            self.defaults.set(id, forKey: "uid")
            completion()
            
        }
    }
}
