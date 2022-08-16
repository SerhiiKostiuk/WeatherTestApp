//
//  CityWeatherViewModel.swift
//  weatherTestApp
//
//  Created by skostiuk on 16.08.2022.
//

import Foundation
import Combine
import RealmSwift

final class CityWeatherViewModel: ObservableObject {

    //MARK: - Private Static Properties

    private enum Constants {
        static let baseUrl = "https://api.openweathermap.org/data/2.5/"
        static let forecastPart = "forecast"
        static let apiKey = "0cd74bf29e43ef1ad6afd6861cc99eb2"
    }
    //MARK: - @Published Properties

    @Published var inProgress = false
    @Published var models: [ForecastDTO] = []

    //MARK: - Private Properties
    private var cancellableSet: Set<AnyCancellable> = []
    private let networkClient = NetworkClient()
    private let reachability = ReachabilityManager()

    //MARK: - Public Func

    func getForecast(for cityId: UInt) {
        inProgress = true

        networkClient.getForecast(path: getPath(id: cityId)).eraseToAnyPublisher()
            .sink { error in
                print(error)
            } receiveValue: {[weak self] dto in
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    self.models = dto.list
                }
            }
            .store(in: &cancellableSet)
    }

    //MARK: - Private Func

    private func getPath(id: UInt) -> String {
        "\(Constants.baseUrl)\(Constants.forecastPart)?id=\("\(id)")&appid=\(Constants.apiKey)"
    }
}
