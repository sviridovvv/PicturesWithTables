//
//  TableView.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 09.02.2022.
//

import UIKit

class ImageView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var refreshControl:UIRefreshControl!
    weak var delegate: TableViewDataRefresh?
    var isLoading = false
    
    // Configuring tableView
    func configure() {
        
        tableView.rowHeight = 150
        tableView.separatorColor = .black
        tableView.separatorInset = .zero
        configureRefreshControll()
//        scrollViewDidScroll(tableView)
    }
    
    // Start spinner animating
    func startAnimating() {
        DispatchQueue.main.async {
            self.spinner.hidesWhenStopped = true
            self.spinner.startAnimating()
        }
    }
    
    // Stop spinner animating
    func stopAnimating() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
    
    // Configure refresh control
    func configureRefreshControll() {
        refreshControl = UIRefreshControl()
        refreshControl.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        refreshBegin(refreshEnd: {(x:Int) -> () in
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
    
    func refreshBegin(refreshEnd: @escaping (Int) -> ()) {
        DispatchQueue.main.async {
            self.delegate?.didRefreshData(isBool: self.refreshControl.isRefreshing)
            sleep(1)
        }
        DispatchQueue.main.async {
            refreshEnd(0)
        }
    }
}

protocol TableViewDataRefresh: AnyObject {
    
    // Send command to ViewController for refresh page
    func didRefreshData(isBool: Bool)
}
