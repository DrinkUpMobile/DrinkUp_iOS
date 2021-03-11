import UIKit
import FirebaseUI

class MainTabBarController: UITabBarController {
    
    static let storyboardID = "MainTabBarController"

    /// `viewDidLoad()` and `viewDidAppear()` are the first set of functions that will be called when a user enters a page (ie. view controller).
    /// Think of them as constuctors. In those functions you should load any data that is important for that page
    /// Example: This is a good time to load the user's hydration data
    
    
    /// Side Note: There is also `viewWillAppear()` (called before `viewDidAppear()`), `viewWillDisappear()`, `viewDidDisappear()`, etc...
    
    
    /// `viewDidLoad` is called ONCE and it is the first function called
    /// If a pop up is presented over the page, then this will NOT be called when the pop up is closed
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /// `viewDidAppear` is called after `viewDidLoad()`
    /// This function is called ever time a the page appears on screen
    /// If a pop up is presented over the page, this will be called once the page is visible to the user
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
        /// Check if the user is signed in
        /// If not, present the login page as a pop up
        guard let user = Auth.auth().currentUser else {
            self.goToLogInPage()
            return
        }
        
        
        /// If we reach this point then the user is signed in
        /// Now we need to check Firestore to see if we have collected the user's data in Firestore
        
        
        /// This line reference the collection of all users
        let usersCollection = Firestore.firestore().collection("users")
        
        
        /// These lines reference an individual user's document containing their data
        /// If the document does not exist then we need to get the rest of their data (navigate to ContinueSignUpViewController.swift)
        let userID = user.uid /// the `guard let` in line 31 allows us to use the variable `user` and guarentees that it is not nil
        let userDocument = usersCollection.document(userID)
        
        /// Now that we have the user's document reference, we need to
        /// check to see if a snapshot (the dictionary containing the data and firebase metadata) exists
        userDocument.getDocument { (snapshot, error) in
            
            if error != nil { return } // Error! This could be a network error or something...
            
            
            let doesSnapshotExist : Bool = snapshot?.exists ?? false /// snapshot is nil, default value will be `false`
            if doesSnapshotExist {
                
                
                /// If we get here then the user is successfully signed in and there is a document in Firestore for them
                print("Sign up success. Go to home page. We have data!")
                
            } else {
                
                /// Go to ContinueSignUpViewController
                self.goToGetUserData()
                
            }
        }
        
    }
    
    
    /// Call this function to navigate to the log in page
    private func goToLogInPage() {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: AuthNavigationController.storyboardID) as! AuthNavigationController
        viewController.modalPresentationStyle = .fullScreen  // covers the entire screen rather than partially (comment this out to see the difference)
        viewController.modalTransitionStyle = .crossDissolve // transition animation
        self.present(viewController, animated: true, completion: nil)
    }


    /// Call this function to navigate to the ContinueSignUpViewController
    private func goToGetUserData() {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: ContinueSignUpViewController.storyboardID) as! ContinueSignUpViewController
        viewController.modalPresentationStyle = .fullScreen  // covers the entire screen rather than partially (comment this out to see the difference)
        viewController.modalTransitionStyle = .crossDissolve // transition animation
        self.present(viewController, animated: true, completion: nil)
    }
}
