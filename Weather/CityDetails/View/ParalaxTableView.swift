//
//  ParalaxTableView.swift
//  Weather
//
//  Created by Dmytro Krupskyi on 14.07.2022.
//

import UIKit
import MapKit

class ParalaxTableView: UITableView {
    
    var heightConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let header = tableHeaderView else { return }
        let offset = -(contentOffset.y + adjustedContentInset.top)
        
        if heightConstraint == nil {
            if let mapView = header.subviews.first as? MKMapView {
                let scale = 1 + max(offset / header.bounds.height, 0)
                let transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
                let transformedBounds = mapView.bounds.applying(transform)
                let delta = transformedBounds.height - mapView.bounds.height
                mapView.transform = transform.translatedBy(x: 0, y: -delta / 2)
            }
        }

        heightConstraint?.constant = max(header.bounds.height, header.bounds.height - offset)
        bottomConstraint?.constant = offset >= 0 ? 0 : offset / 2
        header.clipsToBounds = offset <= 0
    }
    
}
