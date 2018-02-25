import UIKit

extension UIView {
  func instantiateNib() {
    let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
    guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
      return
    }
    view.frame = bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(view)
  }

  func addBorder(width: CGFloat = 1, color: UIColor = .buttonSelectedGrey, cornerRadius: CGFloat = 0) {
    self.layer.borderColor = color.cgColor
    self.layer.borderWidth = width
    self.layer.cornerRadius = cornerRadius
  }
}
