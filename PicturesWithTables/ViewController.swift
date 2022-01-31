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
    var images: [UIImage] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getImageModel()
        // Do any additional setup after loading the view.
    }
    
    func getImageModel() {
        guard let url = URL(string: "https://api.waifu.im/random?many=true") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error)
            }
            
            guard let data = data else { return }
            //            print(data)
            
            do {
                let json = try JSONDecoder().decode(Images.self, from: data)
                for index in json.images {
                    self.imageModel.append(index)
                }
                self.loadImages()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func loadImages() {
        
        for index in imageModel {
            
            guard let url = URL(string: index.url) else { return }
            
//            DispatchQueue.global().async { [ weak self ] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.images.append(image)
                        }
                    }
                }
//            }
            print(self.images.count)
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.descriptionLabel.text = imageModel[indexPath.row].tags[0].tagDescription
        cell.displayImage.image = images[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 128
    //    }
}
