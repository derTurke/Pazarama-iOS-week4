//
//  ProfileCollectionViewCell.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 19.10.2022.
//

import UIKit

final class ProfileCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: ProfileCellDelegate?
    var photo: Photo?
    
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var likedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "trash"), for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        button.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageViewConfigure()
        likedButtonConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func imageViewConfigure() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.snp.makeConstraints { make in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
    }
    
    private func likedButtonConfigure() {
        addSubview(likedButton)
        likedButton.translatesAutoresizingMaskIntoConstraints = false
        likedButton.snp.makeConstraints { make in
            make.trailing.equalTo(-10.0)
            make.top.equalTo(10.0)
            make.height.width.equalTo(40.0)
        }
    }
    
    @objc private func didTapFavoriteButton() {
        delegate?.didTapFavoriteButton(photo)
    }
    
}
