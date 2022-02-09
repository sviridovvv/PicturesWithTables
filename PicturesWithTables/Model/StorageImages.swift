//
//  StorageManager.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 10.02.2022.
//

import UIKit

class StorageImages {
    
    var imageDataArray: [Image] = [] {
        didSet
        {
            print(imageDataArray.count)
        }
    }
    
}
