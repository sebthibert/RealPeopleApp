import UIKit

protocol SelectedProductCollectionViewDelegate {
  func updateCollectionView()
}

class SelectedProductView: UIView {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var instructionLabel: UILabel!
  
  var selectedItems: [Product] = []
  var delegate: SelectedProductCollectionViewDelegate?

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    instantiateNib()
  }

  override func awakeFromNib() {
    let nibName = UINib(nibName: "SelectedProductCollectionViewCell", bundle: nil)
    collectionView.register(nibName, forCellWithReuseIdentifier: "SelectedProductCollectionViewCell")
  }
}

extension SelectedProductView: SelectedProductCellDelegate {
  func removeProduct(at index: Int) {
    selectedItems.remove(at: index)
    collectionView.reloadData()
    delegate?.updateCollectionView()
  }
}

extension SelectedProductView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let shouldHideLabel = selectedItems.count == 0 ? false : true
    instructionLabel.isHidden = shouldHideLabel
    return selectedItems.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedProductCollectionViewCell", for: indexPath) as! SelectedProductCollectionViewCell
    cell.delegate = self
    cell.selectedImageView.image = selectedItems[indexPath.row].image
    cell.removeButton.isHidden = false
    cell.removeButton.tag = indexPath.row
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let columnCount: CGFloat = 6
    let cellMargin: CGFloat = 10
    let collectionViewInsets = (cellMargin * (columnCount - 1))
    let cellWidth = (collectionView.frame.width - collectionViewInsets) / columnCount
    let cellHeight = collectionView.frame.height
    return CGSize(width: cellWidth, height: cellHeight)
  }
}
