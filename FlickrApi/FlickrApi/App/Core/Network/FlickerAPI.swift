//
//  FlickerGetRecent.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 18.10.2022.
//

import Foundation
import Moya

let flickerAPI = MoyaProvider<FlickerAPI>()

enum FlickerAPI {
    case getRecentPhotos
    case getSearchPhotos(_ text: String)
    case getSearch
}

extension FlickerAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://www.flickr.com/services/rest") else {
            fatalError("Base URL not found or not in correct format.")
        }
        return url
    }
    
    var path: String {
        "/"
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        var parameters: [String: Any] = [:]
        switch self {
            case .getRecentPhotos:
                parameters = ["method": "flickr.photos.getRecent",
                              "api_key": "9d2f8465a46267b299c87c386312bdda",
                              "format": "json",
                              "nojsoncallback": "1",
                              "extras" : "owner_name,url_c"]
            case .getSearchPhotos(let text):
                parameters = ["method": "flickr.photos.search",
                              "api_key": "9d2f8465a46267b299c87c386312bdda",
                              "format": "json",
                              "nojsoncallback": "1",
                              "extras" : "owner_name,url_c",
                              "text": text]
        case .getSearch:
            parameters = ["method": "flickr.photos.getRecent",
                          "api_key": "9d2f8465a46267b299c87c386312bdda",
                          "format": "json",
                          "nojsoncallback": "1",
                          "extras" : "owner_name,url_c"]
        }
        
        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }
    
    var headers: [String : String]? {
        nil
    }
    
    
}
