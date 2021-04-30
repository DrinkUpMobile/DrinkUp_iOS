import UIKit
import Firebase


class HomeViewController: UIViewController {
    
    static let storyboardID = "HomeViewController"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dataButton: RoundedButton!
    
    @IBOutlet weak var dailyGoalLabel: UILabel!
    @IBOutlet weak var completeLabel: UILabel!
    
    var user: [String: Any]?
    
    let formatter: DateFormatter = {
        let tmpFormatter = DateFormatter()
        tmpFormatter.dateFormat = "hh:mm a"
        return tmpFormatter
    }()
    
    let dateFormatter: DateFormatter = {
        let tmpFormatter = DateFormatter()
        tmpFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return tmpFormatter
    }()
    
    lazy var wave: WaveView = {
        let view = WaveView(frame: self.view.frame, frontColor: #colorLiteral(red: 0.0932898894, green: 0.7137736678, blue: 0.9685057998, alpha: 1), backColor: #colorLiteral(red: 0.5, green: 0.9177004695, blue: 0.9920321107, alpha: 1))
        view.progress = 0.72
        view.waveHeight = 15
        view.waveDelay = 300
        return view
    }()
    
    var timer: Timer?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.addSubview(self.wave)
        self.view.sendSubviewToBack(self.wave)
        
        self.view.backgroundColor = .white
        
        self.mainLabel.addShadow(shadowRadius: 3, shadowOpacity: 1, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2), shadowOffset: CGSize(width: 0, height: 2))
        
        self.dataButton.addShadow(shadowRadius: 3, shadowOpacity: 1, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2), shadowOffset: CGSize(width: 0, height: 2))
        
        self.getTimeOfDate()
        
        (self.navigationController as? MainNavigationController)?.controllerDelegate = self
        
        /// Enables 'slide to dismiss' for views added to stack
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wave.startAnimation()
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.wave.stopAnimation()
        self.timer?.invalidate()
    }
    
    @IBAction func goToProfilePage(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: ProfileViewController.storyboardID)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    @IBAction func addVolume(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Data", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: DataNavigationController.storyboardID) as! DataNavigationController
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func goToCalendar(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: CalendarViewController.storyboardID)
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    @objc private func getTimeOfDate() {
        let curDate = Date()
        self.dateLabel.text = self.dateFormatter.string(from: curDate)
    }
}

extension HomeViewController: MainNavigationControllerDelegate {
    
    func getUserData(user: [String : Any]?) {
        self.user = user
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Firestore.firestore().collection("users").document(uid).collection("drinks").addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {
                return
            }
            
            guard let weight: NSNumber = user?["weight"] as? NSNumber else {
                return
            }
            
            let ozGoal: Double = Double(truncating: weight) * (2/3)
            let goalInML: Double = ozGoal * 29.574

            var totalWater: Double = 0
            snapshot.documents.forEach { (document) in

                if let timestamp = document.data()["timestamp"] as? Timestamp {

                    if Calendar.current.isDateInToday(timestamp.dateValue()) {
                        if let amount = document.data()["amount"] as? Double {
                            totalWater += Double(amount)
                        }
                    }

                }

            }

            let percent = (totalWater / goalInML) * 100
            
            let percentString = "\(Int(percent))".split(separator: ".")[0]
            self.mainLabel.text = (percent < 100) ? "\(percentString)%" : "100%"
            
            let subLabelString = "\(round(goalInML))".split(separator: ".")[0]
            self.subLabel.text = "of \(subLabelString) mL"
            
            let dailyGoalString = "\(round(goalInML))".split(separator: ".")[0]
            self.dailyGoalLabel.text = "\(dailyGoalString) mL"

            let completeString = "\(round(totalWater))".split(separator: ".")[0]
            self.completeLabel.text = "\(completeString) mL"
            
            if Int(percent) < 100 {
                self.statusLabel.text = "\(Int(goalInML - totalWater)) mL"
                self.statusLabel.textColor = #colorLiteral(red: 0.2666666667, green: 0.5411764706, blue: 1, alpha: 1)
            } else {
                self.statusLabel.text = "Hydrated"
                self.statusLabel.textColor = #colorLiteral(red: 0.08757872134, green: 0.74412328, blue: 0.3865558207, alpha: 1)
            }
            
        }
        
    }
    

}

extension HomeViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        /// Prevents 'slide to dismiss' for view on the root of stack
        (navigationController!.viewControllers.count > 1) ? true : false
    }
    
}
