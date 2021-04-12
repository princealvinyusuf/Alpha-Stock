//
//  Custom.swift
//  Alpha Stock
//
//  Created by Prince Alvin Yusuf on 12/04/21.
//

import Foundation

// MARK: - Custom 1 Min
struct CustomOne: Codable {
    let timeSeries1Min: [String: TimeSeriesMin]

    enum CodingKeys: String, CodingKey {
        case timeSeries1Min = "Time Series (1min)"
    }
}


// MARK: - Custom 5 Min
struct CustomFive: Codable {
    let timeSeries5Min: [String: TimeSeriesMin]

    enum CodingKeys: String, CodingKey {
        case timeSeries5Min = "Time Series (5min)"
    }
}

// MARK: - Custom 15
struct CustomFifteen: Codable {
    let timeSeries15Min: [String: TimeSeriesMin]

    enum CodingKeys: String, CodingKey {
        case timeSeries15Min = "Time Series (15min)"
    }
}


// MARK: - Custom 30
struct CustomThirty: Codable {
    let timeSeries30Min: [String: TimeSeriesMin]

    enum CodingKeys: String, CodingKey {
        case timeSeries30Min = "Time Series (30min)"
    }
}


// MARK: - Custom 60
struct CustomSixty: Codable {
    let timeSeries60Min: [String: TimeSeriesMin]

    enum CodingKeys: String, CodingKey {
        case timeSeries60Min = "Time Series (60min)"
    }
}


// MARK: - TimeSeriesMin
struct TimeSeriesMin: Codable {
    let open, high, low, close, volume: String

    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}
