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
    
    var user = UserDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printLog("View loaded: " + #function)
        
        profilePictureImageView.isHidden = true
        
        profilePictureView.layer.cornerRadius = profilePictureView.frame.width / 2
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
        
        saveButton.layer.cornerRadius = 14
        printLog(saveButton.frame)
        
        let theme = ThemeManager.currentTheme()
        view.backgroundColor = theme.backgroundColor
        saveButton.backgroundColor = theme.secondaryColor
        
        loadUser()
    }
    
    func show(image: UIImage?) {
        if let image = image {
            profilePictureImageView.image = image
            profilePictureImageView.isHidden = false
            profilePictureLabel.text = ""
        } else {
            if let name = nameLabel.text, !name.isEmpty {
                profilePictureLabel.text = String(name[name.startIndex])
            }
        }
    }
    
    func loadUser() {
        let operationManager = GCDDataManager()
        
        operationManager.load(complition: { [weak self] user in
            self?.user = user
            self?.showUser(user)
        })
    }
    
    func showUser(_ user: UserDataModel) {
        nameLabel.text = user.name ?? "Name"
        descriptionLabel.text = user.description ?? "yes"
        show(image: user.avatar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printLog("View moved from disappered/disappearing to appearing: " + #function)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        printLog("View moved from appearing to appeared: " + #function)
        printLog(saveButton.frame)
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
    
    // MARK: - Actions
    @IBAction func cancelEdit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEditProfile" {
            guard let controller = segue.destination as? EditProfileViewController else { return }
            controller.user = user
            controller.complition = { [weak self] in
                self?.loadUser()
            }
        }
    }
}
