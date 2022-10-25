//
//  WelcomeViewController.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 17.10.2022.
//

import UIKit
import Kingfisher

final class WelcomeViewController: UIViewController, AlertPresentable {
    //MARK: - Properties
    private var viewModel: WelcomeViewModel
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK: - Init
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
        fetchRemoteConfig()
    }
    
    //MARK: - Methods
    private func fetchRemoteConfig() {
        viewModel.fetchRemoteConfig { dictionary in
            self.imageView.kf.setImage(with: URL(string: dictionary?["welcomeImage"] as! String))
            self.welcomeLabel.text = dictionary?["welcomeLabel"] as? String
            self.signUpButton.isHidden = (dictionary?["signUpBool"] as? Bool)!
        }
    }
    
    private func changeHandler() {
        viewModel.changeHandler = { change in
            switch change {
                case .didErrorOccurred(let error):
                        self.showError(error)
            }
        }
    }
    
    @IBAction func didTapAuthButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(viewModel.presentationController(title: sender.currentTitle), animated: true)
    }
    
    
}
