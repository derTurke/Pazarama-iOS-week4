//
//  SearchViewModel.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 18.10.2022.
//

import Foundation
protocol SearchDelegate: AnyObject {
    func didErrorOccurred(_ error: Error)
    func didFetchSearch()
}

final class SearchViewModel {
    weak var delegate: SearchDelegate?
    
    private var searchResponse: SearchResponseModel? {
        didSet {
            delegate?.didFetchSearch()
        }
    }
    
    var numberOfSections: Int {
        searchResponse?.photos?.photo?.count ?? .zero
    }
    
    func fetchPhotos(){
        flickerAPI.request(.getSearch) { result in
            switch result {
                case .failure(let error):
                    self.delegate?.didErrorOccurred(error)
                case .success(let response):
                do {
                    let recentResponse = try JSONDecoder().decode(SearchResponseModel.self, from: response.data)
                    
                    self.searchResponse = recentResponse
                } catch {
                    self.delegate?.didErrorOccurred(error)
                }
            }
        }
    }
    
    func searchForIndexPath(_ indexPath: IndexPath) -> PhotoModel? {
        searchResponse?.photos?.photo?[indexPath.row]
    }
}
