import UIKit

class GalleryViewController: UIViewController {
  @IBOutlet private weak var searchHeaderView: SearchHeaderView?
  @IBOutlet private weak var galleryCollectionView: UICollectionView?

  private var collectionViewItems: [GalleryItem] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    setupOverlay()
    collectionViewItems = galleryItems
    searchHeaderView?.delegate = self
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showItem", let galleryItem = sender as? GalleryItem, let galleryItemViewController = segue.destination as? GalleryItemViewController {
      galleryItemViewController.galleryItem = galleryItem
    }
  }

  private func setupOverlay() {
    let uploadFloatingAction = FloatingActionView()
    uploadFloatingAction.buttonImage = #imageLiteral(resourceName: "camera-white")
    uploadFloatingAction.addItem("Upload your own", icon: #imageLiteral(resourceName: "camera-black"), handler: { item in
      self.performSegue(withIdentifier: "showUpload", sender: nil)
    })
    uploadFloatingAction.addItem("Terms and conditions", icon: #imageLiteral(resourceName: "info"), handler: { item in
      self.performSegue(withIdentifier: "showTermsAndConditions", sender: nil)
    })
    view.addSubview(uploadFloatingAction)
  }
}

extension GalleryViewController: SearchHeaderDelegate {
  func resetCollectionViewItems() {
    collectionViewItems = galleryItems
  }
  
  func filterCollectionViewByDepartment(_ departmentText: String) {
    collectionViewItems = galleryItems.filter { galleryItem -> Bool in
      return galleryItem.department == departmentText
    }
  }

  func filterCollectionViewBySearch(_ searchText: String) {
    collectionViewItems = galleryItems.filter { galleryItem -> Bool in
      return galleryItem.description.contains(searchText)
    }
  }

  func reloadCollectionView() {
    galleryCollectionView?.reloadData()
  }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionViewItems.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryItemCollectionViewCell", for: indexPath) as! GalleryItemCollectionViewCell
    cell.addBorder()
    cell.imageView.image = collectionViewItems[indexPath.row].image
    cell.submittedByLabel.text = collectionViewItems[indexPath.row].submittedBy
    cell.dateLabel.text = collectionViewItems[indexPath.row].date
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: LayoutHelper.galleryCellMargin, left: 0, bottom: 0, right: 0)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let collectionViewInsets = (LayoutHelper.galleryCellMargin * (LayoutHelper.galleryColumnCount - 1))
    let cellWidth = (collectionView.frame.width - collectionViewInsets) / LayoutHelper.galleryColumnCount
    let cellHeight = cellWidth + LayoutHelper.galleryCellHeight
    return CGSize(width: cellWidth, height: cellHeight)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let galleryItem = collectionViewItems[indexPath.row]
    performSegue(withIdentifier: "showItem", sender: galleryItem)
  }
}
