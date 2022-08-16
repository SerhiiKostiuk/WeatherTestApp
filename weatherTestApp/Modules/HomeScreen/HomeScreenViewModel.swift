//
//  HomeScreenViewModel.swift
//  weatherTestApp
//
//  Created by skostiuk on 15.08.2022.
//

import Foundation
import Combine
import RealmSwift

final class HomeScreenViewModel: ObservableObject {

    //MARK: - Private Static Properties

    private enum Constants {
        static let baseUrl = "https://api.openweathermap.org/data/2.5/"
        static let weatherPart = "weather"
        static let forecastPart = "forecast"
        static let apiKey = "0cd74bf29e43ef1ad6afd6861cc99eb2"
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
                return model.cityName.contains(queryString)
            }
            return filtreModels
        }
    }


    //MARK: - Private Properties
    private var cancellableSet: Set<AnyCancellable> = []
    private let networkClient = NetworkClient()
    private let reachability = ReachabilityManager()

    //MARK: - Public Func

    func getWeather() {
        inProgress = true

        guard reachability.connectionAvailable() else {
            models = getFromDB().map({ $0.asWeatherDTO })
            self.inProgress = false
            return
        }

        Constants.storedCitiesIds.map{ id in
            networkClient.getCurrentWeather(path: getPath(id: id)).eraseToAnyPublisher()
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
                self.saveToDB(dto: dto)
                self.inProgress = false
            }
        }
        .store(in: &cancellableSet)
    }

    func invalidate() {
        cancellableSet.forEach { $0.cancel() }
        cancellableSet.removeAll()
    }

    //MARK: - Private Func

    private func getPath(id: UInt) -> String {
        "\(Constants.baseUrl)\(Constants.weatherPart)?id=\("\(id)")&appid=\(Constants.apiKey)"
    }

    private func saveToDB(dto: [WeatherDTO]) {
        let localRealm = try! Realm()
        try! localRealm.write {
            localRealm.deleteAll()
        }

        dto.forEach { weatherDTO in
            try! localRealm.write({
                localRealm.add(WeatherDB(dto: weatherDTO))
            })
        }
    }

    private func getFromDB() -> [WeatherDB] {
        return try! Realm().objects(WeatherDB.self).map { $0 }
    }
}
