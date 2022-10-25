//
//  ProfileSettingsViewController.swift
//  FlickrApi
//
//  Created by GÜRHAN YUVARLAK on 19.10.2022.
//

import UIKit
import Kingfisher

final class ProfileSettingsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, AlertPresentable {
    //MARK: - Properties
    private let viewModel: ProfileSettingsViewModel
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    //MARK: - Init
    init(viewModel: ProfileSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageViewConfigure()
        viewModel.delegate = self
        viewModel.fetchImage()
        usernameTextField.text = viewModel.fetchUsername()
    }
    
    //MARK: - Methods
    private func avatarImageViewConfigure() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.borderColor = UIColor(red: 66/255, green: 95/255, blue: 87/255, alpha: 1).cgColor
        avatarImageView.layer.borderWidth = 1.0
        avatarImageView.clipsToBounds = true
    }
    
    @IBAction func didTapImageView(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        viewModel.saveImagePicker(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        guard let text = usernameTextField.text else { return }
        viewModel.save(username: text)
    }
}

extension ProfileSettingsViewController: ProfileSettingsProtocol {
    func didErrorOccurred(_ error: Error) {
        showError(error)
    }
    
    func didFetchImage(_ image: URL) {
        avatarImageView.kf.setImage(with: image)
    }
    
    func didSaveUser() {
        showAlert(title: "Success", message: "Updated your user info.")
    }
    
}
