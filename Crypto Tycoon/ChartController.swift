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

class ChartController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // UI Outlets
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var coinPicker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var dateSelector: UISegmentedControl!
    
    // Store data about each coin here
    var coins: [CoinData] = []
    
    // Ticker data, load only once
    var data: [Ticker]?
    
    // Currently selected coin and date
    var currentDate = DateManager.Dates.yesterday
    var currentCoin: CoinData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTickerData()
        coinPicker.dataSource = self
        coinPicker.delegate = self
        initChart()
        Currency.loadChart(chart: self)
        coins.append(CoinData(displayName: "Bitcoin", idName: "bitcoin", shortName: "BTC", picture: #imageLiteral(resourceName: "btclogo"), color: #colorLiteral(red: 0.9720916152, green: 0.6221430898, blue: 0.2032132149, alpha: 1)))
        coins.append(CoinData(displayName: "Litecoin", idName: "litecoin", shortName: "LTC  ", picture: #imageLiteral(resourceName: "ltclogo"), color: #colorLiteral(red: 0.5489576459, green: 0.5490553379, blue: 0.5489515066, alpha: 1)))
        coins.append(CoinData(displayName: "Ethereum", idName: "ethereum", shortName: "ETH", picture: #imageLiteral(resourceName: "ethlogo"), color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
        coins.append(CoinData(displayName: "Dogecoin", idName: "dogecoin", shortName: "DOGE", picture: #imageLiteral(resourceName: "dogelogo"), color: #colorLiteral(red: 0.8575350642, green: 0.8008928571, blue: 0.3180749008, alpha: 1)))
        currentCoin = coins[0]
        updateGraph()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coins.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coins[row].displayName
    }
    
    func updateGraph() {
        currentCoin!.currency.updateGraphData(from: currentDate)
    }
    
    // On picker change
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentCoin = coins[row]
        updateCurrentCoin()
        updateGraph()
    }
    
    func loadTickerData() {
        CryptoCurrencyKit.fetchTickers { response in
            switch response {
            case .success(let data):
                self.data = data
                self.updateCurrentCoin()
            case .failure(let error):
                print(error)
            }
        }
    }

    @IBAction func onTimePickerChanged(_ sender: UISegmentedControl) {
        switch sender.titleForSegment(at: sender.selectedSegmentIndex)! {
        case "Day":
            currentDate = .yesterday
        case "Week":
            currentDate = .lastWeek
        case "Month":
            currentDate = .lastMonth
        case "Year":
            currentDate = .lastYear
        default:
            print("Time picker unknown value")
        }
        updateGraph()
    }
    
    func updateCurrentCoin() {
        coinImage.image = currentCoin?.picture
        dateSelector.tintColor = currentCoin?.color
        if (data != nil) {
            let btcTicker = getTicker(id: (currentCoin?.idName)!)
            currentPrice.text = "\((currentCoin?.shortName)!): $\(btcTicker.priceUSD!) (\(btcTicker.percentChange24h!))%"
        } else {
            loadTickerData()
        }
    }
    
    func getTicker(id: String) -> Ticker {
        return data!.first(where: {$0.id == id})! //!!
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
        chartDataSet.colors = [(currentCoin?.color)!]
        chart.data = chartData
        
    }

}

struct CoinData {
    var displayName: String
    var idName: String
    var shortName: String
    var picture: UIImage
    var currency: Currency
    var color: UIColor
    
    init(displayName: String, idName: String, shortName: String, picture: UIImage, color: UIColor) {
        self.displayName = displayName
        self.idName = idName
        self.shortName = shortName
        self.picture = picture
        self.color = color
        currency = Currency(name: idName)
    }
}
