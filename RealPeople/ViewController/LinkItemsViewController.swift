import UIKit

class LinkItemsViewController: UIViewController {

  @IBOutlet weak var productSlotStackView: UIStackView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet var productSlotImages: [UIImageView]!

  let cellMargin: CGFloat = 10
  var productsSelectedCount: Int = 0
  var collectionViewSelectedCellIndexes: [IndexPath] = []

  var allProductsSelected: Bool {
    return productsSelectedCount == productSlotImages.count
  }

  @IBAction func nextButtonPressed(_ sender: Any) {
    performSegue(withIdentifier: "showSubmit", sender: nil)
  }

  @IBAction func backButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func removeSlotButtonPressed(_ sender: Any) {
    let removeButton = sender as! UIButton
    deselectProduct(at: removeButton.tag)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.allowsMultipleSelection = true
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showSubmit" {}
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  func selectProduct(_ selectedProduct: Product) {
    guard !allProductsSelected else {
      return
    }
    var index = productSlotImages.count
    for slot in productSlotImages.reversed() {
      if !slot.isHidden {
        slot.image = selectedProduct.image
        addRemoveButton(to: slot)
        productsSelectedCount += 1
        if index == productSlotImages.count {
          return
        } else {
          productSlotImages[index].isHidden = false
          return
        }
      }
      index -= 1
    }
  }

  func deselectProduct(at index: Int) {
    let slotImage = productSlotImages[index]
    slotImage.superview?.removeFromSuperview()
    productSlotImages.remove(at: index)
    updateRemoveButtonTags(after: index)
    let indexPath = collectionViewSelectedCellIndexes[index]
    updateCollectionView(at: indexPath)
    collectionViewSelectedCellIndexes.remove(at: index)
    productsSelectedCount -= 1
    let isHidden = productsSelectedCount == productSlotImages.count ? false : true
    appendNewSlot(isHidden: isHidden)
  }

  func addRemoveButton(to slot: UIView) {
    let removeButton = UIButton(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
    removeButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
    removeButton.addTarget(self, action: #selector(removeSlotButtonPressed), for: .touchUpInside)
    removeButton.isEnabled = true
    removeButton.tag = productsSelectedCount
    slot.addSubview(removeButton)
  }

  func appendNewSlot(isHidden: Bool) {
    let view = UIView()
    view.isUserInteractionEnabled = true
    let imageView = UIImageView(image: #imageLiteral(resourceName: "placeholder"))
    imageView.isHidden = isHidden
    imageView.isUserInteractionEnabled = true
    productSlotImages.append(imageView)
    view.addSubview(imageView)
    productSlotStackView.addArrangedSubview(view)
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.5)])
    imageView.translatesAutoresizingMaskIntoConstraints = false
  }

  func updateRemoveButtonTags(after tag: Int) {
    for slot in productSlotImages {
      for view in slot.subviews {
        if view is UIButton {
          if view.tag > tag {
            view.tag -= 1
          }
        }
      }
    }
  }

  func updateCollectionView(at indexPath: IndexPath) {
    collectionView.reloadItems(at: [indexPath])
  }
}

extension LinkItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let columnCount: CGFloat = 4
    let collectionViewInsets = (cellMargin * (columnCount - 1))
    let cellWidth = (collectionView.frame.width - collectionViewInsets) / columnCount
    let cellHeight = cellWidth * 2
    return CGSize(width: cellWidth, height: cellHeight)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard !allProductsSelected else {
      return
    }
    collectionView.cellForItem(at: indexPath)?.addBorder(width: 3, color: .black)
    collectionViewSelectedCellIndexes.append(indexPath)
    selectProduct(products[indexPath.row])
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    guard let index = collectionViewSelectedCellIndexes.index(of: indexPath) else {
      return
    }
    deselectProduct(at: index)
    updateCollectionView(at: indexPath)
  }
}