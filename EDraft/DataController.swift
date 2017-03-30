//
//  DataController.swift
//  EDraft
//
//  Created by Devin Tripp on 3/14/17.
//  Copyright © 2017 Devin Tripp. All rights reserved.
//

import Foundation



let html = "http://charts.noaa.gov/BookletChart/AtlanticCoastBookletCharts.htm"

class DataController {
    
}


class chart {
    let title: String
    let url: NSURL
    let number: Int
    let scale: Int
    
    required init(title: String, url: NSURL, number: Int, scale: Int) {
        self.title = title
        self.url = url
        self.number = number
        self.scale = scale
    }
    
    
    
}
