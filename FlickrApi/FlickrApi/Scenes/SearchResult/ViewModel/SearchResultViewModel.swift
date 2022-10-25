//
//  SearchResultViewModel.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 19.10.2022.
//

import Foundation
import FirebaseFirestore

protocol SearchResultDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didFetchSearch()
}

final class SearchResultViewModel {
    
    weak var delegate: SearchResultDelegate?
    
    private let db = Firestore.firestore()
    
    private let defaults = UserDefaults.standard
    
    private var searchResponse: SearchResultResponse? {
        didSet {
            delegate?.didFetchSearch()
        }
    }
    
    var numberOfRows: Int {
        searchResponse?.photos?.photo?.count ?? .zero
    }
    
    func fetchSearchResult(text: String?) {
        guard let text = text else {
            return
        }
        flickerAPI.request(.getSearchPhotos(text)) { result in
            switch result {
                case .failure(let error):
                    self.delegate?.didErrorOccurred(error)
                case .success(let response):
                do {
                    let searchResponse = try JSONDecoder().decode(SearchResultResponse.self, from: response.data)
                    
                    self.searchResponse = searchResponse
                } catch {
                    self.delegate?.didErrorOccurred(error)
                }
            }
        }
    }
    func searchResponseForIndexPath(_ indexPath: IndexPath) -> SearchResultPhoto? {
        searchResponse?.photos?.photo?[indexPath.row]
    }
    
    func addFavoritesOrCollections(_ photo: SearchResultPhoto?, collection: String? , completion: @escaping (Bool) -> Void) {
        guard let photo = photo,
              let photoId = photo.id,
              let collection = collection else {
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
            db.collection("users").document(id).collection(collection).document(photoId).setData(data) { error in
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
