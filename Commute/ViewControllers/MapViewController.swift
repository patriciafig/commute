//
//  MapViewController.swift
//  Commute
//
//  Created by Patricia Figueroa on 28/04/18
//  Copyright © 2018 Patricia Figueroa. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
  func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController {

  var selectedPin:MKPlacemark? = nil
  
  var resultSearchController:UISearchController? = nil
  
  let locationManager = CLLocationManager()
  
  @IBOutlet weak var mapView: MKMapView!
  
    override func viewDidLoad() {
      super.viewDidLoad()
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      locationManager.requestLocation()
      let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
      resultSearchController = UISearchController(searchResultsController: locationSearchTable)
      resultSearchController?.searchResultsUpdater = locationSearchTable
      let searchBar = resultSearchController!.searchBar
      searchBar.sizeToFit()
      searchBar.placeholder = "Search for places"
      navigationItem.titleView = resultSearchController?.searchBar
      resultSearchController?.hidesNavigationBarDuringPresentation = false
      resultSearchController?.dimsBackgroundDuringPresentation = true
      definesPresentationContext = true
      locationSearchTable.mapView = mapView
      locationSearchTable.handleMapSearchDelegate = self
      mapView.delegate = self;
    }
  
  func confirmLocation() {
    
  }
}
  
  extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      if status == .authorizedWhenInUse {
        locationManager.requestLocation()
      }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      if let location = locations.first {
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
      }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print("error:: \(error)")
    }
  }

extension MapViewController: HandleMapSearch {
  func dropPinZoomIn(placemark:MKPlacemark){
    selectedPin = placemark
    mapView.removeAnnotations(mapView.annotations)
    let annotation = MKPointAnnotation()
    annotation.coordinate = placemark.coordinate
    annotation.title = placemark.name
    if let city = placemark.locality,
      let state = placemark.administrativeArea {
      annotation.subtitle = "\(city) \(state)"
    }
    mapView.addAnnotation(annotation)
    let span = MKCoordinateSpanMake(0.005, 0.005)
    let region = MKCoordinateRegionMake(placemark.coordinate, span)
    mapView.setRegion(region, animated: true)
  }
}

extension MapViewController : MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
    if annotation is MKUserLocation {
      return nil
    }
    let reuseId = "pin"
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
    if (pinView == nil) {
      pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
    }
    pinView?.image = UIImage(named: "map_marker")
    pinView?.bounds = CGRect(x: 0, y: 0, width: 30, height: 40)
    return pinView
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    let alert = UIAlertController(title: (view.annotation?.title)!, message: "Please confirm location", preferredStyle:.alert)
    alert.addAction(UIAlertAction(title: "Ok", style:.default, handler: nil))
    alert.addAction(UIAlertAction(title: "Cancel", style:.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}
