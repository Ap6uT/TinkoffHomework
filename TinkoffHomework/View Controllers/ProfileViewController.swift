//
//  ViewController.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 14.09.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePictureView: UIView!
    @IBOutlet weak var profilePictureLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var editProfilePictureButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //print(saveButton.frame)
        // view еще не загрузилось, saveButton = nil, выдаст ошибку
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printLog("View loaded: " + #function)
        
        profilePictureImageView.isHidden = true
        
        profilePictureView.layer.cornerRadius = profilePictureView.frame.width / 2
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
        
        saveButton.layer.cornerRadius = 14
        print(saveButton.frame)
        
        let theme = ThemeManager.currentTheme()
        view.backgroundColor = theme.backgroundColor
        saveButton.backgroundColor = theme.secondaryColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printLog("View moved from disappered/disappearing to appearing: " + #function)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        printLog("View moved from appearing to appeared: " + #function)
        print(saveButton.frame)
        // если размер экрана отличается от того, что был в storyboard,
        // то frame в данном случае будет отличаться от того,
        // который был загружен во viewDidLoad
        // и так как кнопка "привязана" к низу экрана и при одинаковой ширине экранов,
        // но разной высоте - изменится координата y
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printLog("View is about to layout subviews: " + #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printLog("View has just laid out subviews: " + #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printLog("View moved from appered/appearing to disappearing: " + #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printLog("View moved from disappearing to disappeared: " + #function)
    }
    
    func show(image: UIImage) {
        profilePictureImageView.image = image
        profilePictureImageView.isHidden = false
        profilePictureLabel.text = ""
    }
    
    // MARK:- Actions
    
    @IBAction func editProfilePicture(_ sender: Any) {
        pickPhoto()
    }
    
    @IBAction func cancelEdit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - Image Picker Controller Delegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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




