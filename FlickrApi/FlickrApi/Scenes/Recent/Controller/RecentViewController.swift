//
//  RecentViewController.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 18.10.2022.
//

import UIKit
import Kingfisher

protocol FavoriteAndCollectionDelegate {
    func didTapLikedButton(_ recentPhoto: Photo?)
    func didTapCollectionButton(_ recentPhoto: Photo?)
}

final class RecentViewController: UIViewController, AlertPresentable {
    //MARK: - Properties
    private let viewModel: RecentViewModel
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Init
    init(viewModel: RecentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.navigationItem.hidesBackButton = true
        title = "Recent"
        //Recent Delegate
        viewModel.delegate = self
        //TableView
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "RecentTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        fetchRecentPhotos()
    }

    // MARK: - Methods
    
    private func fetchRecentPhotos(){
        viewModel.fetchRecentPhotos()
    }
    
}
//MARK: - TableView Delegate
extension RecentViewController: UITableViewDelegate {
    
}

//MARK: - TableViewDataSource
extension RecentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecentTableViewCell else {
            fatalError("RecentTableViewCell not found.")
        }
        guard let recentPhoto = viewModel.recentPhotoForIndexPath(indexPath) else {
            fatalError("Recent Photo not found.")
        }
        guard let photoURL = URL(string: recentPhoto.urlC ?? "") else {
            return cell
        }
        cell.recentImageView.kf.setImage(with: photoURL)
        cell.username = recentPhoto.ownername
        cell.profileImageView.image = UIImage(named: "profile")
        cell.favoriteDelegate = self
        cell.recentPhoto = recentPhoto
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - Recent Delegate
extension RecentViewController: RecentDelegate {
    func didErrorOccurred(_ error: Error) {
        showError(error)
    }
    func didFetchRecent() {
        tableView.reloadData()
    }
}

//MARK: - Favorite And Collection Delegate
extension RecentViewController: FavoriteAndCollectionDelegate {
    func didTapLikedButton(_ recentPhoto: Photo?) {
        viewModel.addRecentPhotoFavorite(recentPhoto) { result in
            switch result {
                case true:
                    self.showAlert(title: "Success",message: "Recent photo has been added to the favorites.")
                case false:
                    self.showAlert(title: "Failed", message: "Recent photo has not been added to the favorites.")
            }
        }
    }
    
    func didTapCollectionButton(_ recentPhoto: Photo?) {
        viewModel.addRecentPhotoCollection(recentPhoto) { result in
            switch result {
                case true:
                    self.showAlert(title: "Success",message: "Recent photo has been added to the collections.")
                case false:
                    self.showAlert(title: "Failed", message: "Recent photo has not been added to the collections.")
            }
        }
    }
}
