//
//  ViewModel.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 10.02.2022.
//

import Foundation

class ViewModel {
    
    private lazy var networkManager = getNetworkManager()

    weak var delegate: TableViewDataModelDelegate?
    
    // Get data server from NetworkManager
    func getDataWithResponse() {
        var imageModel: ImageModel?
        {
            didSet
            {
                createViewModelItems(data: imageModel!)
            }
        }

        networkManager.requestData { data in
            imageModel = data
        }
    }
    
    // Create items with image and description and send them to ViewController
    func createViewModelItems(data: ImageModel) {
        for item in data.images {
            networkManager.loadImage(imageData: item) { imageData, image in
                let resizeImage = image.resize(image)
                self.delegate?.didRecieveDataUpdate(data: ViewModelItem(image: resizeImage, description: imageData.tags[0].tagDescription))
            }
        }
    }
}

protocol TableViewDataModelDelegate: AnyObject {
    
    // Send array of items to ViewController
    func didRecieveDataUpdate(data: ViewModelItem)
}

extension ViewModel: NetworkManagerProtocol {
    func getNetworkManager() -> NetworkManager {
        return NetworkManager()
    }
}

protocol GetViewModelProtocol {
    func getViewModel() -> ViewModel
}
