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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let otherDate = formatter.date(from: "2020/09/29 00:00") ?? Date()
        
        contacts = [
            ConversationCellModel(name: "Kratos", message: "BOI", date: otherDate, isOnline: true, hasUnreadMessage: true),
            ConversationCellModel(name: "Gordon Freeman", message: "", date: date, isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "Adam Jensen", message: "I Never Asked For This", date: date, isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "Space Module", message: "SPAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACE", date: date, isOnline: true, hasUnreadMessage: true),
            ConversationCellModel(name: "Hodor", message: "Hodor", date: otherDate, isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "GLaDOS", message: "I'm a Potato", date: otherDate, isOnline: true, hasUnreadMessage: true),
            ConversationCellModel(name: "Cole Phelps", message: "Doubt", date: date, isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "Morgan Yu", message: "", date: otherDate, isOnline: true, hasUnreadMessage: false),
            ConversationCellModel(name: "Geralt", message: "hmmm", date: date, isOnline: true, hasUnreadMessage: true),
            ConversationCellModel(name: "Connor RK800", message: "I'm sure we used to be friends before I was reset", date: otherDate, isOnline: true, hasUnreadMessage: true),
            
            ConversationCellModel(name: "Chell", message: "", date: date, isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "DoomGuy", message: "", date: otherDate, isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "The Weighted Companion Cube", message: "why?", date: otherDate, isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "Big Smoke", message: "All we had to do was follow the damn train CJ!", date: date, isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "Toad", message: "Thank You Mario, But Our Princess is in Another Castle", date: otherDate, isOnline: false, hasUnreadMessage: true),
            ConversationCellModel(name: "G-Man", message: "Rise and shine", date: date, isOnline: false, hasUnreadMessage: true),
            ConversationCellModel(name: "Andrew Ryan", message: "A man chooses...a slave obeys", date: otherDate, isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "Commander Shepard", message: "I’m Commander Shepard, and this is my favorite store on the Citadel!", date: date, isOnline: false, hasUnreadMessage: false),
            ConversationCellModel(name: "Vaas", message: "Did I ever tell you the definition of insanity?", date: otherDate, isOnline: false, hasUnreadMessage: true),
            ConversationCellModel(name: "Cave Johnson", message: "Science isn’t about why! It’s about why not!", date: date, isOnline: false, hasUnreadMessage: true),
        ]
        contactsByOnline = Dictionary(grouping: contacts, by: { $0.isOnline }).sorted(by: { $0.0 && !$1.0 })

    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDialog" {
            guard let controller = segue.destination as? DialogViewController else { return }
            guard let indexPath = sender as? IndexPath else { return }
            let contact = contactsByOnline[indexPath.section].value[indexPath.row]
            controller.contact = contact
        }
    }


}


// MARK: - TableView Delegate
extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowDialog", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let contact = contactsByOnline[indexPath.section].value[indexPath.row]
        
        if contact.message.isEmpty && !contact.isOnline {
            return 0.0
        } else {
            return tableView.rowHeight
        }
    }
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
        if contact.message.isEmpty && !contact.isOnline {
            let emptyCell = UITableViewCell()
            return emptyCell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactCell else { return UITableViewCell() }
        cell.configure(with: contact)

        return cell
    }
    
   
    
}
