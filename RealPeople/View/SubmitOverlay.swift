import UIKit

class SubmitOverlay: UIView {
  let overlayView : UIControl = UIControl()

  @IBAction func doneButtonPressed(_ sender: Any) {
    guard let appWindow = window else {
      return
    }
    appWindow.rootViewController?.dismiss(animated: true, completion: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    instantiateNib()
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    openOverlay()
  }

  func openOverlay() {
    setOverlayView()
    superview?.insertSubview(overlayView, aboveSubview: self)
    superview?.bringSubview(toFront: self)
    overlayView.alpha = 1
  }

  private func setOverlayView() {
    setOverlayFrame()
    overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    overlayView.alpha = 0
    overlayView.isUserInteractionEnabled = true
  }

  private func setOverlayFrame() {
    if let superview = superview {
      overlayView.frame = CGRect(x: 0,y: 0, width: superview.bounds.width, height: superview.bounds.height)
    }
  }
}
