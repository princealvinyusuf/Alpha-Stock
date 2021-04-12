//
//  CustomManager.swift
//  Alpha Stock
//
//  Created by Prince Alvin Yusuf on 12/04/21.
//

import Foundation

protocol CustomManagerDelegate {
    func didReceiveTableData(custom: CustomModel?)
    func didFailWithError(error: Error)
}

class CustomManager {
    
    let url = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY"
    
    var delegate: CustomManagerDelegate?
    
    func fetchData(symbol: String, apiKey: String, interval: String, outputsize: String) {
        let completeURL = "\(url)&symbol=\(symbol)&interval=\(interval)&outputsize=\(outputsize)&apikey=\(apiKey)"
        print(completeURL)
        
        performRequest(with: completeURL, interval: interval)
    }
    
    func performRequest(with urlString: String, interval: String) {
        // Create a URL
        if let url = URL(string: urlString) {
            
            // Create a Session
            let session = URLSession(configuration: .default)
            
            // Give a session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    self.parseJSON(data: safeData, interval: interval)
                    //                    if let custom = self.parseJSON(data: safeData) {
                    //                        self.delegate?.didReceiveTableData(custom: custom)
                    //                    }
                }
            }
            
            task.resume()// Execution
        }
        
    }
    
    func parseJSON(data: Data, interval: String) -> CustomModel? {
        let decoder = JSONDecoder()
        
        var openItem = [String]()
        var highItem = [String]()
        var closeItem = [String]()
        var volumeItem = [String]()
        var lowItem = [String]()
        
        do {
            switch interval {
            case "1min":
                let decodedData = try decoder.decode(CustomOne.self, from: data)
                let tSeries = decodedData.timeSeries1Min.keys
                let dateArray = tSeries.localizedStandardSorted(ascending: false)
                
                let dateItem: [String] = dateArray
                
                for index in dateItem {
                    guard let safeData = decodedData.timeSeries1Min[index] else { fatalError() }
                    openItem.append(safeData.open)
                    highItem.append(safeData.high)
                    lowItem.append(safeData.low)
                    closeItem.append(safeData.close)
                    volumeItem.append(safeData.volume)
                }
                
                let saveValue = CustomModel(date: dateItem, open: openItem, high: highItem, close: closeItem, volume: volumeItem, low: lowItem)
                return saveValue
                
            case "5min":
                let decodedData = try decoder.decode(CustomFive.self, from: data)
                let tSeries = decodedData.timeSeries5Min.keys
                let dateArray = tSeries.localizedStandardSorted(ascending: false)
                
                let dateItem: [String] = dateArray
                
                for index in dateItem {
                    guard let safeData = decodedData.timeSeries5Min[index] else { fatalError() }
                    openItem.append(safeData.open)
                    highItem.append(safeData.high)
                    lowItem.append(safeData.low)
                    closeItem.append(safeData.close)
                    volumeItem.append(safeData.volume)
                }
                
                let saveValue = CustomModel(date: dateItem, open: openItem, high: highItem, close: closeItem, volume: volumeItem, low: lowItem)
                return saveValue
                
            case "15min":
                let decodedData = try decoder.decode(CustomFifteen.self, from: data)
                let tSeries = decodedData.timeSeries15Min.keys
                let dateArray = tSeries.localizedStandardSorted(ascending: false)
                
                let dateItem: [String] = dateArray
                
                for index in dateItem {
                    guard let safeData = decodedData.timeSeries15Min[index] else { fatalError() }
                    openItem.append(safeData.open)
                    highItem.append(safeData.high)
                    lowItem.append(safeData.low)
                    closeItem.append(safeData.close)
                    volumeItem.append(safeData.volume)
                }
                
                let saveValue = CustomModel(date: dateItem, open: openItem, high: highItem, close: closeItem, volume: volumeItem, low: lowItem)
                return saveValue
                
            case "30min":
                let decodedData = try decoder.decode(CustomThirty.self, from: data)
                let tSeries = decodedData.timeSeries30Min.keys
                let dateArray = tSeries.localizedStandardSorted(ascending: false)
                
                let dateItem: [String] = dateArray
                
                for index in dateItem {
                    guard let safeData = decodedData.timeSeries30Min[index] else { fatalError() }
                    openItem.append(safeData.open)
                    highItem.append(safeData.high)
                    lowItem.append(safeData.low)
                    closeItem.append(safeData.close)
                    volumeItem.append(safeData.volume)
                }
                
                let saveValue = CustomModel(date: dateItem, open: openItem, high: highItem, close: closeItem, volume: volumeItem, low: lowItem)
                return saveValue
                
            case "60min":
                let decodedData = try decoder.decode(CustomSixty.self, from: data)
                let tSeries = decodedData.timeSeries60Min.keys
                let dateArray = tSeries.localizedStandardSorted(ascending: false)
                
                let dateItem: [String] = dateArray
                
                for index in dateItem {
                    guard let safeData = decodedData.timeSeries60Min[index] else { fatalError() }
                    openItem.append(safeData.open)
                    highItem.append(safeData.high)
                    lowItem.append(safeData.low)
                    closeItem.append(safeData.close)
                    volumeItem.append(safeData.volume)
                }
                
                let saveValue = CustomModel(date: dateItem, open: openItem, high: highItem, close: closeItem, volume: volumeItem, low: lowItem)
                return saveValue
            default:
                return nil
            }
            
            
        } catch {
            print(error)
            return nil
        }
        
    }
}
