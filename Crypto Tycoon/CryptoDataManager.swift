//
//  CryptoDataManager.swift
//  Crypto Tycoon
//
//  Created by Ethan Barker on 12/21/17.
//  Copyright © 2017 Ethan Barker. All rights reserved.
//

import Foundation
import Charts
import CryptoCurrencyKit

struct Currency {
    let name: String
    var currentValue: Double?
    var chart: ChartController
    
    init(name: String, chart: ChartController) {
        self.name = name
        self.chart = chart
    }
    
    public mutating func updateGraphData(from date: DateManager.Dates) {
        switch date {
        case .now:
            print("Attempting to get graph data from now?")
        default:
            calculateGraphData(date: date)
        }
    }
    
    private func calculateGraphData(date: DateManager.Dates) {
        CryptoCurrencyKit.fetchGraph(Graph.priceUSD, for: name, from: DateManager.getDate(from: date), to: DateManager.getDate(from: .now)) { (response) in
            switch response {
            case .success(let currency):
                var dates = [Double]()
                var values = [Double]()
                for point in currency {
                    dates.append(point.timestamp)
                    values.append(point.value)
                }
                self.chart.setChart(data: CurrencyData(dates: dates, values: values))
            case .failure(let error):
                print(error)
            }
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
