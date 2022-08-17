//
//  RealmClient.swift
//  weatherTestApp
//
//  Created by skostiuk on 17.08.2022.
//

import Foundation
import RealmSwift

final class RealmClient {
    //MARK: - Public Func

    func saveToDB(dto: [WeatherDTO]) {
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

    func getFromDB() -> [WeatherDB] {
        return try! Realm().objects(WeatherDB.self).map { $0 }
    }
}
