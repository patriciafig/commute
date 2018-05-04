//
//  LocationSearchTableTableViewController.swift
//  Commute
//
// Created by Patricia Figueroa on 28/04/18
// Copyright © 2018 Patricia Figueroa. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTableViewController : UITableViewController {
  var handleMapSearchDelegate:HandleMapSearch? = nil
  var matchingItems:[MKMapItem] = []
  var mapView: MKMapView? = nil
  
  func parseAddress(selectedItem:MKPlacemark) -> String {
    let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
    let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
    let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
    let addressLine = String(
      format:"%@%@%@%@%@%@%@",
      selectedItem.subThoroughfare ?? "",
      firstSpace,
      selectedItem.thoroughfare ?? "",
      comma,
      selectedItem.locality ?? "",
      secondSpace,
      selectedItem.administrativeArea ?? ""
    )
    return addressLine
  }
}

extension LocationSearchTableViewController : UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let mapView = mapView,
      let searchBarText = searchController.searchBar.text else { return }
    let request = MKLocalSearchRequest()
    request.naturalLanguageQuery = searchBarText
    request.region = mapView.region
    let search = MKLocalSearch(request: request)
    search.start { response, _ in
      guard let response = response else {
        return
      }
      self.matchingItems = response.mapItems
      self.tableView.reloadData()
    }
  }
}

extension LocationSearchTableViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1;
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return matchingItems.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let selectedItem = matchingItems[indexPath.row].placemark
    cell.textLabel?.text = selectedItem.name
    cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
    return cell
  }
}

extension LocationSearchTableViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedItem = matchingItems[indexPath.row].placemark
    handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
    dismiss(animated: true, completion: nil)
  }
}
