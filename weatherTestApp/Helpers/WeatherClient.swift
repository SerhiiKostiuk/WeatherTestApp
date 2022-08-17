//
//  WeatherClient.swift
//  weatherTestApp
//
//  Created by skostiuk on 17.08.2022.
//

import Foundation
import Combine

protocol WeatherClient {
    func getCurrentWeather(id: UInt) -> AnyPublisher<WeatherDTO, Error>
    func getForecast(id: UInt) -> AnyPublisher<ForecastListDTO, Error>
}

final class WeatherClientImpl: WeatherClient {

    //MARK: - Private Value Types
    private enum Constants {
        static let baseUrl = "https://api.openweathermap.org/data/2.5/"
        static let apiKey = "0cd74bf29e43ef1ad6afd6861cc99eb2"
    }

    //MARK: - Private Properties
    private let networkClient: ApiClient

    //MARK: - Initializers
    init(networkClient: ApiClient) {
        self.networkClient = networkClient
    }

    //MARK: - Public Func
    func getForecast(id: UInt) -> AnyPublisher<ForecastListDTO, Error> {
        networkClient.request(with: getPath(for: "forecast", with: id))
    }

    func getCurrentWeather(id: UInt) -> AnyPublisher<WeatherDTO, Error> {
        networkClient.request(with: getPath(for: "weather", with: id))
    }

    //MARK: - Private Func
    private func getPath(for weatherType: String, with id: UInt) -> String {
        "\(Constants.baseUrl)\(weatherType)?id=\("\(id)")&appid=\(Constants.apiKey)"
    }
}
