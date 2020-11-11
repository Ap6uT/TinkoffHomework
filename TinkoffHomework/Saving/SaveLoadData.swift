//
//  File.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 14.10.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

class SaveLoadData {
    static func saveFile(data: Any, fileName: DataType) -> Bool {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(fileName.rawValue)
            if fileName == .avatar {
                if let image = data as? UIImage {
                    if let pngRepresentation = image.pngData() {
                        do  {
                            try pngRepresentation.write(to: fileURL, options: .atomic)
                            return true
                        } catch let err {
                            print("Saving file resulted in error: ", err)
                        }
                    }
                }
            } else {
                if let text = data as? String {
                    do {
                        try text.write(to: fileURL, atomically: false, encoding: .utf8)
                        return true
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
            }
            return false
        }
        return false
    }
    
    static func loadFile(fileName: DataType) -> Data? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName.rawValue)
            if let fileData = FileManager.default.contents(atPath: fileURL.path) {
                return fileData
            }
        }
        return nil
    }
}
