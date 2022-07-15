//
//  CityDetailsViewModel.swift
//  Weather
//
//  Created by Dmytro Krupskyi on 14.07.2022.
//

import UIKit
import Alamofire

class CityDetailsViewModel {
    
    var reloadTableView: (() -> Void)?
    
    private var cellViewModels: [DataListCellViewModel] = [DataListCellViewModel]() {
        didSet {
            self.reloadTableView?()
        }
    }
    
    func fetchWeatherData(of city: City) {
        AF.request("https://api.openweathermap.org/data/2.5/weather?units=metric&lat=\(city.coordinate.latitude)&lon=\(city.coordinate.longitude)&appid=085cbfcf90b43744ebd3a39219c81af1").responseDecodable(of: Weather.self) { [weak self] response in
            switch response.result {
            case .success:
                if let weather = response.value {
                    self?.setupCells(weather)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupCells(_ data: Weather) {
        cellViewModels = []
        
        cellViewModels.append(.init(
            titleText: "Description",
            subTitleText: data.description)
        )
        
        cellViewModels.append(.init(
            titleText: "Current temperature",
            subTitleText: String(format: "%.1f°C", data.temp))
        )
        
        cellViewModels.append(.init(
            titleText: "Min temperature",
            subTitleText: String(format: "%.1f°C", data.tempMin))
        )
        
        cellViewModels.append(.init(
            titleText: "Max temperature",
            subTitleText: String(format: "%.1f°C", data.tempMax))
        )
        
        cellViewModels.append(.init(
            titleText: "Air humidity",
            subTitleText: String(format: "%.0f%%", data.humidity))
        )
        
        cellViewModels.append(.init(
            titleText: "Wind speed",
            subTitleText: String(format: "%.2fm/s", data.windSpeed))
        )
        
        reloadTableView?()
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel(at indexPath: IndexPath ) -> DataListCellViewModel {
        return cellViewModels[indexPath.row]
    }

}

struct DataListCellViewModel {
    let titleText: String
    let subTitleText: String
}
