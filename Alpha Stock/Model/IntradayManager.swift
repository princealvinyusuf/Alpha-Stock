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
            let dateArray = tSeries.localizedStandardSorted(ascending: false)
//            print(dateArray)
            
//            var finishItem: String? {
//                for eachItem in itemArray {
//                    print(eachItem)
//                    return eachItem
//                }
//                return nil
//            }
            
            let dateItem: [String] = dateArray // Output: ["2021-03-29 18:15:00", "2021-03-29 18:15:00"]
            
            var openItem = [String]()
            var highItem = [String]()
            var closeItem = [String]()
            var volumeItem = [String]()
            var lowItem = [String]()
            
            for index in dateItem {
                guard let safeData = decodedData.timeSeries[index] else { return nil }
                
                print(safeData)
                openItem.append(safeData.open)
                highItem.append(safeData.high)
                lowItem.append(safeData.low)
                closeItem.append(safeData.close)
                volumeItem.append(safeData.volume)
                
            }
            
            
            let saveValue = IntradayModel(date: dateItem, open: openItem, high: highItem, close: closeItem, volume: volumeItem, low: lowItem)
            print(saveValue)
            return saveValue
      
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
}


public extension Sequence where Element: StringProtocol {
     func localizedStandardSorted(ascending: Bool = true) -> [Element] {
        let result: ComparisonResult = ascending ? .orderedAscending : .orderedDescending
        return sorted { $0.localizedStandardCompare($1) == result }
    }
}
