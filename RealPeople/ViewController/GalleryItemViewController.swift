import UIKit

class GalleryItemViewController: UIViewController {
  @IBOutlet private weak var imageView: UIImageView?
  @IBOutlet private weak var dateLabel: UILabel?
  @IBOutlet private weak var submittedByLabel: UILabel?

  @IBAction private func closeButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  var galleryItem: GalleryItem?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  func setupView() {
    imageView?.image = galleryItem?.image
    dateLabel?.text = galleryItem?.date
    submittedByLabel?.text = galleryItem?.submittedBy
  }
}

extension GalleryItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return products.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
    cell.addBorder()
    cell.imageView.image = products[indexPath.row].image
    cell.titleLabel.text = products[indexPath.row].title
    cell.priceLabel.text = products[indexPath.row].price
    return cell
  }
}
