//
//  ForecastListDTO.swift
//  weatherTestApp
//
//  Created by skostiuk on 15.08.2022.
//

import Foundation

struct ForecastListDTO: Codable {
    let list: [ForecastDTO]
}

struct ForecastDTO: Codable {
    let date: TimeInterval
    let weatherInfo: [WeatherInfoDTO]
    let weatherMain: WeatherMainDTO

    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case weatherInfo = "weather"
        case weatherMain = "main"
    }
}
