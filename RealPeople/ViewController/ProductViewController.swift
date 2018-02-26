import UIKit

class ProductViewController: UIViewController {
  @IBOutlet weak var searchHeaderView: SearchHeaderView!
  @IBOutlet weak var selectedProductView: SelectedProductView!
  @IBOutlet weak var productCollectionView: UICollectionView!
  @IBOutlet weak var nextButton: UIButton!

  var submissionImage: UIImage!
  var selectedDepartmentButton: UIButton = UIButton()
  var collectionViewItems: [Product] = []

  @IBAction func nextButtonPressed(_ sender: Any) {
    performSegue(withIdentifier: "showSubmit", sender: nil)
  }

  @IBAction func backButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    validate()
    productCollectionView.allowsMultipleSelection = true
    collectionViewItems = products
    searchHeaderView.delegate = self
    selectedProductView.delegate = self
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showSubmit", let submitViewController = segue.destination as? SubmitViewController {
      submitViewController.submissionImage = submissionImage
      submitViewController.submissionProducts = selectedProductView.selectedItems
    }
  }

  func validate() {
    guard selectedProductView.selectedItems.count > 0 else {
      nextButton.isEnabled = false
      nextButton.alpha = 0
      return
    }

    nextButton.isEnabled = true
    nextButton.alpha = 1
  }
}

extension ProductViewController: SearchHeaderDelegate {
  func resetCollectionViewItems() {
    collectionViewItems = products
  }

  func filterCollectionViewByDepartment(_ departmentText: String) {
    collectionViewItems = products.filter { product -> Bool in
      return product.department == departmentText
    }
  }

  func filterCollectionViewBySearch(_ searchText: String) {
    collectionViewItems = products.filter { product -> Bool in
      return product.title.lowercased().contains(searchText)
    }
  }

  func reloadCollectionView() {
    productCollectionView.reloadData()
  }
}

extension ProductViewController: SelectedProductCollectionViewDelegate {
  func updateCollectionView() {
    productCollectionView.reloadData()
  }
}

extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionViewItems.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! ProductCollectionViewCell
    cell.imageView.image = collectionViewItems[indexPath.row].image
    cell.titleLabel.text = collectionViewItems[indexPath.row].title
    cell.priceLabel.text = collectionViewItems[indexPath.row].price
    let productSelected = selectedProductView.selectedItems.contains { product -> Bool in
      return product.title == cell.titleLabel.text
    }
    let borderWidth: CGFloat = productSelected ? 2 : 1
    let borderColor: UIColor = productSelected ? .black  : .buttonSelectedGrey
    cell.addBorder(width: borderWidth, color: borderColor)
    cell.cellSelected = productSelected
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let columnCount: CGFloat = 4
    let cellMargin: CGFloat = 10
    let collectionViewInsets = (cellMargin * (columnCount - 1))
    let cellWidth = (collectionView.frame.width - collectionViewInsets) / columnCount
    let cellHeight = cellWidth * 2
    return CGSize(width: cellWidth, height: cellHeight)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    select(collectionView: collectionView, indexPath: indexPath)
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    deselect(collectionView: collectionView, indexPath: indexPath)
  }

  func select(collectionView: UICollectionView, indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! ProductCollectionViewCell
    guard !cell.cellSelected else {
      deselect(collectionView: collectionView, indexPath: indexPath)
      cell.cellSelected = false
      return
    }
    cell.addBorder(width: 2, color: .black)
    cell.cellSelected = true
    selectedProductView.selectedItems.append(collectionViewItems[indexPath.row])
    selectedProductView.collectionView.reloadData()
    validate()
  }

  func deselect(collectionView: UICollectionView, indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! ProductCollectionViewCell
    guard cell.cellSelected else {
      select(collectionView: collectionView, indexPath: indexPath)
      cell.cellSelected = true
      return
    }
    cell.addBorder()
    cell.cellSelected = false
    let productIndex = selectedProductView.selectedItems.index { product -> Bool in
      return product.title == cell.titleLabel.text
    }
    guard let index = productIndex else {
      return
    }
    selectedProductView.selectedItems.remove(at: index)
    selectedProductView.collectionView.reloadData()
    validate()
  }
}
