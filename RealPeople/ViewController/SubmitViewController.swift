import UIKit

class SubmitViewController: UIViewController {

  @IBAction func backButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }
}
