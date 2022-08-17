//
//  ReachabilityManager.swift
//  weatherTestApp
//
//  Created by skostiuk on 16.08.2022.
//

import Foundation
import Reachability

class ReachabilityManager {
    //MARK: - Private Properties
    private let reachability: Reachability

    //MARK: - Initializers
    init() {
        reachability = try! Reachability()
    }

    //MARK: - Public Func
    func connectionAvailable() -> Bool {
        switch reachability.connection {
        case .wifi, .cellular:
            return true
        case .unavailable:
            return false
        }
    }
}
