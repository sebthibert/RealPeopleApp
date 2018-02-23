import UIKit

class UploadViewController: UIViewController {
  @IBOutlet var largeUploadOptionViews: [UIView]!
  @IBOutlet weak var largeCameraView: UIView!
  @IBOutlet weak var largeInstagramView: UIView!
  @IBOutlet weak var largeFacebookView: UIView!
  @IBOutlet var smallUploadOptionViews: [UIView]!
  @IBOutlet weak var smallStackView: UIStackView!
  @IBOutlet weak var smallCameraView: UIView!
  @IBOutlet weak var smallInstagramView: UIView!
  @IBOutlet weak var smallFacebookView: UIView!
  @IBOutlet weak var selectedImageView: UIImageView!

  let imagePicker = UIImagePickerController()

  @IBAction func closeButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func nextButtonPressed(_ sender: Any) {
    performSegue(withIdentifier: "showAddItems", sender: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
    setupTapGestures()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    smallStackView.isHidden ? showViews(largeUploadOptionViews) : showViews(smallUploadOptionViews)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    hideViews(largeUploadOptionViews)
    hideViews(smallUploadOptionViews)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showAddItems" {}
  }

  func setupTapGestures() {
    let largeCameraTapGesture = UITapGestureRecognizer(target: self, action: #selector(cameraTapped))
    let largeInstagramTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
    let largeFacebookTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
    largeCameraView.addGestureRecognizer(largeCameraTapGesture)
    largeInstagramView.addGestureRecognizer(largeInstagramTapGesture)
    largeFacebookView.addGestureRecognizer(largeFacebookTapGesture)
    let smallCameraTapGesture = UITapGestureRecognizer(target: self, action: #selector(cameraTapped))
    let smallInstagramTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
    let smallFacebookTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
    smallCameraView.addGestureRecognizer(smallCameraTapGesture)
    smallInstagramView.addGestureRecognizer(smallInstagramTapGesture)
    smallFacebookView.addGestureRecognizer(smallFacebookTapGesture)
  }

  @objc func cameraTapped() {
    imagePicker.allowsEditing = true
    imagePicker.sourceType = .photoLibrary
    present(imagePicker, animated: true, completion: nil)
  }

  @objc func tapped() {
    print("To be implemented")
  }

  func showViews(_ views: [UIView]) {
    var delay = 0.0
    for view in views {
      UIView.animate(withDuration: 0.15, delay: delay, options: [], animations: {
        view.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        view.alpha = 1
      })
      delay += 0.1
    }
    delay = 0.0
    for view in views {
      UIView.animate(withDuration: 0.15, delay: delay, options: [], animations: {
        view.transform = CGAffineTransform.identity
      })
      delay += 0.1
    }
  }

  func hideViews(_ views: [UIView]) {
    var delay = 0.0
    for view in views {
      UIView.animate(withDuration: 0.15, delay: delay, options: [], animations: {
        view.alpha = 0
      })
      delay += 0.1
    }
  }
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      selectedImageView.isHidden = false
      selectedImageView.contentMode = .scaleAspectFit
      selectedImageView.image = selectedImage
      smallStackView.isHidden = false
    }

    dismiss(animated: true, completion: nil)
  }
}
