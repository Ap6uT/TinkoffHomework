//
//  OperationSaving.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 14.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation


class OperationSaving: Operation {
    let data: Any
    let fileName: DataType
    
    var success: Bool = false
    
    init(data: Any, fileName: DataType) {
        self.data = data
        self.fileName = fileName
    }
    
    override func main() {

        if isCancelled {
            return
        }
        
        success = SaveLoadData.saveFile(data: data, fileName: fileName)
    }
}
