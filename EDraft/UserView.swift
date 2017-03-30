//
//  UserView.swift
//  EDraft
//
//  Created by Devin Tripp on 3/8/17.
//  Copyright © 2017 Devin Tripp. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase


class UserView: UIViewController {
    @IBAction func signOutButton(_ sender: Any) {
        do {
            try? FIRAuth.auth()?.signOut()
            
            if FIRAuth.auth()?.currentUser == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeView = storyboard.instantiateViewController(withIdentifier: "View Controller")
                self.present(homeView, animated: true, completion: nil)
                
            }
            
            
        }
        
    }
    
    @IBOutlet weak var userName: UILabel!
    
    var ref = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/")
    
    
    override func viewDidLoad() {
        //load the current user
        getUserName()
        
    }
    
    func getUserName() {
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("User").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.userName.text = username
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
}
