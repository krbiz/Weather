//
//  CitiesViewModel.swift
//  Weather
//
//  Created by Dmytro Krupskyi on 14.07.2022.
//

import UIKit

class CitiesViewModel {
    
    var reloadTableView: (() -> Void)?
    
    private var cellViewModels: [City] = []
    
    private var filteredCellViewModels: [City] = [] {
        didSet {
            self.reloadTableView?()
        }
    }
    
    func loadCities() {
        guard let url = Bundle.main.url(forResource: "city_list", withExtension: "json") else {
            print("Data file not found")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let jsonData = try JSONDecoder().decode([City].self, from: data)
            cellViewModels = jsonData
            filteredCellViewModels = jsonData
        } catch {
            print(error)
        }
    }
    
    var numberOfCells: Int {
        return filteredCellViewModels.count
    }
    
    func getCellViewModel(at indexPath: IndexPath ) -> City {
        return filteredCellViewModels[indexPath.row]
    }
    
    func getCellImageUrl(at indexPath: IndexPath ) -> String {
        let url = "https://infotech.gov.ua/storage/img/"
        let imageName = indexPath.row.isMultiple(of: 2) ? "Temp3.png" : "Temp1.png"
        return url + imageName
    }
    
    func filteredCities(of text: String) {
        if text.isEmpty {
            filteredCellViewModels = cellViewModels
        } else {
            filteredCellViewModels = cellViewModels.filter { $0.name.contains(text) }
        }
    }

}
