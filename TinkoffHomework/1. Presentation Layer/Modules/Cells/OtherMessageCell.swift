//
//  OtherMessageCell.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 30.09.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

class OtherMessageCell: UITableViewCell {

    @IBOutlet weak var otherMessageView: UIView!
    @IBOutlet weak var otherMessageText: UILabel!
    @IBOutlet weak var otherMessageDateLabel: UILabel!
    @IBOutlet weak var otherMessageNameLabel: UILabel!
    
    typealias ConfigurationModel = MessageDB
    
    override func awakeFromNib() {
        super.awakeFromNib()
        otherMessageView.layer.cornerRadius = 8
    }
    
    func configure(with model: MessageDB, theme: Theme) {
        otherMessageText.text = model.content
        otherMessageNameLabel.text = model.senderName
        otherMessageDateLabel.text = dateFormatter(date: model.created, dateFormat: "HH:mm")
        
        otherMessageView.backgroundColor = theme.otherMessageColor
        self.backgroundColor = theme.backgroundColor
    }
    
}
