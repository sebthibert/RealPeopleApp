import UIKit

protocol SearchHeaderDelegate {
  func resetCollectionViewItems()
  func filterCollectionViewByDepartment(_ departmentText: String)
  func filterCollectionViewBySearch(_ searchText: String)
  func reloadCollectionView()
}

class SearchHeaderView: UIView {
  @IBOutlet private var contentView: UIView?
  @IBOutlet private var departmentButtonCollection: [UIButton]?

  private var selectedDepartmentButton: UIButton = UIButton()
  var delegate: SearchHeaderDelegate?
  
  @IBAction private func departmentButtonPressed(_ sender: UIButton) {
    setupDepartmentButtons()
    guard sender != selectedDepartmentButton else {
      selectedDepartmentButton = UIButton()
      delegate?.resetCollectionViewItems()
      delegate?.reloadCollectionView()
      return
    }
    sender.backgroundColor = .buttonSelectedGrey
    sender.setTitleColor(.white, for: .normal)
    selectedDepartmentButton = sender
    guard let department = sender.titleLabel?.text?.lowercased() else {
      return
    }
    delegate?.filterCollectionViewByDepartment(department)
    delegate?.reloadCollectionView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    instantiateNib()
  }

  override func awakeFromNib() {
    setupDepartmentButtons()
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
}

extension SearchHeaderView: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    setupDepartmentButtons()
    guard !searchText.isEmpty else {
      delegate?.resetCollectionViewItems()
      delegate?.reloadCollectionView()
      return
    }
    delegate?.filterCollectionViewBySearch(searchText.lowercased())
    delegate?.reloadCollectionView()
  }
}
