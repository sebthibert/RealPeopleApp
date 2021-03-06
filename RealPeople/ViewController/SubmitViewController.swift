import UIKit

class SubmitViewController: UIViewController {
  @IBOutlet weak var checkboxView: UIView!
  @IBOutlet weak var checkboxImageView: UIImageView!
  @IBOutlet weak var selectedImageView: UIImageView!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var submitOverlay: UIView!

  var submissionImage: UIImage!
  var submissionProducts: [Product]!
  
  @IBAction func backButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func submitButtonPressed(_ sender: Any) {
    let submission = Submission(image: submissionImage, products: submissionProducts, email: emailTextField.text ?? "", username: usernameTextField.text ?? "")
    submitOverlay.isHidden = false
    print(submission)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    selectedImageView.image = submissionImage
    setupTapGestures()
    setupTextFields()
    validate()
  }

  func setupTapGestures() {
    let checkboxTapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheckbox))
    checkboxView.addGestureRecognizer(checkboxTapGesture)
  }

  @objc func toggleCheckbox() {
    checkboxImageView.isHidden = !checkboxImageView.isHidden
    validate()
  }

  func setupTextFields() {
    emailTextField.addTarget(self, action: #selector(textValueChanged), for: .editingChanged)
    usernameTextField.addTarget(self, action: #selector(textValueChanged), for: .editingChanged)
  }

  func validate() {
    let expressions = [emailTextField.text != "", usernameTextField.text != "", checkboxImageView.isHidden == false]
    validate(expressions: expressions, toEnable: submitButton)
  }
}

extension SubmitViewController: UITextFieldDelegate {
  @objc func textValueChanged() {
    validate()
  }
}

extension SubmitViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return submissionProducts.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! ProductCollectionViewCell
    cell.imageView.image = submissionProducts[indexPath.row].image
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let columnCount: CGFloat = 6
    let cellMargin: CGFloat = 5
    let collectionViewInsets = (cellMargin * (columnCount - 1))
    let cellWidth = (collectionView.frame.width - collectionViewInsets) / columnCount
    let cellHeight = collectionView.frame.height
    return CGSize(width: cellWidth, height: cellHeight)
  }
}
