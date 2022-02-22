//
//  TableView.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 09.02.2022.
//

import UIKit

class ImagesView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // Configuring tableView
    func configure() {
        tableView.rowHeight = 150
        tableView.separatorColor = .black
        tableView.separatorInset = .zero
    }
}
