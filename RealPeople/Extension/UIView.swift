import UIKit

extension UIView {
  func addBorder(width: CGFloat = 1, color: UIColor = .buttonSelectedGrey, cornerRadius: CGFloat = 0) {
    self.layer.borderColor = color.cgColor
    self.layer.borderWidth = width
    self.layer.cornerRadius = cornerRadius
  }
}
