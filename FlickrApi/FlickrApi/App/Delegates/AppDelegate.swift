//
//  AppDelegate.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 17.10.2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SnapKit
import IQKeyboardManagerSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupFirebase()
        setupIQKeyboardManager()
        setupWindow()
        
        return true
    }
    //IQKeyboardManager setup
    private func setupIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }
    
    // Firebase setup
    private func setupFirebase() {
        FirebaseApp.configure()
        _ = Firestore.firestore()
    }
    
    // First page setup
    private func setupWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewModel = WelcomeViewModel()
        let viewController = WelcomeViewController(viewModel: viewModel)
        window.rootViewController = UINavigationController(rootViewController: viewController)
        window.makeKeyAndVisible()
        self.window = window
    }
}

