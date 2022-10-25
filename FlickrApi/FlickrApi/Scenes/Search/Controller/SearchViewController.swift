//
//  SearchViewController.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 18.10.2022.
//

import UIKit
import Kingfisher

final class SearchViewController: UIViewController, AlertPresentable {

    //MARK: - Properties
    private let viewModel: SearchViewModel
    private let searchController = UISearchController(searchResultsController: SearchResultViewController(viewModel: SearchResultViewModel()))
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK: - Init
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        tabBarController?.navigationItem.hidesBackButton = true
        viewModel.delegate = self
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPhotos()
    }

    // MARK: - Methods
    func fetchPhotos() {
        viewModel.fetchPhotos()
    }
}

//MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        let vc = searchController.searchResultsController as? SearchResultViewController
        vc?.text = text
    }
}

//MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
}

//MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SearchCollectionViewCell else {
            fatalError("SearchCollectionViewCell not found.")
        }
        guard let searchItem = viewModel.searchForIndexPath(indexPath), let url = searchItem.urlC else {
            return cell
        }
        guard let photoURL = URL(string: url) else {
            return cell
        }
        cell.imageView.kf.setImage(with: photoURL)
        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
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

extension SearchViewController: SearchDelegate {
    func didErrorOccurred(_ error: Error) {
        self.showError(error)
    }
    
    func didFetchSearch() {
        collectionView.reloadData()
    }
    
    
}

