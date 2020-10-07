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
    
    typealias ConfigurationModel = MessageCellModel
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myMessageView.layer.cornerRadius = 8
        let theme = ThemeManager.currentTheme()
        myMessageView.backgroundColor = theme.myMessageColor
        self.backgroundColor = theme.backgroundColor
        myMessageText.textColor = theme.myMessageTextColor
    }
    
    func configure(with model: MessageCellModel) {
        myMessageText.text = model.text
    }
}
