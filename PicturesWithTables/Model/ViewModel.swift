//
//  ViewModel.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 10.02.2022.
//

import Foundation

class ViewModel {
    
    weak var delegate: TableViewDataModelDelegate?
    private var networkManager = NetworkManager()


    func setDataWithResponse() {
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
    
    func createViewModelItems(data: ImageModel) {
        var viewModelItems: [ViewModelItem] = []
        {
            didSet
            {
                delegate?.didRecieveDataUpdate(data: viewModelItems)
            }
        }
        
        for item in data.images {
                networkManager.loadImage(imageData: item) { imageData, image in
                    let resizeImage = image.resize(image)
                    viewModelItems.append(ViewModelItem(image: resizeImage, description: imageData.tags[0].tagDescription))
            }
        }
    }
}

protocol TableViewDataModelDelegate: AnyObject {
    
    func didRecieveDataUpdate(data: [ViewModelItem])
}
