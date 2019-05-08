//
//  SearchViewController.swift
//  planti
//
//  Created by Yan Zhan on 4/30/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    private var searchCompleter = MKLocalSearchCompleter()
    private var places = [MKLocalSearchCompletion]()
    
    var delegate: SearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search place or restaurants"
        self.searchController.definesPresentationContext = true
        
        self.searchController.isActive = true
        self.tableView.tableHeaderView = searchController.searchBar
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.searchController.searchBar.showsCancelButton = true
        
        title = "Location Search"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchCompleter.delegate = self
        self.searchController.searchBar.delegate = self
    }
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        let item = places[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        return cell
    }
}

extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = places[indexPath.row]
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = item.subtitle == "" ? item.title : item.subtitle
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                print(error.debugDescription)
                return
            }
            guard let mapItem = response.mapItems.first else {return}
            let placemark = mapItem.placemark
            print(placemark.coordinate)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.searchController.isActive = false
            self.dismiss(animated: true) {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.delegate?.didSelectSearchResult(name: item.title, coordinate: placemark.coordinate)
            }
        }
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        places = completer.results
        self.tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText != "") {
            self.searchCompleter.queryFragment = searchText
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
}

protocol SearchViewControllerDelegate {
    func didSelectSearchResult(name: String, coordinate: CLLocationCoordinate2D)
}
