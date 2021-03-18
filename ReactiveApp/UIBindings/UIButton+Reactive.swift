//
//  UIButton+Reactive.swift
//  ReactiveApp
//
//  Created by Daniel Vera on 3/18/21.
//

import UIKit
import CombineX

extension Reactive where Base: UIButton {
  public var tap: AnyPublisher<Void, Never> {
    return base.publisher(for: .touchUpInside)
      .map({ _ in Void() })
      .eraseToAnyPublisher()
  }
}
