//
//  City.swift
//  Weather
//
//  Created by Dmytro Krupskyi on 13.07.2022.
//

import Foundation

struct City: Decodable {
    let id: Int
    let name: String
    let state: String
    let coordinate: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case state
        case coordinate = "coord"
    }
}

struct Coordinate: Decodable {
    let longitude: Double
    let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
