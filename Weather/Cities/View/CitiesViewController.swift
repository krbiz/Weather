//
//  CitiesViewController.swift
//  Weather
//
//  Created by Dmytro Krupskyi on 13.07.2022.
//

import UIKit
import Kingfisher

class CitiesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let cellIdentifier = String(describing: CityTableViewCell.self)
    private let cityDetailsIdentifier = String(describing: CityDetailsViewController.self)
    
    private var viewModel = CitiesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .onDrag
        initViewModel()
    }
    
    func initViewModel() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async { self?.tableView.reloadData() }
        }
        
        viewModel.loadCities()
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CityTableViewCell
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        let url = viewModel.getCellImageUrl(at: indexPath)
        cell.titleLabel.text = cellVM.name
        cell.iconImageView.kf.setImage(with: URL(string: url))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
         let cityDetailsVC = storyboard?.instantiateViewController(withIdentifier: cityDetailsIdentifier) as! CityDetailsViewController
        cityDetailsVC.city = viewModel.getCellViewModel(at: indexPath)
        navigationController?.pushViewController(cityDetailsVC, animated: true)
    }
    
}

// MARK: - UISearchBarDelegate

extension CitiesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filteredCities(of: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
}
