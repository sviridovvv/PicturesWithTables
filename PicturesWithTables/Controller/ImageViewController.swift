//
//  ImageViewController.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 07.02.2022.
//

import UIKit

class ImageViewController: UIViewController {
    
    var image: UIImage?
    
    private var openImage: OpenImage! {
        guard isViewLoaded else { return nil }
        return (view as! OpenImage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = self.image {
            openImage.configure(image: image)
        }
    }
}
