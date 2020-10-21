//
//  ContactCell.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 29.09.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileLabel: UILabel!
    
    typealias ConfigurationModel = Channel
    
    func configure(with model: Channel) {
        profileView.layer.cornerRadius = profileView.bounds.width / 2
        
        if !model.name.isEmpty {
            profileLabel.text = String(model.name[model.name.startIndex])
        }
        
        let theme = ThemeManager.currentTheme()
        self.backgroundColor = theme.backgroundColor
        
        nameLabel.text = model.name
        
        if let message = model.lastMessage {
            messageLabel.text = message
            if let lastActivity = model.lastActivity {
                let currentDate = dateFormatter(date: Date(), dateFormat: "ddMMYY")
                let messageDate = dateFormatter(date: lastActivity, dateFormat: "ddMMYY")
                if currentDate == messageDate {
                    datetimeLabel.text = dateFormatter(date: lastActivity, dateFormat: "HH:mm")
                } else {
                    datetimeLabel.text = dateFormatter(date: lastActivity, dateFormat: "dd MMM")
                }
            } else {
                datetimeLabel.text = ""
            }
            
        } else {
            datetimeLabel.text = ""
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont(name: "Arial", size: messageLabel.font.pointSize)
        }
        
    }
}
