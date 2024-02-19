import UIKit

class Test2: UIViewController {



    @IBOutlet var myCollectionView: UICollectionView!
//    var dropdownManager = GetSubDropdownsManager()
//    var dropdownData: [DropdownGroup] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
//        dropdownManager.delegate = self
//        dropdownManager.getSubDropdowns(with: "1")
    }
    func registerCell() {
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(UINib(nibName: "TestingCell", bundle: nil), forCellWithReuseIdentifier: "testing")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.myCollectionView.collectionViewLayout = layout
    }
//    func didGetSubDropdowns(response: [DropdownGroup]) {
//        DispatchQueue.main.async { [self] in
//            dropdownData = response
//            myCollectionView.reloadData()
//        }
//        print("==>>response", dropdownData)
//    }
//
//    func didGetErrors(error: Error, response: HTTPURLResponse?) {
//        print("==>>error", error)
//    }

}
extension Test2: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "testing", for: indexPath) as! TestingCell
//        cell.dropdown.optionArray = dropdownData[indexPath.row].dropdownlist.map({$0.name})
//        cell.dropdown.text = dropdownData[indexPath.row].name
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.myCollectionView.layoutIfNeeded()
        return CGSize(width: 200, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedIndex = indexPath.item
        print(selectedIndex)
    }
}
