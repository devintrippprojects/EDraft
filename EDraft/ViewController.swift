//
//  ViewController.swift
//  EDraft
//
//  Created by Devin Tripp on 12/4/16.
//  Copyright © 2016 Devin Tripp. All rights reserved.
//

//UP NEXT
/*
 delete all the bets before getting the bets //Done
 maybe find a new way to store the bets so that they always show in the same positions //Done using OBJECTS
 make the table cell fade away when its deleted instead of disapearing //Halfway done
 
 
 convert code into mvc // LITTLE BIT
 watch swift standford videos // Watched: 1, half of 2
 in the upcoming view change the bets //Done!
 
 
 don't allow the user to make a bet with himself that way there are no upcoming bet logic errors
 fix the logic error that does not display all the bets after making a bet
 
 after making the upcoming bets work make the logic for the times in the bets
 add the time and the dates for each bet when a bet is made then check that time in upcoming
 
 
 
 
 */

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    let datRef = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/")
    let ti = UIImageView()
    let image : UIImage = UIImage()
    let currentUser = FIRAuth.auth()?.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser?.getTokenForcingRefresh(true) {idToken, error in
            if let error = error {
                //handle error
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeView = storyboard.instantiateViewController(withIdentifier: "tabview")
            self.present(homeView, animated: true, completion: nil)
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
 
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signIn(_ sender: AnyObject) {
        if self.emailField.text == "" || self.passwordField.text == "" {
            let alertController = UIAlertController(title: "OOPS!", message: "You must enter in all fields.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                
                if error == nil {
                    
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    self.userNameField.text = ""
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeView = storyboard.instantiateViewController(withIdentifier: "tabview")
                    self.present(homeView, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "OOPS!", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
            
            
            
        }
    }

    @IBAction func createAccount(_ sender: AnyObject) {
        if emailField.text == "" || self.userNameField.text == "" || self.passwordField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            guard let email = emailField.text else {
                return
            }
            guard let password = passwordField.text else {
                return
            }
            guard let username = userNameField.text else {
                return
            }
            //thisUser.userName = userNameField.text!
            FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //Save the information to the database
                    guard let uid = user?.uid else {
                        print("Erorr while creating the user")
                        return
                    }
                    
                    let userRef = self.datRef.child("User").child(uid)
                    let values = ["username": username, "email": email, "firstname": "", "lastname": "","bets": "0", "money": "100"]
                    
                    userRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                        if (error != nil) {
                            print(error!)
                            return
                            
                        }
                        
                    })
                    
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeView = storyboard.instantiateViewController(withIdentifier: "tabview")
                    self.present(homeView, animated: true, completion: nil)
                    
                    
                    //let vc = self.storyboard?.instantiateViewController(withIdentifier: "Tab Bar Controller")
                    //self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    

}

