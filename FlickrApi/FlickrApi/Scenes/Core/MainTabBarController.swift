//
//  MainTabBarController.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 18.10.2022.
//

import UIKit

final class MainTabBarController: UITabBarController {
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarConfigure()
        setupTabBarController()
    }
    //MARK: - Methods
    private func setupTabBarController() {
        //Recent View Tab
        let nav1 = setupViewController(with: RecentViewController(viewModel: RecentViewModel()), tabBarTitle: "Recent", tabBarImage: UIImage(named: "recent")!, tabBarSelectedImage: nil)
        //Search View Tab
        let nav2 = setupViewController(with: SearchViewController(viewModel: SearchViewModel()), tabBarTitle: "Search", tabBarImage: UIImage(named: "search")!, tabBarSelectedImage: nil)
        //Profile View Tab
        let nav3 = setupViewController(with: ProfileViewController(viewModel: ProfileViewModel()), tabBarTitle: "Profile", tabBarImage: UIImage(named: "profile")!, tabBarSelectedImage: nil)
        viewControllers = [nav1, nav2, nav3]
    }
    
    private func setupViewController(with viewController: UIViewController, tabBarTitle: String, tabBarImage: UIImage, tabBarSelectedImage: UIImage?) -> UINavigationController {
        viewController.tabBarItem = UITabBarItem(title: tabBarTitle, image: tabBarImage, selectedImage: tabBarSelectedImage)
        return UINavigationController(rootViewController: viewController)
    }
    
    private func tabBarConfigure() {
        UITabBar.appearance().tintColor = UIColor(named: "Primary")
    }
    
}


