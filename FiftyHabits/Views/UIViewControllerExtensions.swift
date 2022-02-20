//
//  UIViewControllerExtensions.swift
//  FiftyHabits
//
//  Created by Khalid Kamil on 9/9/20.
//

import UIKit

extension UIViewController {
  static func instantiate() -> Self {
    return self.init(nibName: String(describing: self), bundle: nil)
  }
}
