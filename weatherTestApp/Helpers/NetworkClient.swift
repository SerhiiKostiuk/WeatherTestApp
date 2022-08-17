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
    func request<T: Decodable>(with path: String) -> AnyPublisher<T, Error>
}

final class NetworkClient: ApiClient {
    //MARK: - Public Func
    func request<T: Decodable>(with path: String) -> AnyPublisher<T, Error> {
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
                   let dto = try? JSONDecoder().decode(T.self, from: data)  {

                    promise(.success(dto))
                } else {
                    promise(.failure(ApiError.somethingWentWrong))
                }
            }

            task.resume()
        })
    }
}
