





import UIKit

class ProfileViewController: UIViewController {
    
    static let storyboardID = "ProfileViewController"

    @IBOutlet weak var headerContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerContainerView.addShadow(shadowRadius: 3, shadowOpacity: 1, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2), shadowOffset: CGSize(width: 0, height: 2))

       
    }
    
    @IBAction func close(_ sender: Any) {
        guard let navigationController = self.navigationController else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        navigationController.popViewController(animated: true)
    }
    
}
