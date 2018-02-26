import UIKit

extension UIViewController {
  func validate(expressions: [Bool], toEnable button: UIButton) {
    for expression in expressions {
      guard expression else {
        button.isEnabled = false
        button.alpha = 0
        return
      }
    }

    button.isEnabled = true
    button.alpha = 1
  }
}
