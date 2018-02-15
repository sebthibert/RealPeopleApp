import UIKit

class GalleryViewController: UIViewController {
  @IBOutlet weak var galleryCollectionView: UICollectionView!
  @IBOutlet var departmentButtonCollection: [UIButton]!
  @IBOutlet weak var borderView: UIView!
  
  @IBAction func departmentButtonPressed(_ sender: UIButton) {
    setupDepartmentButtons()

    guard let departmentText = sender.titleLabel?.text?.lowercased() else {
      return
    }

    guard sender != selectedDepartmentButton else {
      selectedDepartmentButton = UIButton()
      collectionViewItems = galleryItems
      reloadCollectionView()
      return
    }

    sender.backgroundColor = .buttonSelectedGrey
    sender.setTitleColor(.white, for: .normal)
    selectedDepartmentButton = sender

    collectionViewItems = galleryItems.filter { image -> Bool in
      return image.department == departmentText
    }

    reloadCollectionView()
  }

  let cellMargin: CGFloat = 10
  var collectionViewItems: [GalleryItem] = []
  var selectedDepartmentButton: UIButton = UIButton()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupDepartmentButtons()
    setupOverlay()
    borderView.backgroundColor = .buttonSelectedGrey
    collectionViewItems = galleryItems
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showItem", let imageModel = sender as? GalleryItem, let galleryItemViewController = segue.destination as? GalleryItemViewController {
      galleryItemViewController.galleryItem = imageModel
    }
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  func setupDepartmentButtons() {
    for button in departmentButtonCollection {
      button.backgroundColor = .buttonGrey
      button.setTitleColor(.black, for: .normal)
      button.layer.masksToBounds = true
      button.layer.cornerRadius = 8
    }
  }

  func setupOverlay() {
    let overlayView = OverlayView()
    overlayView.buttonImage = #imageLiteral(resourceName: "camera-white")
    
    overlayView.addItem("Upload your own", icon: #imageLiteral(resourceName: "camera-black"), handler: { item in
      
    })

    overlayView.addItem("Terms and conditions", icon: nil, handler: { item in

    })

    view.addSubview(overlayView)
  }

  func reloadCollectionView() {
    galleryCollectionView.reloadData()
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

    collectionViewItems = galleryItems.filter { image -> Bool in
      return image.description.contains(searchText.lowercased())
    }

    reloadCollectionView()
  }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionViewItems.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! GalleryItemCollectionViewCell
    cell.addBorder()
    cell.imageView.image = collectionViewItems[indexPath.row].image
    cell.submittedByLabel.text = collectionViewItems[indexPath.row].submittedBy
    cell.dateLabel.text = collectionViewItems[indexPath.row].date
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: cellMargin, left: cellMargin, bottom: cellMargin, right: cellMargin)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let columnCount: CGFloat = 2
    let collectionViewInsets = ((cellMargin * 2) + (cellMargin * (columnCount - 1)))
    let cellWidth = (collectionView.frame.width - collectionViewInsets) / columnCount
    let cellHeight = cellWidth + 50
    return CGSize(width: cellWidth, height: cellHeight)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let imageModel = collectionViewItems[indexPath.row]
    performSegue(withIdentifier: "showItem", sender: imageModel)
  }
}
