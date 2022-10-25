//
//  AuthViewController.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 18.10.2022.
//

import UIKit

final class AuthViewController: UIViewController, AlertPresentable {
    enum AuthType: String {
        case signIn = "Sign In"
        case signUp = "Sign Up"
            
        init(text: String) {
            switch text {
                case "Sign In":
                    self = .signIn
                case "Sign Up":
                    self = .signUp
                default:
                    self = .signIn
            }
        }
    }
    //MARK: - Properties
    private let viewModel: AuthViewModel
    var titleText: String
    var authType: AuthType?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Init
    init(viewModel: AuthViewModel, titleText: String) {
        self.viewModel = viewModel
        self.titleText = titleText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAuthView()
        changeHandler()
    }
    
    // MARK: - Methods
    //Setup AuthView settings
    private func setupAuthView(){
        titleLabel.text = titleText
        button.setTitle(titleText, for: .normal)
        button.tintColor = .white
        imageView.image = UIImage(named: "auth")
        authType = AuthType(text: titleText)
    }
    
    //Auth button settings
    @IBAction func didTapAuthButton(_ sender: UIButton) {
        guard let credential = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        switch authType {
            case .signIn:
                viewModel.signIn(credential: credential, password: password) { [weak self] in
                    guard let self = self else { return }
                    let vc = MainTabBarController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            case .signUp:
                viewModel.signUp(credential: credential, password: password) { [weak self] in
                    guard let self = self else { return }
                    let vc = MainTabBarController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            case .none:
                break;
        }
    }
    
    //Change Handler
    private func changeHandler(){
        viewModel.changeHandler = { change in
            switch change {
                case .didErrorOccurred(let error):
                    self.showError(error)
            }
        }
    }
    
    

}
