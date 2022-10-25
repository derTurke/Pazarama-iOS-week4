//
//  WelcomeViewModel.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 17.10.2022.
//

import Foundation
import FirebaseRemoteConfig
import UIKit

enum WelcomeViewModelChange {
    case didErrorOccurred(_ error: Error)
}

final class WelcomeViewModel {
    // Change Handler
    var changeHandler: ((WelcomeViewModelChange) -> Void)?
    
    var welcomeImage: URL?
    
    var welcomeLabel: String?
    
    // Fetch Remote Config
    func fetchRemoteConfig(completion: @escaping ([String: Any]?) -> Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        //remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        remoteConfig.fetch { status, error -> Void in
            if status == .success {
                remoteConfig.activate { allRemote, error in
                    if let error = error {
                        self.changeHandler?(.didErrorOccurred(error))
                        return
                    }
                    guard remoteConfig["WelcomeImageURL"].stringValue != nil, let imageUrl = remoteConfig["WelcomeImageURL"].stringValue else {
                        return
                    }
                    
                    guard remoteConfig["WelcomeLabel"].stringValue != nil, let label = remoteConfig["WelcomeLabel"].stringValue else {
                        return
                    }
                    
                    var remoteArray = [String: Any]()
                    remoteArray["welcomeImage"] = imageUrl
                    remoteArray["welcomeLabel"] = label
                    remoteArray["signUpBool"] = remoteConfig["SignUpBool"].boolValue
                    
                    DispatchQueue.main.async {
                        completion(remoteArray)
                    }
                }
            } else {
                guard let error = error else {
                    return
                }
                self.changeHandler?(.didErrorOccurred(error))
            }
        }
    }
    
    // Presentation Controller
    func presentationController(title: String?) -> UIViewController {
        guard let title = title else {
            fatalError("Error! Title is empty.")
        }
        let viewModel = AuthViewModel()
        let viewController = AuthViewController(viewModel: viewModel, titleText: title)
        return viewController
    }
    
}
