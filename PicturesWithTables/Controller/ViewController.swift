//
//  ViewController.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 29.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let request = 2
    private var countOfImage: Int {
        return request * 30
    }
    
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
        imageView.startAnimating()
        imageView.configureRefreshControll()
        addNewData()
    }
    
    // Change back button in navigation
    func setBackNavItem() {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    // Get and add new data of images from server
    func addNewData() {
        viewModel.setDataWithResponse()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.imageView.tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.tag = indexPath.row

        if cell.tag == indexPath.row {
            cell.configure(item: self.dataArray[indexPath.row])
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {}

extension ViewController: TableViewDataModelDelegate {
    
    func didRecieveDataUpdate(data: [ViewModelItem]) {
        dataArray = data
    }
}

extension ViewController: TableViewDataRefresh {
    
    func didRefreshData(isBool: Bool) {
        if isBool && dataArray.count >= 30 {
            dataArray.removeAll()
            addNewData()
        }
    }
}
