//
//  ContactsViewController.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 29.09.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createChannelButton: UIButton!
    
    var theme: Theme = .classic
    
    let chat = ChatAPI.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theme = ThemeManager.currentTheme()

        tableView.delegate = self
        tableView.dataSource = self
        
        let cellNib = UINib(nibName: "ContactCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ContactCell")
        
        createChannelButton.layer.cornerRadius = 25

        //chat.addChannel("About guitars")
        chat.getChannels { [weak self] in
            self?.tableView.reloadData()
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
            let channel = chat.channels[indexPath.row]
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
        return chat.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channel = chat.channels[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell else { return UITableViewCell() }
        cell.configure(with: channel)

        return cell
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
