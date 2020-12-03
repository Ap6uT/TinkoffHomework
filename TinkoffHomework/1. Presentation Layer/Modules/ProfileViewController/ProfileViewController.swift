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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveByGCDButton: UIButton!
    @IBOutlet weak var saveByOperationButton: UIButton!
    
    var isAvatarChanged: Bool = false
    var isNameChanged: Bool = false
    var isDescriptionChanged: Bool = false
    
    let avatarFile = "avatar"
    
    var isInEditingMode = false
    
    var user: IUserDataModel?
    var complition: (() -> Void)?
    
    var isSomethingWasSaved = false
    private let model: IProfileModel
    private let presentationAssembly: IPresentationAssembly
    
    init(model: IProfileModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        super.init(nibName: "Profile", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        hideEditView()
        printLog("View loaded: " + #function)
        
        profilePictureImageView.isHidden = true
        
        profilePictureView.layer.cornerRadius = profilePictureView.frame.width / 2
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
        
        saveButton.layer.cornerRadius = 14
        printLog(saveButton.frame)
        
        let theme = model.getTheme()
        view.backgroundColor = theme.backgroundColor
        saveButton.backgroundColor = theme.secondaryColor
        
        loadUser()
        
        addEmitter()
    }
    
    func configureNavigationBar() {
        let rightBarButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelEdit))

        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.title = "Profile"
    }
    
    func lockButtons() {
        saveByOperationButton.isEnabled = false
        saveByGCDButton.isEnabled = false
    }
    
    func unlockButtons() {
        saveByOperationButton.isEnabled = true
        saveByGCDButton.isEnabled = true
    }
    
    func show(image: UIImage?) {
        if let image = image {
            profilePictureImageView.image = image
            profilePictureImageView.isHidden = false
            profilePictureLabel.text = ""
            isAvatarChanged = true
            unlockButtons()
        } else {
            if let name = nameLabel.text, !name.isEmpty {
                profilePictureLabel.text = String(name[name.startIndex])
            }
        }
    }
    
    func hideEditView() {
        stopShake()
        editProfilePictureButton.isHidden = true
        nameTextField.isHidden = true
        descriptionTextView.isHidden = true
        saveByGCDButton.isHidden = true
        saveByOperationButton.isHidden = true
        
        nameLabel.isHidden = false
        descriptionLabel.isHidden = false
    }
    
    func showEditView() {
        startShake()
        editProfilePictureButton.isHidden = false
        nameTextField.isHidden = false
        descriptionTextView.isHidden = false
        saveByGCDButton.isHidden = false
        saveByOperationButton.isHidden = false
        
        nameLabel.isHidden = true
        descriptionLabel.isHidden = true
        //saveButton.isHidden = true
    }
    
    func loadUser() {
        let operationManager = GCDDataManager()
        
        operationManager.load(complition: { [weak self] user in
            self?.user = user
            self?.showUser(user)
        })
    }
    
    func showUser(_ user: IUserDataModel) {
        nameLabel.text = user.name ?? "Name"
        nameTextField.text = user.name ?? "Name"
        descriptionLabel.text = user.description ?? "yes"
        descriptionTextView.text = user.description ?? "yes"
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
    
    // MARK: - Animations
    
    func startShake() {
        let center = saveButton.center
        
        let moveX = CABasicAnimation(keyPath: "position")
        moveX.fromValue = CGPoint(x: center.x + 10, y: center.y)
        moveX.toValue = CGPoint(x: center.x - 10, y: center.y)

        let moveY = CABasicAnimation(keyPath: "position")
        moveY.fromValue = CGPoint(x: center.x, y: center.y + 10)
        moveY.toValue = CGPoint(x: center.x, y: center.y - 10)
        //moveY.beginTime = 0.15

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = -Double.pi / 20
        rotation.toValue = Double.pi / 20
        rotation.beginTime = 0.15

        let group = CAAnimationGroup()
        group.duration = 0.3
        group.repeatCount = .infinity
        group.autoreverses = true
        group.animations = [moveX, moveY, rotation]

        saveButton.layer.add(group, forKey: "shake")
    }

    func stopShake() {
        view.subviews.forEach({ $0.layer.removeAllAnimations() })
    }
    
    // MARK: - Actions
    @objc func cancelEdit() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func editProfileAvatar(_ sender: Any) {
        pickPhoto()
    }
    
    @IBAction func startEdit(_ sender: Any) {
        if isInEditingMode {
            isInEditingMode = false
            hideEditView()
        } else {
            isInEditingMode = true
            showEditView()
        }
    }
    
    @IBAction func saveByGCD(_ sender: Any) {
        save(by: .GDCSaving)
    }
    
    @IBAction func saveByOperation(_ sender: Any) {
        save(by: .OperationSaving)
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
            user.avatar = profilePictureImageView.image
        }
        if isNameChanged {
            user.name = nameTextField.text ?? "name"
        }
        if isDescriptionChanged {
            user.description = descriptionTextView.text ?? "description"
        }
        
        let savingManager: IDataManager
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
        _ = UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            self?.save(by: savingManager)
        })
        alert.addAction(actOk)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Text View Delegate
extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        isDescriptionChanged = true
        unlockButtons()
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
        
        let netLibrary = UIAlertAction(title: "Choose From Internet", style: .default, handler: { _ in
                   self.choosePhotoFromNet()
               })
        alert.addAction(netLibrary)
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
    
    func choosePhotoFromNet () {
        let controller = presentationAssembly.galleryViewController()
        controller.closure = { [weak self] image in
            if let image = image {
                self?.show(image: image)
            }
        }
        present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
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
