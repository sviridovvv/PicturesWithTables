//
//  DisplayImage.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 22.02.2022.
//

import Foundation
import UIKit

class OpenImage: UIView {
    
    @IBOutlet weak var displayImage: UIImageView!
    
    func configure(image: UIImage) {
        displayImage.image = image
    }
}
