//
//  ViewModelItem.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 10.02.2022.
//

import Foundation
import UIKit

struct ViewModelItem: Hashable {
    
    let image: UIImage
    let description: String
    
    init(image: UIImage, description: String) {
        
        self.image = image
        self.description = description
    }
}
