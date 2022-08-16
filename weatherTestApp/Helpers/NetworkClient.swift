//
//  NetworkClient.swift
//  weatherTestApp
//
//  Created by skostiuk on 15.08.2022.
//

import Foundation
import Combine

enum ApiError: Error {
    case somethingWentWrong
}

protocol ApiClient {
    func getCurrentWeather(path: String) -> AnyPublisher<WeatherDTO, Error>
    func getForecast(path: String) -> AnyPublisher<ForecastListDTO, Error>
}

final class NetworkClient: ApiClient {

    func getCurrentWeather(path: String) -> AnyPublisher<WeatherDTO, Error> {
        return AnyPublisher(Future { promise in
            guard let url = URL(string: path) else {
                promise(.failure(ApiError.somethingWentWrong))
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let urlResponse = response as? HTTPURLResponse else {
                    promise(.failure(ApiError.somethingWentWrong))
                    return
                }

                if urlResponse.statusCode == 200,
                   let dto = try? JSONDecoder().decode(WeatherDTO.self, from: data)  {

                    promise(.success(dto))

                } else {
                    promise(.failure(ApiError.somethingWentWrong))
                }
            }

            task.resume()
        })
    }

    func getForecast(path: String) -> AnyPublisher<ForecastListDTO, Error> {
        return AnyPublisher(Future { promise in
            guard let url = URL(string: path) else {
                promise(.failure(ApiError.somethingWentWrong))
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let urlResponse = response as? HTTPURLResponse else {
                    promise(.failure(ApiError.somethingWentWrong))
                    return
                }

                if urlResponse.statusCode == 200,
                   let dto = try? JSONDecoder().decode(ForecastListDTO.self, from: data)  {

                    promise(.success(dto))
                } else {
                    promise(.failure(ApiError.somethingWentWrong))
                }
            }

            task.resume()
        })
    }

}
