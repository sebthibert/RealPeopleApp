import UIKit

protocol SelectedProductCellDelegate {
  func removeProduct(at index: Int)
}

class SelectedProductCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var selectedImageView: UIImageView!
  @IBOutlet weak var removeButton: UIButton!
  var delegate: SelectedProductCellDelegate?

  @IBAction func removeButtonPressed(_ sender: Any) {
    delegate?.removeProduct(at: removeButton.tag)
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    removeButton.isHidden = true
  }
}
