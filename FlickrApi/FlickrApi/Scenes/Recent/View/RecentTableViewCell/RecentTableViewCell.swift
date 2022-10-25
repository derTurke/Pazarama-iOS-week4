//
//  RecentTableViewCell.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 18.10.2022.
//

import UIKit

final class RecentTableViewCell: UITableViewCell {
    var recentPhoto: Photo?
    
    var favoriteDelegate: FavoriteAndCollectionDelegate?
    
    var username: String? {
        didSet {
            usernameLabel.text = username
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet private(set) weak var recentImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var collectionButton: UIButton!
    
    @IBAction func didTapLikedButton(_ sender: UIButton) {
        favoriteDelegate?.didTapLikedButton(recentPhoto)
    }
    
    @IBAction func didTapCollectionButton(_ sender: UIButton) {
        favoriteDelegate?.didTapCollectionButton(recentPhoto)
    }
}
