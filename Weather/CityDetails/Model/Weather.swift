//
//  Weather.swift
//  Weather
//
//  Created by Dmytro Krupskyi on 13.07.2022.
//

import Foundation

struct Weather {
    let description: String
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Double
    let windSpeed: Double
    
    private enum CodingKeys: String, CodingKey {
        case weather
        case main
        case wind
    }
    
    private struct WeatherInfo: Decodable {
        let description: String
    }

    private struct WeatherMainInfo: Decodable {
        let temp: Double
        let tempMin: Double
        let tempMax: Double
        let humidity: Double

        enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case humidity
        }
    }

    private struct WindInfo: Decodable {
        let speed: Double
    }
}

// MARK: - Decodable

extension Weather: Decodable {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let mainInfo = try values.decode(WeatherMainInfo.self, forKey: .main)
        temp = mainInfo.temp
        tempMin = mainInfo.tempMin
        tempMax = mainInfo.tempMax
        humidity = mainInfo.humidity
        
        let windInfo = try values.decode(WindInfo.self, forKey: .wind)
        windSpeed = windInfo.speed
        
        let weatherInfo = try values.decode([WeatherInfo].self, forKey: .weather)
        description = weatherInfo.first?.description ?? ""
    }
    
}
