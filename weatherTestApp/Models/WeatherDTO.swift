//
//  WeatherDTO.swift
//  weatherTestApp
//
//  Created by skostiuk on 15.08.2022.
//

import Foundation

struct WeatherDTO: Codable {
    let date: TimeInterval
    let coordinates: CoordinatesDTO
    let weatherInfo: [WeatherInfoDTO]
    let weatherMain: WeatherMainDTO
    let cityId: UInt
    let cityName: String

    enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case weatherInfo = "weather"
        case weatherMain = "main"
        case date = "dt"
        case cityId = "id"
        case cityName = "name"
    }
}

struct WeatherInfoDTO: Codable {
    let description: String
    let iconName: String
    let id = UUID().uuidString

    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "icon"
    }
}

struct WeatherMainDTO: Codable {
    let temp: Double
    let minTemp: Double
    let maxTemp: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}

struct CoordinatesDTO: Codable {
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
