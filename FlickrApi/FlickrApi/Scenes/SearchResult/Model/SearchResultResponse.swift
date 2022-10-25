//
//  SearchResultResponse.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 19.10.2022.
//

import Foundation
import Foundation

struct SearchResultResponse: Codable {
    let photos: SearchResultPhotos?
    let stat: String?
}

struct SearchResultPhotos: Codable {
    let page, pages, perpage, total: Int?
    let photo: [SearchResultPhoto]?
}

struct SearchResultPhoto: Codable {
    let id, owner, secret, server: String?
    let farm: Int?
    let title: String?
    let ispublic, isfriend, isfamily: Int?
    let ownername: String?
    let urlC: String?
    let heightC, widthC: Int?

    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily, ownername
        case urlC = "url_c"
        case heightC = "height_c"
        case widthC = "width_c"
    }
}


extension SearchResultPhoto {
    init(from dict: [String: Any]) {
        id = dict["id"] as? String
        owner = dict["owner"] as? String
        secret = dict["secret"] as? String
        server = dict["server"] as? String
        farm = dict["farm"] as? Int
        title = dict["title"] as? String
        ispublic = dict["ispublic"] as? Int
        isfriend = dict["isfriend"] as? Int
        isfamily = dict["isfamily"] as? Int
        ownername = dict["ownername"] as? String
        urlC = dict["url_c"] as? String
        heightC = dict["height_c"] as? Int
        widthC = dict["width_c"] as? Int
    }
}
