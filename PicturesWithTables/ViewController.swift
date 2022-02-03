//
//  ViewController.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 29.01.2022.
//

import UIKit

class ViewController: UIViewController {
    let exampleText = ["fisrt", "second", "third", "four"]
    let examplePicture = [UIImage(systemName: "pencil"), UIImage(systemName: "folder"), UIImage(systemName: "doc"), UIImage(systemName: "book")]
    var imageModel: [Image] = []
    {
        didSet
        {
            //            addToCacheImage()
        }
    }
    var cacheImage: [Int : UIImage] = [:]
    {
        didSet
        {
//            print(cacheImage.count)
            //                        updateTableView()
        }
    }
    
    let countOfRequest = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        addNewImage()
        // Do any additional setup after loading the view.
    }
    
    func addNewImage() {
        for _ in 0..<countOfRequest {
            getImageModel()
        }
    }
    
    func getImageModel() {
        
        guard let url = URL(string: "https://api.waifu.im/random?many=true") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error)
            }
            
            guard let data = data else { return }
            
            do {
                let json = try JSONDecoder().decode(ImageModel.self, from: data)
                for index in json.images {
                    self.imageModel.append(index)
                }
                self.updateTableView()
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadImage(index: Int, imageURL: String, completion: @escaping (Int, UIImage) -> ()) {
        
        let concSync = DispatchQueue(label: "con", attributes: .concurrent)
        concSync.async {
            guard let url = URL(string: imageURL) else { return }
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(index, image)
                    }
                }
            }
        }
    }
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return imageModel.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        cell.tag = indexPath.row
        
        cell.displayImage.layer.cornerRadius = 12
        cell.displayImage.layer.masksToBounds = true
        
        cell.descriptionLabel.text = imageModel[indexPath.row].tags[0].tagDescription
        cell.displayImage.image = UIImage(systemName: "folder")
        
        if cacheImage[indexPath.row] == nil {
            self.loadImage(index: indexPath.row, imageURL: imageModel[indexPath.row].url) { index, image in
                //                print("\(cell.tag) : \(indexPath.row)")
                if (cell.tag == indexPath.row) {
                    cell.displayImage.image = image
                }
                if self.cacheImage[indexPath.row] == nil {
                    self.cacheImage.updateValue(image, forKey: index)
                }
            }
        } else {
            cell.displayImage.image = cacheImage[indexPath.row]
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
