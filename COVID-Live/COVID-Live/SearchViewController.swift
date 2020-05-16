//
//  SearchViewController.swift
//  COVID-Live
//
//  Created by Samar Seth on 5/16/20.
//  Copyright © 2020 Samar Seth. All rights reserved.

//  Search Functionality Src: https://www.raywenderlich.com/4363809-uisearchcontroller-tutorial-getting-started

import UIKit

class SearchViewController: UITableViewController {
    var countryData = [CountryData]()
    var filteredCountries: [CountryData] = []
    var defaults = UserDefaults.standard
    
    // initializes tableViewController as the place to display the results of the search
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // informs the class of any text changes in the search bar
        searchController.searchResultsUpdater = self
        
        // configuring the appearance of the search bar
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Countries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        let urlString: String
        urlString = "https://api.covid19api.com/summary"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonGlobalData = try? decoder.decode(Countries.self, from: json) {
            countryData = jsonGlobalData.Countries
            filteredCountries = countryData
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredCountries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        
        let country = filteredCountries[indexPath.row]
        cell.textLabel?.text = country.Country

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaults.set(indexPath.row, forKey: "selectedCountryIndex")
        performSegue(withIdentifier: "viewSearchDetail", sender: self)
    }
    
    // copied from:  https://www.raywenderlich.com/4363809-uisearchcontroller-tutorial-getting-started
    // filters the list of countries based on whether they contain the letters that are in the search bar
    func filterContentForSearchText(_ searchText: String) {
        if searchText == "" {
            filteredCountries = countryData
        } else {
            filteredCountries = countryData.filter { (country: CountryData) -> Bool in
                return country.Country.lowercased().contains(searchText.lowercased())
            }
        }
      
      tableView.reloadData()
    }
}

// copied from: https://www.raywenderlich.com/4363809-uisearchcontroller-tutorial-getting-started
// updates the tableView based on the contents of the search bar
extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}
