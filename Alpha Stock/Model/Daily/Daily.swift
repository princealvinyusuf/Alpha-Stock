//
//  Daily.swift
//  Alpha Stock
//
//  Created by Prince Alvin Yusuf on 11/04/21.
//

import Foundation

// MARK: - Daily
struct Daily: Codable {
    let timeSeriesDaily: [String: TimeSeriesDaily]

    enum CodingKeys: String, CodingKey {
        case timeSeriesDaily = "Time Series (Daily)"
    }
}

// MARK: - TimeSeriesDaily
struct TimeSeriesDaily: Codable {
    let open, high, low, close, volume: String

    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "6. volume"
    }
}
