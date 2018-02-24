import UIKit

class SubmitOverlay: UIView {
  let overlayView : UIControl = UIControl()
  
  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    backgroundColor = .white
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    open()
    setFrame()
  }

  func open() {
    setOverlayView()
    superview?.insertSubview(overlayView, aboveSubview: self)
    superview?.bringSubview(toFront: self)
    overlayView.alpha = 1
//    popAnimationWithOpen()
//    closed = false
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

  private func setFrame() {
    center = CGPoint(x: superview!.frame.midX, y: superview!.frame.midY)
  }
}
