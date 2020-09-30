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
    }
    
    func configure(with model: MessageCellModel) {
        myMessageText.text = model.text
    }
}
