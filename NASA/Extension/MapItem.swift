//
//  MapItem.swift
//  ProximityReminders
//
//  Created by Gavin Butler on 06-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import MapKit


extension MKMapItem {
    
    //Create Address from MKMapItem detail
    var address: String {
        let placemark = self.placemark
        let number = placemark.subThoroughfare ?? ""
        let street = placemark.thoroughfare ?? ""
        let city = placemark.locality ?? ""
        let country = placemark.country ?? ""
        return "\(number) \(street), \(city), \(country)"
    }
    
}
