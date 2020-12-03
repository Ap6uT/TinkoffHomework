//
//  MyMessageCell.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 30.09.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

class MyMessageCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet weak var myMessageView: UIView!
    @IBOutlet weak var myMessageText: UILabel!
    
    typealias ConfigurationModel = MessageDB
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myMessageView.layer.cornerRadius = 8
    }
    
    func configure(with model: MessageDB, theme: Theme) {
        myMessageView.backgroundColor = theme.myMessageColor
        self.backgroundColor = theme.backgroundColor
        myMessageText.textColor = theme.myMessageTextColor
        
        myMessageText.text = model.content
    }
}
