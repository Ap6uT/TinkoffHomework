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
    
    typealias ConfigurationModel = MessageCellModel
    
    override func awakeFromNib() {
        super.awakeFromNib()
        otherMessageView.layer.cornerRadius = 8
        
        let theme = ThemeManager.currentTheme()
        otherMessageView.backgroundColor = theme.otherMessageColor
        self.backgroundColor = theme.backgroundColor
    }
    
    func configure(with model: MessageCellModel) {
        otherMessageText.text = model.text
    }
    
}
