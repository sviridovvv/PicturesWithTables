//
//  ImageManager.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 10.02.2022.
//

import UIKit

class NetworkManager {
    
    // Load image from URL
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
    
    // Load data of images from server
    func loadData(completion: @escaping (ImageModel) -> ()) {
        
        guard let url = URL(string: "https://api.waifu.im/random?many=true") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error)
            }
            
            guard let data = data else { return }
            
            do {
                let json = try JSONDecoder().decode(ImageModel.self, from: data)
                completion(json)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
