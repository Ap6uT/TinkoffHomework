//
//  ThemesViewController.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 05.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

protocol ThemesViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ThemesViewController)
    func listDetailViewControllerDidSave(_ controller: ThemesViewController, save theme: Theme)
}

class ThemesViewController: UIViewController {

    @IBOutlet weak var classicView: StyleView!
    @IBOutlet weak var dayView: StyleView!
    @IBOutlet weak var nightView: StyleView!
    
    @IBOutlet weak var classicButton: UIButton!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var nightButton: UIButton!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var selectedTheme: Theme?
    
    //weak var delegate: ThemesViewControllerDelegate?
    
    var closure: ((_: Theme) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        
        view.backgroundColor = selectedTheme?.backgroundColor
        
        selectView(by: selectedTheme ?? .classic)
        
    }
    
    func configureViews() {
        classicView.configure(theme: .classic)
        dayView.configure(theme: .day)
        nightView.configure(theme: .night)
        
        classicView.layer.cornerRadius = 14
        dayView.layer.cornerRadius = 14
        nightView.layer.cornerRadius = 14
        
        classicView.layer.borderWidth = 5
        classicView.clipsToBounds = true
        dayView.layer.borderWidth = 5
        dayView.clipsToBounds = true
        nightView.layer.borderWidth = 5
        nightView.clipsToBounds = true
        
        classicView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        classicView.isUserInteractionEnabled = true
        dayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        dayView.isUserInteractionEnabled = true
        nightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        nightView.isUserInteractionEnabled = true
    }
    
    func deselectViews() {
        classicView.layer.borderColor = UIColor.gray.cgColor
        dayView.layer.borderColor = UIColor.gray.cgColor
        nightView.layer.borderColor = UIColor.gray.cgColor
    }

    func selectView(by theme: Theme) {
        deselectViews()
        
        switch theme {
        case .classic:
            classicView.layer.borderColor = UIColor.systemBlue.cgColor
        case .day:
            dayView.layer.borderColor = UIColor.systemBlue.cgColor
        case .night:
            nightView.layer.borderColor = UIColor.systemBlue.cgColor
        }
        selectedTheme = theme
    }
    
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        if let theme = Theme(rawValue: gestureRecognizer.view?.tag ?? 1) {
            selectView(by: theme)
        } else {
            selectView(by: .classic)
        }
    }
    
    @IBAction func tapButton(_ sender: UIButton) {
        switch sender {
            case classicButton:
                selectView(by: .classic)
            case dayButton:
                selectView(by: .day)
            case nightButton:
                selectView(by: .night)
            default:
                break
            }
    }
    
    @IBAction func cancel(_ sender: Any) {
        //delegate?.listDetailViewControllerDidCancel(self)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        //delegate?.listDetailViewControllerDidSave(self, save: selectedTheme ?? .classic)
        closure?(selectedTheme ?? .classic)
        navigationController?.popViewController(animated: true)
        
        
    }
    
}
