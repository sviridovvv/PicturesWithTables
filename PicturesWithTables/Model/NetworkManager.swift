//
//  ImageManager.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 10.02.2022.
//

import UIKit

class NetworkManager: NetworkManagerProtocol {
    var a = 4
    // Load image from URL
    func loadImage(imageData: Image, completion: @escaping (Image, UIImage) -> ()) {
        let concSync = DispatchQueue(label: "con", attributes: .concurrent)
        concSync.async {
            guard let url = URL(string: imageData.url) else { return }
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(imageData,image)
                    }
                }
            }
        }
    }
    
    // Load data of images from server
    func sendRequest(completion: @escaping (ImageModel) -> ()) {
        guard let url = URL(string: "https://api.waifu.im/random?many=true") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error)
            }
            
            guard let data = data else { return }
            
            do {
                let data = try JSONDecoder().decode(ImageModel.self, from: data)
                completion(data)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}

protocol NetworkManagerProtocol {
    
    func loadImage(imageData: Image, completion: @escaping (Image, UIImage) -> ())
    func sendRequest(completion: @escaping (ImageModel) -> ())
}
