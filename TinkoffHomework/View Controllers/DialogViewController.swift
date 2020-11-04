//
//  DialogViewController.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 30.09.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit
import CoreData

class DialogViewController: UIViewController {
    
    var channel: ChannelDB?
    
    var coreDataStack = CoreDataStack.shared
    
    let chat = ChatAPI.shared
    
    lazy var fetchedResultsController: NSFetchedResultsController<MessageDB> = {
      
        let context = coreDataStack.mainContext

        let fetchRequest = NSFetchRequest<MessageDB>(entityName: "MessageDB")
        
        if let channel = channel {
            fetchRequest.predicate = NSPredicate(format: "channel.identifier == %@", "\(String(describing: channel.identifier))")
        } else {
            fetchRequest.predicate = NSPredicate(format: "channel.identifier == %@", "error request")
        }

        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let fetchedResultsController = NSFetchedResultsController<MessageDB>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

        return fetchedResultsController
    }()
        
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
            fetchedResultsController.delegate = self
            do {
                try fetchedResultsController.performFetch()
            } catch {
                print(error)
            }
            
            navigationItem.title = channel.name
            chat.getChat(for: channel.identifier, complition: { [weak self] in
                self?.tableView.reloadData()
                
                if let self = self {
                    let chatRequest = ChatRequest(coreDataStack: self.coreDataStack)
                    chatRequest.makeMessagesRequest(channelID: channel.identifier, messages: self.chat.messages)
                }
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
        let count = fetchedResultsController.fetchedObjects?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = fetchedResultsController.object(at: indexPath)
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

// MARK: - NSFetchedResultsControllerDelegate
extension DialogViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            fatalError("Unknown changes")
        }
    }
        
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
