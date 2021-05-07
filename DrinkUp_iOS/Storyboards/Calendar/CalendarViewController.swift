import UIKit
import Firebase

class CalendarViewController: UIViewController {
    
    struct HistoryData {
        var amount: Int!
        var timestamp: Date!
    }
    
    static let storyboardID = "CalendarViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [HistoryData] = [HistoryData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets(top: -18, left: 0, bottom: 0, right: 0)
        
        self.tableView.register(UINib(nibName: HistoryCell.reuseID, bundle: nil),
                                forCellReuseIdentifier: HistoryCell.reuseID)
        self.tableView.register(UINib(nibName: HistoryDateCell.reuseID, bundle: nil),
                                forCellReuseIdentifier: HistoryDateCell.reuseID)
        
        self.getData()
        
    }
    
    private func getData() {
        Firestore.firestore()
            .collection("users")
            .document(Auth.auth().currentUser?.uid ?? "")
            .collection("drinks")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                
                if let error = error {
                    let alert = UIAlertController(title: "Something Went Wrong!", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                snapshot?.documents.forEach({ document in
                    
                    let data = HistoryData(amount: document.data()["amount"] as? Int,
                                           timestamp: (document.data()["timestamp"] as? Timestamp)?.dateValue())
                    self.data.append(data)
                    
                })
                
                self.tableView.reloadData()
        }
    }
    
    
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CalendarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = self.data[indexPath.item]
        
        if self.data.indices.contains(indexPath.item - 1) {
            if Calendar.current.isDate(data.timestamp, inSameDayAs: self.data[indexPath.item - 1].timestamp) {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseID, for: indexPath)
                (cell as? HistoryCell)?.set(date: data.timestamp)
                (cell as? HistoryCell)?.set(amount: data.amount)
                return cell
            }
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: HistoryDateCell.reuseID, for: indexPath)
        (cell as? HistoryDateCell)?.set(date: data.timestamp)
        (cell as? HistoryDateCell)?.set(amount: data.amount)
        return cell
    }
    
}
