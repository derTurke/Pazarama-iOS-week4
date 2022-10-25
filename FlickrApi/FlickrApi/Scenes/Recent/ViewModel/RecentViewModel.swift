//
//  RecentViewModel.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 18.10.2022.
//

import Foundation
import Moya
import FirebaseFirestore

protocol RecentDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didFetchRecent()
}

final class RecentViewModel {
    
    weak var delegate: RecentDelegate?
    
    private let db = Firestore.firestore()
    
    private let defaults = UserDefaults.standard
    
    private var recentResponse: RecentResponse? {
        didSet {
            delegate?.didFetchRecent()
        }
    }
    
    var numberOfRows: Int {
        recentResponse?.photos?.photo?.count ?? .zero
    }
    
    func fetchRecentPhotos(){
        flickerAPI.request(.getRecentPhotos) { result in
            switch result {
                case .failure(let error):
                    self.delegate?.didErrorOccurred(error)
                case .success(let response):
                do {
                    let recentResponse = try JSONDecoder().decode(RecentResponse.self, from: response.data)
                    
                    self.recentResponse = recentResponse
                } catch {
                    self.delegate?.didErrorOccurred(error)
                }
            }
        }
    }
    
    func recentPhotoForIndexPath(_ indexPath: IndexPath) -> Photo? {
        recentResponse?.photos?.photo?[indexPath.row]
    }
    
    func addRecentPhotoFavorite(_ photo: Photo?, completion: @escaping (Bool) -> Void) {
        guard let photo = photo, let photoId = photo.id  else {
            completion(false)
            return
        }
        do {
            guard let data = try photo.dictionary else {
                completion(false)
                return
            }
            guard let id = defaults.string(forKey: "uid") else {
                completion(false)
                return
            }
            db.collection("users").document(id).collection("favorites").document(photoId).setData(data) { error in
                if let error {
                    self.delegate?.didErrorOccurred(error)
                }
                completion(true)
            }
        } catch {
            self.delegate?.didErrorOccurred(error)
        }
    }
    
    func addRecentPhotoCollection(_ photo: Photo?, completion: @escaping (Bool) -> Void) {
        guard let photo = photo, let photoId = photo.id  else {
            completion(false)
            return
        }
        do {
            guard let data = try photo.dictionary else {
                completion(false)
                return
            }
            guard let id = defaults.string(forKey: "uid") else {
                completion(false)
                return
            }
            db.collection("users").document(id).collection("collections").document(photoId).setData(data) { error in
                if let error {
                    self.delegate?.didErrorOccurred(error)
                }
                completion(true)
            }
        } catch {
            self.delegate?.didErrorOccurred(error)
        }
    }
}
