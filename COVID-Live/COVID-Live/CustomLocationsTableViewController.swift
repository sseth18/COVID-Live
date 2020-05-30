//
//  CustomLocationsTableViewController.swift
//  COVID-Live
//
//  Created by Samar Seth on 5/20/20.
//  Copyright © 2020 Samar Seth. All rights reserved.
//

import UIKit

class CustomLocationsTableViewController: UITableViewController {
    var countryData = [CountryData]()
    var countryIndices: [Int]?
    var customLocations = [CountryData]()
    var json: Data?
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        json = defaults.object(forKey: "dataSet") as! Data
        parse(json: json!)
        
        if let indices = defaults.array(forKey: "customCountryIndices") as! [Int]? {
            countryIndices = indices
            for index in countryIndices! {
                customLocations.append(countryData[index])
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        customLocations = []
        if let indices = defaults.array(forKey: "customCountryIndices") as! [Int]? {
            countryIndices = indices
            for index in countryIndices! {
                customLocations.append(countryData[index])
            }
        }
        tableView.reloadData()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonGlobalData = try? decoder.decode(Countries.self, from: json) {
            countryData = jsonGlobalData.Countries
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the data; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return customLocations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! LocationTableViewCell

        let country = customLocations[indexPath.row]
        cell.country!.text = country.Country
        
        cell.showsReorderControl = true

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaults.set(countryIndices![indexPath.row], forKey: "selectedCustomLocation")
        performSegue(withIdentifier: "viewLocationDetail", sender: self)
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            customLocations.remove(at: indexPath.row)
            countryIndices!.remove(at: indexPath.row)
            defaults.set(countryIndices, forKey: "customCountryIndices")
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedCountry = customLocations[fromIndexPath.row]
        customLocations.remove(at: fromIndexPath.row)
        customLocations.insert(movedCountry, at: to.row)
        
        let movedCountryIndex = countryIndices![fromIndexPath.row]
        countryIndices!.remove(at: fromIndexPath.row)
        countryIndices!.insert(movedCountryIndex, at: to.row)
        
        defaults.set(countryIndices, forKey: "customCountryIndices")
        
        tableView.reloadData()
    }
}
