//
//  CustomLocDetailViewController.swift
//  COVID-Live
//
//  Created by Samar Seth on 5/20/20.
//  Copyright © 2020 Samar Seth. All rights reserved.
//

import UIKit

class CustomLocDetailViewController: UIViewController {
    var countryData = [CountryData]()
    var defaults = UserDefaults.standard
    var json: Data?
    var countryIndex: Int?
    var country: CountryData?
    var customLocations: [Int]?
    
    @IBOutlet weak var totalCases: UILabel!
    @IBOutlet weak var newCases: UILabel!
    @IBOutlet weak var totalDeaths: UILabel!
    @IBOutlet weak var newDeaths: UILabel!
    @IBOutlet weak var totalRecovered: UILabel!
    @IBOutlet weak var newRecovered: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        json = (defaults.object(forKey: "dataSet") as! Data)
        parse(json: json!)
        countryIndex = defaults.integer(forKey: "selectedCustomLocation")
        country = countryData[countryIndex!]
        populateData()
    }
    
    @objc func populateData() {
        // Cases data
        totalCases.text! = String(country!.TotalConfirmed)
        
        var percentNewCases = 100 * country!.NewConfirmed / (country!.TotalConfirmed - country!.NewConfirmed)
        if percentNewCases < 1 {
            newCases.text! = "↑ " + String(country!.NewConfirmed) + " (<1%)"
        } else {
            newCases.text! = "↑ " + String(country!.NewConfirmed) + " (" + String(percentNewCases) + "%)"
        }
        
        // Deaths data
        totalDeaths.text! = String(country!.TotalDeaths)
        
        var percentNewDeaths = 100 * country!.NewDeaths / (country!.TotalDeaths - country!.NewDeaths)
        if percentNewDeaths < 1 {
            newDeaths.text! = "↑ " + String(country!.NewDeaths) + " (<1%)"
        } else {
            newDeaths.text! = "↑ " + String(country!.NewDeaths) + " (" + String(percentNewDeaths) + "%)"
        }
        
        // Recovered patients data
        totalRecovered.text! = String(country!.TotalRecovered)
        
        var percentNewRecovered = 100 * country!.NewRecovered / (country!.TotalRecovered - country!.NewRecovered)
        if percentNewRecovered < 1 {
            newRecovered.text! = "↑ " +  String(country!.NewRecovered) + " (<1%)"
        } else {
            newRecovered.text! = "↑ " +  String(country!.NewRecovered) + " (" + String(percentNewRecovered) + "%)"
        }
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
}
