import UIKit

class SubmitViewController: UIViewController {
  @IBOutlet weak var checkboxView: UIView!
  @IBOutlet weak var checkboxImageView: UIImageView!
  
  @IBAction func backButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTapGestures()
  }

  func setupTapGestures() {
    let checkboxTapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheckbox))
    checkboxView.addGestureRecognizer(checkboxTapGesture)
  }

  @objc func toggleCheckbox() {
    checkboxImageView.isHidden = !checkboxImageView.isHidden
  }
}

extension SubmitViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 6
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! ProductCollectionViewCell
    cell.imageView.image = products[indexPath.row].image
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
