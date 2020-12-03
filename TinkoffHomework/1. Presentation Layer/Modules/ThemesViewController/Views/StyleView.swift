//
//  StyleView.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 05.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

class StyleView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var otherMessageView: UIView!
    @IBOutlet weak var myMessageView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(theme: .classic)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(theme: .classic)
    }
    
    func configure(theme: Theme) {
        Bundle.main.loadNibNamed("StyleView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        myMessageView.layer.cornerRadius = 14
        otherMessageView.layer.cornerRadius = 14
        
        myMessageView.backgroundColor = theme.myMessageColor
        otherMessageView.backgroundColor = theme.otherMessageColor
        contentView.backgroundColor = theme.backgroundColor
        
    }
}
