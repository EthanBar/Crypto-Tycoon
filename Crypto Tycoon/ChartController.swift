//
//  ChartController.swift
//  Crypto Tycoon
//
//  Created by Ethan Barker on 12/21/17.
//  Copyright © 2017 Ethan Barker. All rights reserved.
//

import UIKit
import Charts
import CryptoCurrencyKit

class ChartController: UIViewController {

    @IBOutlet weak var chart: LineChartView!
    
    var bitcoin: Currency?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initChart()
        bitcoin = Currency(name: "BitCoin", chart: self)
        bitcoin?.getGraphData(from: .lastMonth)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initChart() {
        chart.noDataText = "Loading realtime data..."
        chart.chartDescription = nil
        chart.xAxis.drawLabelsEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
        chart.legend.enabled = false
        
        chart.drawBordersEnabled = true
    }
    
    func setChart(data: CurrencyData) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<data.dates.count {
            let dataEntry = ChartDataEntry(x: data.dates[i], y: data.values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: nil)
        let chartData = LineChartData(dataSet: chartDataSet)
        chartDataSet.circleRadius = 0
        chartDataSet.colors = [NSUIColor.orange]
        chart.data = chartData
        
    }

}
