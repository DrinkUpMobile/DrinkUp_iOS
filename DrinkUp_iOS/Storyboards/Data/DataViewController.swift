import UIKit

class DataViewController: UIViewController {
    
    static let storyboardID = "DataViewController"
    
    @IBOutlet weak var containerView: RoundedView!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: WaterInputView.reuseID, bundle: nil),
                                     forCellWithReuseIdentifier: WaterInputView.reuseID)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = CGSize(width: ((self.collectionView.frame.height - 8) / 2),
                                              height: ((self.collectionView.frame.height - 8) / 2))
        
        
        self.containerView.addShadow(shadowRadius: 3,
                                     shadowOpacity: 1,
                                     shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5),
                                     shadowOffset: CGSize(width: 0, height: 2))
    }

}

extension DataViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: WaterInputView.reuseID, for: indexPath)
        
        return cell
    }

}

extension DataViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((self.collectionView.frame.height) / 2) - 8, height: ((self.collectionView.frame.height) / 2) - 8)
    }

}
