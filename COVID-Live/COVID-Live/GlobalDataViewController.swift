//
//  ViewController.swift
//  COVID-Live
//
//  Created by Samar Seth on 5/10/20.
//  Copyright © 2020 Samar Seth. All rights reserved.
//

import UIKit

import Foundation

class GlobalDataViewController: UIViewController {
    var globalCasesData: GlobalData?
    
    @IBOutlet weak var totalCases: UILabel!
    @IBOutlet weak var newCases: UILabel!
    @IBOutlet weak var totalDeaths: UILabel!
    @IBOutlet weak var newDeaths: UILabel!
    @IBOutlet weak var totalRecovered: UILabel!
    @IBOutlet weak var newRecovered: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        let urlString: String
        urlString = "https://api.covid19api.com/summary"
        sleep(1)
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                performSelector(onMainThread: #selector(populateData), with: nil, waitUntilDone: false)
                return
            }
        }
        
        print("data retrieval error")
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func populateData() {
        // Cases data
        totalCases.text! = String(globalCasesData!.TotalConfirmed)
        
        var percentNewCases = 100 * globalCasesData!.NewConfirmed / (globalCasesData!.TotalConfirmed - globalCasesData!.NewConfirmed)
        newCases.text! = "↑ " + String(globalCasesData!.NewConfirmed) + " (" + String(percentNewCases) + "%)"
        
        // Deaths data
        totalDeaths.text! = String(globalCasesData!.TotalDeaths)
        
        var percentNewDeaths = 100 * globalCasesData!.NewDeaths / (globalCasesData!.TotalDeaths - globalCasesData!.NewDeaths)
        newDeaths.text! = "↑ " + String(globalCasesData!.NewDeaths) + " (" + String(percentNewDeaths) + "%)"
        
        // Recovered patients data
        totalRecovered.text! = String(globalCasesData!.TotalRecovered)
        
        var percentNewRecovered = 100 * globalCasesData!.NewRecovered / (globalCasesData!.TotalRecovered - globalCasesData!.NewRecovered)
        newRecovered.text! = "↑ " +  String(globalCasesData!.NewRecovered) + " (" + String(percentNewRecovered) + "%)"
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonGlobalData = try? decoder.decode(GlobalDataSet.self, from: json) {
            globalCasesData = jsonGlobalData.Global
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the data; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

}

