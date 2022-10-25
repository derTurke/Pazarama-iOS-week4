//
//  ProfileViewModel.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 18.10.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

protocol ProfileDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didFetchFavorites()
    func didFetchAvatarImage(_ image: URL)
}

final class ProfileViewModel {
    weak var delegate: ProfileDelegate?
    
    private let db = Firestore.firestore()
    
    private let ref = Storage.storage().reference()
    
    private let defaults = UserDefaults.standard
    
    private var photos = [Photo]()
    
    var numberOfRows: Int {
        photos.count
    }
    
    func fetchFavoritesOrCollections(collection: String?) {
        photos = []
        guard let id = defaults.string(forKey: "uid"),
              let collection = collection else {
            return
        }
        db.collection("users").document(id).collection(collection).getDocuments { querySnapshot, error in
            if let error {
                self.delegate?.didErrorOccurred(error)
                return
            }
            guard (querySnapshot?.documents) != nil, let data = querySnapshot?.documents else {
                return
            }
            if data.isEmpty {
                self.delegate?.didFetchFavorites()
            } else {
                for item in data {
                    let favorites = Photo(from: item.data())
                    self.photos.append(favorites)
                    self.delegate?.didFetchFavorites()
                }
            }
        }
    }
    
    func profileForIndexPath(_ indexPath: IndexPath) -> Photo? {
        photos[indexPath.row]
    }
    
    func fetchProfilePicture() {
        guard let uid = defaults.string(forKey: "uid") else {
            fatalError("Uid not found")
        }
       
        self.ref.child("images/\(uid).png").downloadURL { url, error in
            if let error {
                self.delegate?.didErrorOccurred(error)
                return
            }
            guard let url = url else {
                return
            }
            DispatchQueue.main.async {
                self.delegate?.didFetchAvatarImage(url.absoluteURL)
            }
        }
        
    }
    
    func fetchUsername() -> String{
        Auth.auth().currentUser?.displayName ?? ""
    }
    
    func deleteFavoriteOrCollection(_ photo: Photo?, collection: String?) {
        guard let photo = photo,
              let photoId = photo.id,
              let id = defaults.string(forKey: "uid"),
              let collection = collection else {
            return
        }
        db.collection("users").document(id).collection(collection).document(photoId).delete() { error in
            if let error {
                self.delegate?.didErrorOccurred(error)
                return
            }
            self.fetchFavoritesOrCollections(collection: collection)
        }
    }
    
    
}
