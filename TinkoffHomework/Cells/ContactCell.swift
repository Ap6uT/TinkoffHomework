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
    
    
    typealias ConfigurationModel = ConversationCellModel
    
    
    func configure(with model: ConfigurationModel) {
        profileView.layer.cornerRadius = profileView.bounds.width / 2
        
        if !model.name.isEmpty {
            profileLabel.text = String(model.name[model.name.startIndex])
        }
        
        let theme = ThemeManager.currentTheme()
        
        if model.isOnline {
            self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.6, alpha: 0.2)
        } else {
            self.backgroundColor = theme.backgroundColor
        }
        
        nameLabel.text = model.name
        
        if model.message.isEmpty {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont(name: "Arial", size: messageLabel.font.pointSize)
        } else {
            if model.hasUnreadMessage {
                messageLabel.font = UIFont.boldSystemFont(ofSize: messageLabel.font.pointSize)
            }
            messageLabel.text = model.message
        }
        
        let currentDate = dateFormatter(date: Date(), dateFormat: "ddMMYY")
        let messageDate = dateFormatter(date: model.date, dateFormat: "ddMMYY")
        if currentDate == messageDate {
            datetimeLabel.text = dateFormatter(date: model.date, dateFormat: "HH:mm")
        } else {
            datetimeLabel.text = dateFormatter(date: model.date, dateFormat: "dd MMM")
        }
        
    }
    
}
