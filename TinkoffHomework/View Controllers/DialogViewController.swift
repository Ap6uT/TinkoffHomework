//
//  DialogViewController.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 30.09.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

class DialogViewController: UIViewController {
    
    var contact: ConversationCellModel?
    
    var messages = [(isMy: Bool, value: MessageCellModel)]()
    
    @IBOutlet weak var tableView: UITableView!
    
    struct TableView {
        struct CellIdentifiers {
            static let myMessageCell = "MyMessageCell"
            static let otherMessageCell = "OtherMessageCell"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let contact = contact {
            navigationItem.title = contact.name
        } else {
            dismiss(animated: true, completion: nil)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.myMessageCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.myMessageCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.otherMessageCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.otherMessageCell)
        
        getData()
    }
    
    func getData() {
        messages = [
            (true, MessageCellModel(text: "Hi)")),
            (true, MessageCellModel(text: "did you like that message app?")),
            (false, MessageCellModel(text: "Hi")),
            (false, MessageCellModel(text: "not really")),
            (false, MessageCellModel(text: "you can do it much better")),
            (false, MessageCellModel(text: "look at this design")),
            (true, MessageCellModel(text: "ok")),
            (true, MessageCellModel(text: "i'll work on it")),
            (false, MessageCellModel(text: "you must")),
            (true, MessageCellModel(text: "it will be much better, you will see")),
        ]
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
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if message.isMy {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.myMessageCell, for: indexPath) as? MyMessageCell else { return UITableViewCell() }
            
            cell.configure(with: message.value)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.otherMessageCell, for: indexPath) as? OtherMessageCell else { return UITableViewCell() }
            
            cell.configure(with: message.value)
            return cell
        }
    }
    
}
