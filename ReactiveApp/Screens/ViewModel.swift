//
//  ViewModel.swift
//  ReactiveApp
//
//  Created by Daniel Vera on 3/18/21.
//

import Foundation
import CombineX

class ViewModel {

  let storeListSubject = PassthroughSubject<[Store], Never>()

  private let service = AppService()
  private var getStoresCancellable: AnyCancellable?

  func getStores() {
    getStoresCancellable?.cancel()
    getStoresCancellable = service.getStores()
      .map({ result in (try? result.get()) ?? [] })
      .sink(receiveValue: { [weak self] in self?.storeListSubject.send($0) })
  }
  
}
