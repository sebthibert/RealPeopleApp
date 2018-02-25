import UIKit

class GalleryViewController: UIViewController {
  @IBOutlet private weak var galleryCollectionView: UICollectionView?
  @IBOutlet private var departmentButtonCollection: [UIButton]?

  private var collectionViewItems: [GalleryItem] = []
  private var selectedDepartmentButton: UIButton = UIButton()
  
  @IBAction private func departmentButtonPressed(_ sender: UIButton) {
    setupDepartmentButtons()
    guard sender != selectedDepartmentButton else {
      selectedDepartmentButton = UIButton()
      collectionViewItems = galleryItems
      reloadCollectionView()
      return
    }
    sender.backgroundColor = .buttonSelectedGrey
    sender.setTitleColor(.white, for: .normal)
    selectedDepartmentButton = sender
    guard let departmentText = sender.titleLabel?.text?.lowercased() else {
      return
    }
    collectionViewItems = galleryItems.filter { galleryItem -> Bool in
      return galleryItem.department == departmentText
    }
    reloadCollectionView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupDepartmentButtons()
    setupOverlay()
    collectionViewItems = galleryItems
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showItem", let galleryItem = sender as? GalleryItem, let galleryItemViewController = segue.destination as? GalleryItemViewController {
      galleryItemViewController.galleryItem = galleryItem
    }
  }

  private func setupDepartmentButtons() {
    guard let buttons = departmentButtonCollection else {
      return
    }
    for button in buttons {
      button.backgroundColor = .buttonGrey
      button.setTitleColor(.black, for: .normal)
      button.layer.cornerRadius = 8
    }
  }

  private func setupOverlay() {
    let overlayView = OverlayView()
    overlayView.addItem("Upload your own", icon: #imageLiteral(resourceName: "camera-black"), handler: { item in
      self.performSegue(withIdentifier: "showUpload", sender: nil)
    })
    overlayView.addItem("Terms and conditions", icon: #imageLiteral(resourceName: "info"), handler: { item in
      self.performSegue(withIdentifier: "showTermsAndConditions", sender: nil)
    })
    view.addSubview(overlayView)
  }

  private func reloadCollectionView() {
    galleryCollectionView?.reloadData()
  }
}

extension GalleryViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    setupDepartmentButtons()
    guard !searchText.isEmpty else {
      collectionViewItems = galleryItems
      reloadCollectionView()
      return
    }
    collectionViewItems = galleryItems.filter { galleryItem -> Bool in
      return galleryItem.description.contains(searchText.lowercased())
    }
    reloadCollectionView()
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
