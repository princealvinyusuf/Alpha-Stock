//
//  IntradayManager.swift
//  Alpha Stock
//
//  Created by Prince Alvin Yusuf on 30/03/21.
//

import Foundation

protocol IntradayManagerDelegate {
    func didReceiveTableData(intraday: IntradayModel?)
    func didFailWithError(error: Error)
    
}

class IntradayManager {
    var symbol = "IBM"
    let apiKey = "U9UEIDBB9SG2DHLV"
    
    let url = "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY"
    
    var delegate: IntradayManagerDelegate?
    
    func fetchData(symbol: String) {
        let completeURL = "\(url)&symbol=\(symbol)&interval=5min&apikey=\(apiKey)"
        print(completeURL)
        
        performRequest(with: completeURL)
    }
    
    func performRequest(with urlString: String) {
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
                    if let intraday = self.parseJSON(data: safeData) {
                        self.delegate?.didReceiveTableData(intraday: intraday)
                    }
                    
                }
            }
            
            // Execution
            task.resume()
        }
        
    }
    
    func parseJSON(data: Data) -> IntradayModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Intraday.self, from: data)
            
            let tSeries = decodedData.timeSeries.keys
            let dateArray = tSeries.sorted()
//            print(dateArray)
            
//            var finishItem: String? {
//                for eachItem in itemArray {
//                    print(eachItem)
//                    return eachItem
//                }
//                return nil
//            }
            
            var dateItem: [String] = dateArray
            print(dateItem)
            
            guard let safeData = decodedData.timeSeries["2021-03-29 18:15:00"] else { return nil }
            
            let date = dateItem
            let openItem = safeData.open
            let highItem = safeData.low
            let closeItem = safeData.high
            let volumeItem = safeData.volume
            let lowItem = safeData.low
            
            let saveValue = IntradayModel(date: date, open: openItem, high: highItem, close: closeItem, volume: volumeItem, low: lowItem)
            print(saveValue)
            return saveValue
            
            //            let tSeries = decodedData.timeSeries.keys
            //            print(tSeries.sorted())
            //            for i in tSeries {
            //                print(i.key)
            //            }
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
}
