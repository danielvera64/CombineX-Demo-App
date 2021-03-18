//
//  UIControl+Extension.swift
//  ReactiveApp
//
//  Created by Daniel Vera on 3/18/21.
//

import UIKit

/// Extending the `UIControl` types to be able to produce a `UIControl.Event` publisher.
protocol CombineCompatible { }

extension UIControl: CombineCompatible { }

extension CombineCompatible where Self: UIControl {

  var reactive: Reactive<Self> {
    Reactive(self)
  }

  static var reactive: Reactive<Self>.Type {
    Reactive<Self>.self
  }

  func publisher(for events: UIControl.Event) -> UIControlPublisher<Self> {
    return UIControlPublisher(control: self, events: events)
  }
}

public struct Reactive<Base> {
  public let base: Base

  fileprivate init(_ base: Base) {
    self.base = base
  }
}
