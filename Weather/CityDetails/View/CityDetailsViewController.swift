//
//  CityDetailsViewController.swift
//  Weather
//
//  Created by Dmytro Krupskyi on 13.07.2022.
//

import UIKit
import MapKit

class CityDetailsViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: ParalaxTableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private let cellIdentifier = String(describing: CityDetailsTableViewCell.self)
    
    var city: City?
    private var viewModel = CityDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        setupTableView()
        setupMapView()
    }
    
    func initViewModel() {
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async { self?.tableView.reloadData() }
        }
        
        if let city = city {
            viewModel.fetchWeatherData(of: city)
        }
    }
    
    private func setupTableView() {
        tableView.contentInsetAdjustmentBehavior = .never
        let height = UIScreen.main.bounds.height / 3
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: height)
        heightConstraint.constant = height
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
        tableView.bottomConstraint = bottomConstraint
    }
    
    private func setupMapView() {
        guard let city = city else { return }
        
        mapView.mapType = MKMapType.standard
        
        let location = CLLocationCoordinate2D(
            latitude: city.coordinate.latitude,
            longitude: city.coordinate.longitude
        )
        
        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = city.name
        mapView.addAnnotation(annotation)
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CityDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CityDetailsTableViewCell
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.titleLabel.text = cellVM.titleText
        cell.descriptionLabel.text = cellVM.subTitleText
        return cell
    }
    
}
