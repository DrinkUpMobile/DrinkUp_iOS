





import Firebase

struct Drink {
    var amount: Int!
    var timestamp: Timestamp!
}

class HydrationAPI {
    
    private static let database = Firestore.firestore()
    private static var userDocument: DocumentReference? {
        get {
            guard let uid = Auth.auth().currentUser?.uid else {
                return nil
            }
            return self.database.collection("users").document(uid)
        }
    }
    
    
    static func addDrink(amount: Decimal, _ completion: @escaping (_ error: Error?) -> Void) {
        
        /// Error if user is not signed in
        if self.userDocument == nil {
            fatalError()
        }
        
        let newDrinkDocument = self.userDocument!.collection("drinks").document()
        
        let data: [String: Any] = [
            "timestamp": NSDate(),
            "amount": amount,
        ]
        
        newDrinkDocument.setData(data, merge: true) { (error) in
            completion(error)
        }
    }
    
    
    static func getAll(_ completion: @escaping (_ data: [Drink], _ error: Error?) -> Void) {
        /// Error if user is not signed in
        guard let userDocument = self.userDocument else {
            fatalError()
        }
        
        userDocument.collection("drinks").addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion([], error)
                return
            }
            
            guard let snapshot = snapshot else {
                completion([], nil)
                return
            }
            
            var data: [Drink] = []
            
            snapshot.documents.forEach { (document) in
                let drink = Drink(amount: document.data()["amount"] as? Int,
                                  timestamp: document.data()["timestamp"] as? Timestamp)
                data.append(drink)
            }
            
            completion(data, nil)
        }
    }
    
}
