//
//  ProfileViewController.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 18.10.2022.
//

import UIKit
import FirebaseAuth

protocol ProfileCellDelegate: AnyObject {
    func didTapFavoriteButton(_ photo: Photo?)
}

final class ProfileViewController: UIViewController, AlertPresentable {

    //MARK: - Properties
    private let viewModel: ProfileViewModel
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Init
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        viewModel.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(didTapSignOut))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        profileImageViewConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentedController()
        DispatchQueue.main.async {
            self.viewModel.fetchProfilePicture()
            self.usernameLabel.text = self.viewModel.fetchUsername()
        }
    }

    // MARK: - Methods
    private func profileImageViewConfigure() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.borderColor = UIColor(red: 66/255, green: 95/255, blue: 87/255, alpha: 1).cgColor
        profileImageView.layer.borderWidth = 1.0
        profileImageView.clipsToBounds = true

    }
    
    private func segmentedController() {
        let segment = segmentedControl.selectedSegmentIndex
        switch segment {
            case 1:
                viewModel.fetchFavoritesOrCollections(collection: "collections")
            case 0:
                viewModel.fetchFavoritesOrCollections(collection: "favorites")
            default:
                viewModel.fetchFavoritesOrCollections(collection: "favorites")
        }
    }
    
    @IBAction func didTapPencil(_ sender: UITapGestureRecognizer) {
        navigationController?.pushViewController(ProfileSettingsViewController(viewModel: ProfileSettingsViewModel()), animated: true)
    }
    
    @IBAction func didChangedSegmentedControl(_ sender: UISegmentedControl) {
        segmentedController()
    }
    
    @objc private func didTapSignOut() {
        showAlert(title: "Warning",
                          message: "Are you sure to sign out?",
                          cancelButtonTitle: "Cancel") { _ in
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true)
            } catch {
                self.showError(error)
            }
        }
    }
}

//MARK: - CollectionViewDelegate
extension ProfileViewController: UICollectionViewDelegate {
    
}

//MARK: - CollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProfileCollectionViewCell else {
            fatalError("ProfileCollectionViewCell not found.")
        }
        
        guard let photo = viewModel.profileForIndexPath(indexPath) else {
            fatalError("Photo not found.")
        }
        guard let photoURL = URL(string: photo.urlC ?? "") else {
            fatalError("PhotoURL not found.")
        }
        cell.delegate = self
        cell.photo = photo
        cell.imageView.kf.setImage(with: photoURL)
        return cell
    }
}

//MARK: - CollectionViewFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (view.frame.width / 2) - 7, height: (view.frame.width / 2) - 7)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        3
    }
}

//MARK: - Profile Delegate
extension ProfileViewController: ProfileDelegate {
    func didFetchAvatarImage(_ image: URL) {
        DispatchQueue.main.async {
            self.profileImageView.kf.setImage(with: image)
        }
    }
    
    func didErrorOccurred(_ error: Error) {
        self.showError(error)
    }
    
    func didFetchFavorites() {
        collectionView.reloadData()
    }
}

//MARK: - ProfileCell Delegate
extension ProfileViewController: ProfileCellDelegate {
    func didTapFavoriteButton(_ photo: Photo?) {
        let segment = segmentedControl.selectedSegmentIndex
        switch segment {
            case 1:
                viewModel.deleteFavoriteOrCollection(photo, collection: "collections")
            case 0:
                viewModel.deleteFavoriteOrCollection(photo, collection: "favorites")
            default:
                viewModel.deleteFavoriteOrCollection(photo, collection: "favorites")
        }
    }
}
