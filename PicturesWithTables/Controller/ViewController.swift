//
//  ViewController.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 29.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let maxImages = 150
    var imageDataArray: [Image] = []
    {
        didSet {
            if imageDataArray.count == maxImages {
                stopAnimating()
            }
        }
    }
    var cacheImageArray: [Int : UIImage] = [:]
    {
        didSet {
            if imageDataArray.count == cacheImageArray.count {
                self.updateTableView()
            }
        }
    }
    
    private var networkManager = NetworkManager()
    private var imageView: ImageView! {
            guard isViewLoaded else { return nil }
            return (view as! ImageView)
        }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setBackNavItem()
        startAnimating()
        addNewData()
        updateTableView()
    }
    
    func setBackNavItem() {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    func startAnimating() {
        
        DispatchQueue.main.async {
            self.imageView.spinner.hidesWhenStopped = true
            self.imageView.spinner.startAnimating()
        }
    }
    
    
    func stopAnimating() {
        
        DispatchQueue.main.async {
            self.imageView.spinner.stopAnimating()
        }
    }
    
    func addNewData() {
        
        networkManager.loadData { imageModel in
            for imageData in imageModel.images {
                self.imageDataArray.append(imageData)
            }
            self.updateTableView()
        }
    }
    
    func updateTableView() {

        DispatchQueue.main.async {
            self.imageView.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "OpenImage", let indexPath = imageView.tableView.indexPathForSelectedRow {
            let destination = segue.destination as! ImageViewController
            
            if cacheImageArray[indexPath.row] != nil {
                destination.image = cacheImageArray[indexPath.row]!
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        if let indexPath = self.imageView.tableView.indexPathForSelectedRow, identifier == "OpenImage" {
            if cacheImageArray[indexPath.row] != nil {
                return true
            }
        }
        return false
    }
}

extension ViewController {
    
    func configure() {
        
        imageView.tableView.delegate = self
        imageView.tableView.dataSource = self
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imageDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.imageView.tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        
        cell.displayImage.layer.cornerRadius = 12
        cell.displayImage.layer.masksToBounds = true
        
        cell.descriptionLabel.text = imageDataArray[indexPath.row].tags[0].tagDescription
        cell.displayImage.image = nil
        cell.displayImage.backgroundColor = .gray
        
        if cacheImageArray[indexPath.row] == nil {
            networkManager.loadImage(index: indexPath.row, imageURL: imageDataArray[indexPath.row].url) {
                [weak self] index, image in
                
                let tempImage = image.resize(image)
                
                if (cell.tag == indexPath.row) {
                    cell.displayImage.image = tempImage
                }
                self?.cacheImageArray.updateValue(tempImage, forKey: index)
            }
        } else {
            cell.displayImage.image = cacheImageArray[indexPath.row]
        }
        
        if imageDataArray.count < indexPath.row + 2 && imageDataArray.count < maxImages && imageDataArray.count == cacheImageArray.count {
            addNewData()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}