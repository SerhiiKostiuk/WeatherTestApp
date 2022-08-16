//
//  WeatherDB.swift
//  weatherTestApp
//
//  Created by skostiuk on 16.08.2022.
//

import Foundation
import RealmSwift

class WeatherDB: Object {
    @Persisted var date: TimeInterval
    @Persisted var coordinates: CoordinatesDB?
    @Persisted var weatherInfo: List<WeatherInfoDB>
    @Persisted var weatherMain: WeatherMainDB?
    @Persisted var cityId: Int
    @Persisted var cityName: String

    convenience init(dto: WeatherDTO) {
        self.init()
        self.date = dto.date
        self.coordinates = CoordinatesDB(dto: dto.coordinates)
        let weatherInfoDB = dto.weatherInfo.map({ info in
            WeatherInfoDB(dto: info)
        })
        self.weatherInfo.append(objectsIn: weatherInfoDB)
        self.weatherMain = WeatherMainDB(dto: dto.weatherMain)
        self.cityId = Int(dto.cityId)
        self.cityName = dto.cityName
    }
}


class CoordinatesDB: Object {
    @Persisted var latitude: Double
    @Persisted var longitude: Double

    convenience init(dto: CoordinatesDTO) {
        self.init()
        self.latitude = dto.latitude
        self.longitude = dto.longitude
    }
}

class WeatherInfoDB: Object {
    @Persisted var descript: String
    @Persisted var iconName: String
    @Persisted var id = UUID().uuidString

    convenience init(dto: WeatherInfoDTO) {
        self.init()
        self.descript = dto.description
        self.iconName = dto.iconName
    }
}

class WeatherMainDB: Object {
    @Persisted var temp: Double
    @Persisted var minTemp: Double
    @Persisted var maxTemp: Double

    convenience init(dto: WeatherMainDTO) {
        self.init()
        self.temp = dto.temp
        self.minTemp = dto.minTemp
        self.maxTemp = dto.maxTemp
    }
}

extension WeatherDB {
    var asWeatherDTO: WeatherDTO {
        return WeatherDTO(date: self.date,
                          coordinates: CoordinatesDTO(latitude: self.coordinates?.latitude ?? 0,
                                                      longitude: self.coordinates?.longitude ?? 0),
                          weatherInfo: self.weatherInfo.map({ weatherInfo in
            WeatherInfoDTO(description: weatherInfo.description, iconName: weatherInfo.iconName)
        }),
                          weatherMain: WeatherMainDTO(temp: self.weatherMain?.temp ?? 0,
                                                      minTemp: self.weatherMain?.minTemp ?? 0,
                                                      maxTemp: self.weatherMain?.maxTemp ?? 0),
                          cityId: UInt(self.cityId),
                          cityName: self.cityName)
    }
}
