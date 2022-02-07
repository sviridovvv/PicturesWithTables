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
        
        displayImage.backgroundColor = .gray
        displayImage.image = image
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
