//
//  EditProfileViewController.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 12.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

enum SavingManager {
    case GDCSaving
    case OperationSaving
}

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profileAvatarView: UIView!
    @IBOutlet weak var profileAvatarImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveByGCDButton: UIButton!
    @IBOutlet weak var saveByOperationButton: UIButton!
    
    var isAvatarChanged: Bool = false
    var isNameChanged: Bool = false
    var isDescriptionChanged: Bool = false
    
    let avatarFile = "avatar"
    
    var user: UserDataModel?
    var complition: (() -> ())?
    
    var isSomethingWasSaved = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        profileAvatarView.layer.cornerRadius = profileAvatarView.frame.width / 2
        profileAvatarImage.layer.cornerRadius = profileAvatarImage.frame.width / 2
        
        saveByGCDButton.layer.cornerRadius = 14
        saveByOperationButton.layer.cornerRadius = 14
        
        let theme = ThemeManager.currentTheme()
        view.backgroundColor = theme.backgroundColor
        saveByGCDButton.backgroundColor = theme.secondaryColor
        saveByOperationButton.backgroundColor = theme.secondaryColor
        
        
        
        descriptionTextView.delegate = self
        
        
        if let user = user {
            if let image = user.avatar {
                show(image: image)
            }
            nameTextField.text = user.name ?? "Name"
            descriptionTextView.text = user.description ?? "Yes"
        }
        isAvatarChanged = false
        lockButtons()


    }
    
    func lockButtons() {
        saveByOperationButton.isEnabled = false
        saveByGCDButton.isEnabled = false
    }
    
    func unlockButtons() {
        saveByOperationButton.isEnabled = true
        saveByGCDButton.isEnabled = true
    }
    
    func show(image: UIImage) {
        isAvatarChanged = true
        unlockButtons()
        profileAvatarImage.image = image
    }
    
    // MARK: - Actions

    @IBAction func editProfileAvatar(_ sender: Any) {
        pickPhoto()
    }
    
    @IBAction func saveByGCD(_ sender: Any) {
        save(by: .GDCSaving)
    }
    
    @IBAction func saveByOperation(_ sender: Any) {
        save(by: .OperationSaving)
    }
    
    @IBAction func exit(_ sender: Any) {
        if isSomethingWasSaved {
            complition?()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changedName(_ sender: Any) {
        isNameChanged = true
        unlockButtons()
    }
    
    
    
    func save(by savingManagerType: SavingManager) {
        lockButtons()

        isSomethingWasSaved = true
        var user = UserDataModel()
        
        if isAvatarChanged {
            user.avatar = profileAvatarImage.image
        }
        if isNameChanged {
            user.name = nameTextField.text!
        }
        if isDescriptionChanged {
            user.description = descriptionTextView.text!
        }
        
        let savingManager: DataManagerProtocol
        if savingManagerType == .GDCSaving {
            savingManager = GCDDataManager()
        } else {
            savingManager = OperationDataManager()
        }
        savingManager.save(user: user, complition: saved(_:))
    }
    
    func saved(_ success: Bool) {
        if success {
            successAlert()
            isAvatarChanged = false
            isNameChanged = false
            isDescriptionChanged = false
        } else {
            failureAlert(by: .GDCSaving)
        }
        unlockButtons()
    }
    
    
    // MARK: - Alerts
    func successAlert() {
        let alert = UIAlertController(title: "Data Saved", message: nil, preferredStyle: .alert)
        let actOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(actOk)
        present(alert, animated: true, completion: nil)
    }
    
    func failureAlert(by savingManager: SavingManager) {
        let alert = UIAlertController(title: "Error", message: "Data not saved", preferredStyle: .alert)
        let actOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(actOk)
        _ = UIAlertAction(title: "Retry", style: .default, handler: { [self] _ in
            save(by: savingManager)
        })
        alert.addAction(actOk)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Text View Delegate
extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        isDescriptionChanged = true
        unlockButtons()
    }
}

// MARK: - Image Picker Controller Delegate

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickPhoto() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actCancel)
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                   self.takePhotoWithCamera()
               })
        alert.addAction(actPhoto)
        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in
                   self.choosePhotoFromLibrary()
               })
        alert.addAction(actLibrary)
        present(alert, animated: true, completion: nil)
    }
    
    func takePhotoWithCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.view.tintColor = view.tintColor
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func choosePhotoFromLibrary () {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let theImage = image {
            show(image: theImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
