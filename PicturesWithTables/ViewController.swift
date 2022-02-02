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
    var imageDisplay: [DisplayModel] = []
    {
        didSet {
            if imageDisplay.count % 10 == 0 {
            updateTableView()
            }
        }
    }
    let countOfRequest = 2
    
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
                let json = try JSONDecoder().decode(Images.self, from: data)
                for index in json.images {
                    var displayModel = DisplayModel()
                    displayModel.description = index.tags[0].tagDescription
                    self.loadImage(imageURL: index.url) { (image) in
                        displayModel.image = image
                        self.imageDisplay.append(displayModel)
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func loadImage(imageURL: String, completion: @escaping (UIImage) -> ()) {
        
        guard let url = URL(string: imageURL) else { return }
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return imageDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell

            let imageWithDesc = self.imageDisplay[indexPath.row]
            print(indexPath.row)
                cell.descriptionLabel!.text = imageWithDesc.description
                cell.displayImage.image = imageWithDesc.image
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150
        }
}
