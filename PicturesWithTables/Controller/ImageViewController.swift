//
//  ImageViewController.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 07.02.2022.
//

import UIKit

class ImageViewController: UIViewController {
    
    var image: UIImage?
    
    @IBOutlet weak var displayImage: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set image
        displayImage.image = image
    }
}
