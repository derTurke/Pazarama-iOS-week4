//
//  SearchResultViewController.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 19.10.2022.
//

import UIKit

protocol SearchResultFavoriteAndCollectionDelegate {
    func didTapLikedButton(_ photo: SearchResultPhoto?)
    func didTapCollectionButton(_ photo: SearchResultPhoto?)
}

class SearchResultViewController: UIViewController, AlertPresentable {
    //MARK: - Properties
    private let viewModel: SearchResultViewModel
    var text: String? {
        didSet {
            viewModel.fetchSearchResult(text: text)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Init
    init(viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    //MARK: - Methods

}

//MARK: - TableView Delegate
extension SearchResultViewController: UITableViewDelegate {
    
}

//MARK: - TableViewDataSource
extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchResultTableViewCell else {
            fatalError("RecentTableViewCell not found.")
        }
        guard let searchResponse = viewModel.searchResponseForIndexPath(indexPath) else {
            fatalError("Search Response not found.")
        }
        guard let photoURL = URL(string: searchResponse.urlC ?? "") else {
            return cell
        }
        
        cell.recentImageView.kf.setImage(with: photoURL)
        cell.username = searchResponse.ownername
        cell.profileImageView.image = UIImage(named: "profile")
        cell.favoriteDelegate = self
        cell.photo = searchResponse
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

//MARK: - SearchResultDelegate
extension SearchResultViewController: SearchResultDelegate {
    func didErrorOccurred(_ error: Error) {
        showError(error)
    }
    
    func didFetchSearch() {
        tableView.reloadData()
    }
}

//MARK: - FavoriteAndCollectionDelegate
extension SearchResultViewController: SearchResultFavoriteAndCollectionDelegate {
    func didTapLikedButton(_ photo: SearchResultPhoto?) {
        viewModel.addFavoritesOrCollections(photo, collection: "favorites") { result in
            switch result {
                case true:
                    self.showAlert(title: "Success",message: "Recent photo has been added to the collections.")
                case false:
                    self.showAlert(title: "Failed", message: "Recent photo has not been added to the collections.")
            }
        }
    }
    
    func didTapCollectionButton(_ photo: SearchResultPhoto?) {
        viewModel.addFavoritesOrCollections(photo, collection: "collections") { result in
            switch result {
                case true:
                    self.showAlert(title: "Success",message: "Recent photo has been added to the collections.")
                case false:
                    self.showAlert(title: "Failed", message: "Recent photo has not been added to the collections.")
            }
        }
    }
}

