//
//  ContactsViewController.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 29.09.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createChannelButton: UIButton!
    
    var theme: Theme = .classic
    
    var coreDataStack = CoreDataStack.shared
    
    let chat = ChatAPI.shared
    
    lazy var fetchedResultsController: NSFetchedResultsController<ChannelDB> = {
      
        let context = coreDataStack.mainContext

        let fetchRequest = NSFetchRequest<ChannelDB>(entityName: "ChannelDB")

        let sortDescriptor = NSSortDescriptor(key: "lastActivity", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController<ChannelDB>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

        return fetchedResultsController
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theme = ThemeManager.currentTheme()

        tableView.delegate = self
        tableView.dataSource = self
        
        let cellNib = UINib(nibName: "ContactCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ContactCell")
        
        createChannelButton.layer.cornerRadius = 25

        //coreDataStack.didUpdateDataBase = { stack in
        //    stack.printDatabaseStatistics()
        //}
        
        coreDataStack.enableObservers()
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
        chat.getChannels { [weak self] in
            self?.tableView.reloadData()
            
            if let self = self {
                let chatRequest = ChatRequest(coreDataStack: self.coreDataStack)
                chatRequest.makeChannelsRequest(channels: self.chat.channels)
                
                if let objects = self.fetchedResultsController.fetchedObjects {
                    for object in objects {
                        if !self.chat.isChannelExist(channelId: object.identifier) {
                            self.deleteChannel(object)
                        }
                    }
                }
            }
        }
    }

    func changeTheme(_ theme: Theme) {
        self.theme = theme
        
        ThemeManager.applyTheme(theme: theme)
        
        // очень странный костыль для перерисовки navigation bar
        // наверняка есть получше
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func deleteChannel(_ channel: ChannelDB) {
        let context = coreDataStack.mainContext
        context.delete(channel)
    }
    
    // MARK: - Actions
    @IBAction func createChannel(sender: AnyObject) {
        let alertController = UIAlertController(title: "Create new channel", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Enter channel name"
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default, handler: { [weak self] _ -> Void in
            let textField = alertController.textFields![0] as UITextField
            if let channelName = textField.text, !channelName.isEmpty {
                self?.chat.addChannel(channelName)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDialog" {
            guard let controller = segue.destination as? DialogViewController else { return }
            guard let indexPath = sender as? IndexPath else { return }
            let channel = fetchedResultsController.object(at: indexPath)
            controller.channel = channel
        } else if segue.identifier == "ChangeTheme" {
            guard let controller = segue.destination as? ThemesViewController else { return }
            //controller.delegate = self
            controller.selectedTheme = theme
            controller.closure = { [weak self] theme in
                self?.changeTheme(theme)
            }
        }
    }
}

// MARK: - TableView Delegate
extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowDialog", sender: indexPath)
    }
}

// MARK: - TableView DataSource
extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = fetchedResultsController.fetchedObjects?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channel = fetchedResultsController.object(at: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell else { return UITableViewCell() }
        cell.configure(with: channel)

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            //self.Items.remove(at: indexPath.row)
            let channel = self.fetchedResultsController.object(at: indexPath)
            self.chat.removeChat(with: channel.identifier)
            self.deleteChannel(channel)
            complete(true)
        }
            
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ContactsViewController: NSFetchedResultsControllerDelegate {
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

/*
// MARK: - Themes Delegate
extension ContactsViewController: ThemesViewControllerDelegate {
    func listDetailViewControllerDidCancel(_ controller: ThemesViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewControllerDidSave(_ controller: ThemesViewController, save theme: Theme) {
        navigationController?.popViewController(animated: true)
        changeTheme(theme)
    }
    
}
*/
