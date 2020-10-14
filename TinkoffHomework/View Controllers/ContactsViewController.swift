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
    
    var contacts = [ConversationCellModel]()
    var contactsByOnline = [(key: Bool, value: [ConversationCellModel])]()
    
    var messagesData = MessagesData.shared
    
    var theme: Theme = .classic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theme = ThemeManager.currentTheme()

        tableView.delegate = self
        tableView.dataSource = self
        
        let cellNib = UINib(nibName: "ContactCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ContactCell")
        getData()
        
    }
    
    struct Employee {
        var name:String
        var year:Int
        var id:Int
    }
    

    func getData() {
        contacts = messagesData.getContacts()
        contactsByOnline = Dictionary(grouping: contacts, by: { $0.isOnline }).sorted(by: { $0.0 && !$1.0 })
        contactsByOnline[1].value = contactsByOnline[1].value.filter( { !$0.message.isEmpty } )
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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDialog" {
            guard let controller = segue.destination as? DialogViewController else { return }
            guard let indexPath = sender as? IndexPath else { return }
            let contact = contactsByOnline[indexPath.section].value[indexPath.row]
            controller.contact = contact
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
    

    
    // наверное есть способ более удачный чем 
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backgroundView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: 40.0))
        backgroundView.backgroundColor = theme.secondaryColor
        return backgroundView as? UITableViewHeaderFooterView
    }*/
}

// MARK: - TableView DataSource
extension ContactsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactsByOnline.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        } else if section == 1 {
            return "History"
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsByOnline[section].value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = contactsByOnline[indexPath.section].value[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell else { return UITableViewCell() }
        cell.configure(with: contact)

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
