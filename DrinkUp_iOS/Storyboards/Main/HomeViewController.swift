import UIKit

class HomeViewController: UIViewController {
    
    static let storyboardID = "HomeViewController"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dataButton: RoundedButton!
    
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
        let view = WaveView(frame: self.view.frame, color: UIColor.white.withAlphaComponent(0.25))
        view.progress = 0.5
        view.waveHeight = 15
        view.waveDelay = 300
        return view
    }()
    
    var timer: Timer?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.addSubview(self.wave)
        self.view.sendSubviewToBack(self.wave)
        
        self.dataButton.addShadow(shadowRadius: 3, shadowOpacity: 1, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2), shadowOffset: CGSize(width: 0, height: 2))
        
        self.getTimeOfDate()
        self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.getTimeOfDate), userInfo: nil, repeats: true)

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
    
    @IBAction func addVolume(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Data", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: DataNavigationController.storyboardID) as! DataNavigationController
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc private func getTimeOfDate() {
        let curDate = Date()
        self.timeLabel.text = self.formatter.string(from: curDate)
        self.dateLabel.text = self.dateFormatter.string(from: curDate)
    }

}
