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

    //MARK: - @Published Properties

    @Published var inProgress = false
    @Published var models: [ForecastDTO] = []

    //MARK: - Private Properties
    private var cancellableSet: Set<AnyCancellable> = []
    private let weatherClient = WeatherClientImpl(networkClient: NetworkClient())
    private let reachability = ReachabilityManager()

    //MARK: - Public Func

    func getForecast(for cityId: UInt) {
        inProgress = true

        weatherClient.getForecast(id: cityId).eraseToAnyPublisher()
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

    func invalidate() {
        cancellableSet.forEach { $0.cancel() }
        cancellableSet.removeAll()
    }
}
