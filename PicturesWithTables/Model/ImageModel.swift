//
//  ImageModel.swift
//  PicturesWithTables
//
//  Created by Владимир Свиридов on 31.01.2022.
//

import Foundation

// Model of data for data from server
struct ImageModel: Codable {
    let images: [Image]
}

struct Image: Codable {
    let url: String
    let tags: [Tag]
}

struct Tag: Codable {
    let tagDescription: String
    
    enum CodingKeys: String, CodingKey {
        case tagDescription = "description"
    }
}
