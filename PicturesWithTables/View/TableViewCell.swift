//
//  TableViewCell.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 30.01.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(item: ViewModelItem) {
        displayImage.layer.cornerRadius = 12
        displayImage.layer.masksToBounds = true
        self.selectionStyle = .none
        
        displayImage.image = nil
        descriptionLabel.text = nil
        displayImage.image = item.image
        descriptionLabel.text = item.description
    }
}
