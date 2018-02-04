import UIKit

extension UIColor {
  convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
    self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
  }

  class var buttonGrey: UIColor {
    return UIColor(r: 235, g: 235, b: 235, a: 1)
  }

  class var buttonSelectedGrey: UIColor {
    return UIColor(r: 190, g: 190, b: 190, a: 1)
  }
}
