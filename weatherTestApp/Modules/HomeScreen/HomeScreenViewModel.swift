//
//  HomeScreenViewModel.swift
//  weatherTestApp
//
//  Created by skostiuk on 15.08.2022.
//

import Foundation
import Combine

final class HomeScreenViewModel: ObservableObject {

    //MARK: - Private Value Types
    private enum Constants {
        static let storedCitiesIds: [UInt] = [2643743,
                                              293396,
                                              5128581,
                                              2800866,
                                              3128760,
                                              2988507,
                                              1850147,
                                              1816670,
                                              2147714,
                                              3432043,
                                              4164138,
                                              6173331,
                                              524901,
                                              1609350,
                                              993800,
                                              2464470,
                                              1701668]
    }

    //MARK: - @Published Properties
    @Published var queryString = ""
    @Published var models: [WeatherDTO] = []
    @Published var inProgress = false

    //MARK: - Public Properties
    var filteredModel: [WeatherDTO] {
        if queryString.isEmpty || queryString.count < 2 {
            return models
        } else {
            let filtreModels = models.filter { model in
                return model.cityName.lowercased().range(of: queryString.lowercased()) != nil 
            }
            return filtreModels
        }
    }

    //MARK: - Private Properties
    private var cancellableSet: Set<AnyCancellable> = []
    private let weatherClient = WeatherClientImpl(networkClient: NetworkClient())
    private let reachability = ReachabilityManager()
    private let realmClient = RealmClient()

    //MARK: - Public Func
    func getWeather() {
        inProgress = true

        guard reachability.connectionAvailable() else {
            models = realmClient.getFromDB().map({ $0.asWeatherDTO })
            self.inProgress = false
            return
        }

        Constants.storedCitiesIds.map{ id in
            weatherClient.getCurrentWeather(id: id).eraseToAnyPublisher()
        }
        .publisher
        .flatMap { $0 }
        .collect()
        .sink { [weak self] error in
            DispatchQueue.main.async {
                self?.inProgress = false
            }
            print(error)
        } receiveValue: {[weak self] dto in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.models = dto
                self.realmClient.saveToDB(dto: dto)
                self.inProgress = false
            }
        }
        .store(in: &cancellableSet)
    }

    func invalidate() {
        cancellableSet.forEach { $0.cancel() }
        cancellableSet.removeAll()
    }
}
