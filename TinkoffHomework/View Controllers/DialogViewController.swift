//
//  DialogViewController.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 30.09.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

class DialogViewController: UIViewController {
    
    var channel: Channel?
    
    let chat = ChatAPI.shared
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageBarView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    struct TableView {
        struct CellIdentifiers {
            static let myMessageCell = "MyMessageCell"
            static let otherMessageCell = "OtherMessageCell"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let channel = channel {
            navigationItem.title = channel.name
            chat.getChat(for: channel.identifier, complition: { [weak self] in
                self?.tableView.reloadData()
            })
        } else {
            dismiss(animated: true, completion: nil)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        sendButton.layer.cornerRadius = 5
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.myMessageCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.myMessageCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.otherMessageCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.otherMessageCell)
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
            bottomConstraint.constant = view.bounds.height - endFrame.origin.y
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()

            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func sendMessage(_ sender: Any) {
        if let message = textField.text, !message.isEmpty, let channel = channel {
            chat.addMessage(message, forChannel: channel.identifier)
            textField.text = ""
        }
    }
}

// MARK: - TableView Delegate
extension DialogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - TableView DataSource
extension DialogViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chat.messages[indexPath.row]
        
        if message.senderId == chat.getUserId() {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.myMessageCell,
                                                           for: indexPath) as? MyMessageCell
            else { return UITableViewCell() }
            
            cell.configure(with: message)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.otherMessageCell,
                                                           for: indexPath) as? OtherMessageCell
            else { return UITableViewCell() }
            
            cell.configure(with: message)
            return cell
        }
    }
    
}
