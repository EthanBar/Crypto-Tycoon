//
//  CryptoDataManager.swift
//  Crypto Tycoon
//
//  Created by Ethan Barker on 12/21/17.
//  Copyright © 2017 Ethan Barker. All rights reserved.
//

import Foundation

struct Currency {
    var name: String
    
    var currentValue: Double?
    var yesterday: CurrencyData?
    var lastWeek: CurrencyData?
    var lastMonth: CurrencyData?
    var lastYear: CurrencyData?
    
    init(name: String) {
        self.name = name
    }
    
    public mutating func getGraphData(from date: DateManager.Dates) -> CurrencyData? {
        switch date {
        case .now:
            print("Attempting to return graph data from now?")
            return nil
        case .yesterday:
            yesterday = calculateGraphData(data: yesterday)
            return yesterday
        case .lastWeek:
            lastWeek = calculateGraphData(data: lastWeek)
            return lastWeek
        case .lastMonth:
            lastMonth = calculateGraphData(data: lastMonth)
            return lastMonth
        case .lastYear:
            lastYear = calculateGraphData(data: lastYear)
            return lastYear
        }
    }
    
    private func calculateGraphData(data: CurrencyData?) -> CurrencyData {
        if let oldData = data {
            // TODO: Refresh old data
            return oldData
        }
    }
}

struct CurrencyData {
    
    var dates: [Double]
    var values: [Double]
    
    init(dates: [Double], values: [Double]) {
        self.dates = dates
        self.values = values
    }
    
}
