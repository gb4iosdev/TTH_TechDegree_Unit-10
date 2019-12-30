//
//  MKMapView.swift
//  DiaryApp
//
//  Created by Gavin Butler on 20-11-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import MapKit

extension MKMapView {
    
    //Sets the map’s region given a co-ordinate and span
    private func setRegion(around coordinate: CLLocationCoordinate2D, withSpan span: Double) {
        let span = MKCoordinateRegion(center: coordinate, latitudinalMeters: span, longitudinalMeters: span).span
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.setRegion(region, animated: true)
    }
    
    //Centre the map around a coordinate, set it's span
    func adjust(centreTo centre: CLLocationCoordinate2D, span: Double) {
        self.setRegion(around: centre, withSpan: span)
    }
    
    func addAnnotation(at location: CLLocationCoordinate2D, title: String?, subTitle: String?) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = title
        annotation.subtitle = subTitle
        self.addAnnotation(annotation)
        self.selectAnnotation(annotation, animated: true)
    }
    
    func removeAllAnnotations() {
        let allAnnotations = self.annotations
        self.removeAnnotations(allAnnotations)
    }
}



