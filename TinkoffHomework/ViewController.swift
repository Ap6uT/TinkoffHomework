//
//  ViewController.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 14.09.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        printLog("View loaded: " + #function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printLog("View moved from disappered/disappearing to appearing: " + #function)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        printLog("View moved from appearing to appeared: " + #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printLog("View is about to layout subviews: " + #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printLog("View has just laid out subviews: " + #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printLog("View moved from appered/appearing to disappearing: " + #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printLog("View moved from disappearing to disappeared: " + #function)
    }

}

