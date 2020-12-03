//
//  OperationLoading.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 14.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

class OperationLoading: Operation {
    var data: Data?
    let fileName: DataType
    
    init(fileName: DataType) {
        self.fileName = fileName
    }
    
    override func main() {

        if isCancelled {
            return
        }
        data = SaveLoadData.loadFile(fileName: fileName)
    }
}
