//
//  UISwitch+Reactive.swift
//  ReactiveApp
//
//  Created by Daniel Vera on 3/18/21.
//

import UIKit
import CombineX

extension Reactive where Base: UISwitch {
  public var isOn: AnyPublisher<Bool, Never> {
    return base.publisher(for: .valueChanged)
      .map({ $0.isOn })
      .eraseToAnyPublisher()
  }
}
