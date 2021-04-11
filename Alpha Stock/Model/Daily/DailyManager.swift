//
//  DailyManager.swift
//  Alpha Stock
//
//  Created by Prince Alvin Yusuf on 11/04/21.
//

import Foundation

protocol DailyManagerDelegate {
    func didReceiveTableDataOne(daily: DailyModel?)
    func didReceiveTableDataTwo(daily: DailyModel?)
    func didReceiveTableDataThree(daily: DailyModel?)
    func didFailWithError(error: Error)
}

class DailyManager {
    
    var symbol = "IBM"
    let apiKey = "U9UEIDBB9SG2DHLV"
    
    let url = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED"
    
    var delegate: DailyManagerDelegate?
    
    func fetchData(symbol: String, params: Int) {
        let completeURL = "\(url)&symbol=\(symbol)&apikey=\(apiKey)"
        print(completeURL)
        
        performRequest(with: completeURL, params: params)
    }
    
    func performRequest(with urlString: String, params: Int) {
        // Create a url
        if let url = URL(string: urlString) {
            
            // Create a session
            let session = URLSession(configuration: .default)
            
            // Give a session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    if let daily = self.parseJSON(data: safeData) {
                        if params == 1 {
                            self.delegate?.didReceiveTableDataOne(daily: daily)
                        }
                        if params == 2 {
                            self.delegate?.didReceiveTableDataTwo(daily: daily)
                        }
                        if params == 3 {
                            self.delegate?.didReceiveTableDataThree(daily: daily)
                        }
                        
                    }
                }
            }
            
            // Execution
            task.resume()
        }
        
    }
    
    func parseJSON(data: Data) -> DailyModel? {
        
        let decoder = JSONDecoder()
        
        
        do {
            let decodeData = try decoder.decode(Daily.self, from: data)
            let tSeries = decodeData.timeSeriesDaily.keys
            
            let dateArray = tSeries.localizedStandardSorted(ascending: true)
            let dateItem: [String] = dateArray
            
            var openItem: String = ""
            var highItem: String = ""
            var lowItem: String = ""
            var closeItem: String = ""
            var volumeItem: String = ""
            
            for index in dateItem {
                guard let safeData = decodeData.timeSeriesDaily[index] else { fatalError() }
                
                openItem = safeData.open
                highItem = safeData.high
                lowItem = safeData.low
                closeItem = safeData.close
                volumeItem = safeData.volume
            }
            
            let dailyModel = DailyModel(date: dateItem, open: openItem, high: highItem, close: closeItem, volume: volumeItem, low: lowItem)
            print(dailyModel)
            return dailyModel
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
}
