//
//  ProfileSettingsViewModel.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 19.10.2022.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

protocol ProfileSettingsProtocol: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didFetchImage(_ image: URL)
    func didSaveUser()
}

final class ProfileSettingsViewModel {
    weak var delegate: ProfileSettingsProtocol?
    private let defaults = UserDefaults.standard
    private let ref = Storage.storage().reference()
    
    func saveImagePicker(image: UIImage?) {
        guard let imageData = image?.pngData() else {
            return
        }
        guard let uid = UserDefaults.standard.string(forKey: "uid") else {
            return
        }
        ref.child("images/\(uid).png").putData(imageData) { _, error in
            if let error {
                self.delegate?.didErrorOccurred(error)
                return
            }
            self.fetchImage()
        }
    }
    
    func fetchImage() {
        guard let uid = defaults.string(forKey: "uid") else { return }
        ref.child("images/\(uid).png").downloadURL { url, error in
            if let error {
                self.delegate?.didErrorOccurred(error)
            }
            guard let url = url else {
                return
            }
            self.delegate?.didFetchImage(url.absoluteURL)
        }
    }
    
    func fetchUsername() -> String{
        Auth.auth().currentUser?.displayName ?? ""
    }
    
    func save(username: String?) {
        guard let username = username else { return }
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        changeRequest?.commitChanges { error in
            if let error {
                self.delegate?.didErrorOccurred(error)
            }
            self.delegate?.didSaveUser()
        }
    }
}
