//
//  Intraday.swift
//  Alpha Stock
//
//  Created by Prince Alvin Yusuf on 30/03/21.
//

import Foundation

struct Intraday: Codable {
    let timeSeries: [String: TimeSeries]

    enum CodingKeys: String, CodingKey {
        case timeSeries = "Time Series (5min)"
    }
}

// MARK: - TimeSeries
struct TimeSeries: Codable {
    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String

    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}
