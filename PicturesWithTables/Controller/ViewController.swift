//
//  ViewController.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 29.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var isLoadingMore = false
    var refreshControl: UIRefreshControl!
    
    private let maxRequest: Int = 5
    private let imagesPerRequest = 30
    private var requestCount = 0
    private var dataArray: [ViewModelItem] = []
    {
        didSet {
            self.updateTableView()
            stopAnimating()
            if dataArray.count % imagesPerRequest == 0 {
                isLoadingMore = false
            }
        }
    }
    
    private var viewModel: ViewModel!
    private var imageView: ImagesView! {
        guard isViewLoaded else { return nil }
        return (view as! ImagesView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        imageView.configure()
        setBackNavItem()
        startAnimating()
        addNewData()
        configureRefreshControll()
    }
    
    // Change back button in navigation
    func setBackNavItem() {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    // Get and add new data of images from server
    func addNewData() {
        if requestCount < maxRequest {
            viewModel.getDataWithResponse()
        }
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
            
            if dataArray.indices.contains(indexPath.row) {
                destination.image = self.dataArray[indexPath.row].image
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
    
    // Start spinner animating
    func startAnimating() {
        imageView.spinner.hidesWhenStopped = true
        imageView.spinner.startAnimating()
    }
    
    // Stop spinner animating
    func stopAnimating() {
        imageView.spinner.stopAnimating()
    }
}

extension ViewController {
    
    // Set view model and appointment of delegates
    func configure() {
        let networkManager = NetworkManager()
        self.viewModel = ViewModel(networkManager: networkManager)
        
        self.viewModel.delegate = self
        self.imageView.tableView.delegate = self
        self.imageView.tableView.dataSource = self
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
        
        if dataArray.indices.contains(indexPath.row) && cell.tag == indexPath.row {
            cell.configure(item: self.dataArray[indexPath.row])
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {}

extension ViewController: TableViewDataModelDelegate {
    
    // Recieve data from ViewModel
    func didRecieveDataUpdate(data: ViewModelItem) {
        dataArray.append(data)
    }
}

extension ViewController {
    
    // Configure refresh control
    func configureRefreshControll() {
        refreshControl = UIRefreshControl()
        refreshControl.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        imageView.tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender: AnyObject) {
        dataArray.removeAll()
        requestCount = 0
        addNewData()
        refreshControl.endRefreshing()
    }
}

extension ViewController {
    
    // Load new images when it scrolled down
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        if deltaOffset <= 0 && !dataArray.isEmpty && !isLoadingMore && dataArray.count >= imagesPerRequest && requestCount < maxRequest {
            self.isLoadingMore = true
            startAnimating()
            loadMoreData()
        }
    }
    
    // Load new images
    func loadMoreData() {
        self.addNewData()
        requestCount += 1
    }
}
