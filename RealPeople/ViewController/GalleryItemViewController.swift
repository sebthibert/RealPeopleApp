import UIKit

class GalleryItemViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!

  @IBAction func closeButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  var galleryItem: GalleryItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  func setupView() {
    imageView.image = galleryItem.image
  }
}

extension GalleryItemViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return products.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! ProductCollectionViewCell
    cell.addBorder()
    cell.imageView.image = products[indexPath.row].image
    cell.titleLabel.text = products[indexPath.row].title
    cell.priceLabel.text = products[indexPath.row].price
    return cell
  }
}
