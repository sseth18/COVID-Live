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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

