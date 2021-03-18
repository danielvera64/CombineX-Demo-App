//
//  AppService.swift
//  ReactiveApp
//
//  Created by Daniel Vera on 3/18/21.
//

import Foundation
import CombineX
import CXFoundation

typealias StoreResult = Result<[Store], Error>

class AppService {

  private let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
  private let decoder = JSONDecoder()
  private let baseURL = "https://www.cheapshark.com"

  func getStores() -> AnyPublisher<StoreResult, Never> {
    var request = URLRequest(url: URL(string: baseURL + "/api/1.0/stores")!)
    request.httpMethod = "GET"
    
    return session.cx.dataTaskPublisher(for: request)
      .tryMap(\.data)
      .decode(type: [Store].self, decoder: decoder.cx)
      .flatMap({ value -> AnyPublisher<StoreResult, Never> in
        Just(.success(value)).eraseToAnyPublisher()
      }).catch({ error -> AnyPublisher<StoreResult, Never> in
        Just(.failure(error)).eraseToAnyPublisher()
      })
      .receive(on: DispatchQueue.main.cx)
      .eraseToAnyPublisher()
  }

}
