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
        
        // Set default or image from server
        displayImage.backgroundColor = .gray
        displayImage.image = image
    }
}
