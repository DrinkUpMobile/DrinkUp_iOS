//
//  FirebaseAuthManager.swift
//  FirebaseStarterApp
//
//  Created by Florian Marcu on 2/23/19.
//  Copyright © 2019 Instamobile. All rights reserved.
//

import FirebaseAuth
import UIKit

class FirebaseAuthManager {

    static func login(credential: AuthCredential, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Auth.auth().signIn(with: credential, completion: { (firebaseUser, error) in
            completionBlock(error == nil, error)
        })
    }

    static func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                completionBlock(true, error)
            } else {
                completionBlock(false, error)
            }
        }
    }

    static func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false, error)
            } else {
                completionBlock(true, error)
            }
        }
    }
    
}
