//
//  PreferenceManager.swift
//  weatherTestApp
//
//  Created by skostiuk on 16.08.2022.
//

import Foundation

enum KeyPreference: String, CaseIterable {
    case temperatureScale = "temperatureScale"
}

enum TemperatureScale: String, CaseIterable {
    case fahrenheit
    case celsius
    case kelvin
}

extension TemperatureScale {
    //MARK: - Public Properties
    var title: String {
        switch self {
        case .fahrenheit:
            return "Fahrenheit - °F"
        case .celsius:
            return "Celsius - °C"
        case .kelvin:
            return "Kelvin - K"
        }
    }

    var sign: String {
        switch self {
        case .fahrenheit:
            return "°F"
        case .celsius:
            return "°C"
        case .kelvin:
            return "K"
        }
    }

    //MARK: - Public Func
    func convert(temperature: Double) -> Int {
        switch self {
        case .fahrenheit:
            return Int(((9.0 / 5.0) * temperature - 459.67).rounded())
        case .celsius:
            return Int((temperature - 273.15).rounded())
        case .kelvin:
            return Int(temperature.rounded())
        }
    }

}
