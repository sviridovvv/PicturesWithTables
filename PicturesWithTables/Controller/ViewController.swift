//
//  ViewController.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 29.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var isLoadingMore = false
    
    private var maxImages: Int = 150
    private var dataArray: [ViewModelItem] = []
    {
        didSet {
            self.updateTableView()
            imageView.stopAnimating()
        }
    }
    
    private let viewModel = ViewModel()
    private var imageView: ImageView! {
        guard isViewLoaded else { return nil }
        return (view as! ImageView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
        imageView.configure()
        setBackNavItem()
        addNewData()
        imageView.startAnimating()
    }
    
    // Change back button in navigation
    func setBackNavItem() {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    // Get and add new data of images from server
    func addNewData() {
        viewModel.getDataWithResponse()
    }
    
    // Update tableview
    func updateTableView() {
        DispatchQueue.main.async {
            self.imageView.tableView.reloadData()
        }
    }
    
    // Send image to ImageViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenImage", let indexPath = imageView.tableView.indexPathForSelectedRow {
            let destination = segue.destination as! ImageViewController
            
            if dataArray.indices.contains(indexPath.row) == true {
                destination.image = dataArray[indexPath.row].image
            }
        }
    }
    
    // Don't allow to open ImageViewController when image is not loaded
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let indexPath = self.imageView.tableView.indexPathForSelectedRow, identifier == "OpenImage" {
            if dataArray.indices.contains(indexPath.row) == true {
                return true
            }
        }
        return false
    }
}

extension ViewController {
    
    // Appointment of delegates
    func configure() {
        DispatchQueue.main.async {
            self.viewModel.delegate = self
            self.imageView.delegate = self
            self.imageView.tableView.delegate = self
            self.imageView.tableView.dataSource = self
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    // Set number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    // Set cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.imageView.tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.tag = indexPath.row
        
        print(indexPath.row)
        if cell.tag == indexPath.row {
            cell.configure(item: self.dataArray[indexPath.row])
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {}

extension ViewController: TableViewDataModelDelegate {
    
    // Recieve data from ViewModel
    func didRecieveDataUpdate(data: [ViewModelItem]) {
        dataArray = data
    }
}

extension ViewController: TableViewDataRefresh {
    
    // Recieve command for refresh page
    func didRefreshData(isBool: Bool) {
        if isBool && dataArray.count >= 30 {
            dataArray.removeAll()
            addNewData()
        }
    }
}

extension ViewController {
    
    // Load new images when it scrolled down
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 && !isLoadingMore && dataArray.count < maxImages && !dataArray.isEmpty {
            loadMoreData()
            self.imageView.startAnimating()
        }
    }
    
    // Load new images
    func loadMoreData() {
        if !isLoadingMore {
            isLoadingMore = true
            self.imageView.stopAnimating()
            DispatchQueue.global().async {
                // Fake background loading task for 1 seconds
                sleep(1)
                self.addNewData()
                DispatchQueue.main.async {
                    self.imageView.tableView.reloadData()
                }
                self.isLoadingMore = false
            }
        }
    }
}
