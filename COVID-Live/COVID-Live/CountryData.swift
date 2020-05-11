//
//  CountryData.swift
//  COVID-Live
//
//  Created by Samar Seth on 5/10/20.
//  Copyright © 2020 Samar Seth. All rights reserved.
//

import Foundation

struct CountryData: Codable {
    var Country: String
    var NewConfirmed: Int
    var TotalConfirmed: Int
    var NewDeaths: Int
    var TotalDeaths: Int
    var NewRecovered: Int
    var TotalRecovered: Int
}
