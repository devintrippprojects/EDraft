//
//  addBets.swift
//  EDraft
//
//  Created by Devin Tripp on 3/24/17.
//  Copyright © 2017 Devin Tripp. All rights reserved.
//

import UIKit
import Foundation
import Firebase


class addBets: UIViewController, UITextFieldDelegate {
    let betRef = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/Bets")
    let userRef = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/User")
    let ref = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/")
    let currentUser = FIRAuth.auth()?.currentUser
    
    
    @IBOutlet weak var teamOneLabelAdd: UILabel!
    @IBOutlet weak var teamTwoLabelAdd: UILabel!
    
    @IBOutlet weak var teamOneBet: UITextField?
    
    @IBOutlet weak var teamTwoBet: UITextField?
    
    
    
    var userName: String?
    var teamOne: String!
    var teamTwo = String()
    
    var betNumber: String!
    var bets: Int = 0
    
    
    
    
    var teamOneBetAnotherOne: String!
    var teamOneBetAnotherTwo: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamOneLabelAdd.text = teamOne
        teamTwoLabelAdd.text = teamTwo
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        self.teamOneBet?.delegate = self
        self.teamTwoBet?.delegate = self
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("User").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.userName = username
            let betnumber = value?["bets"] as? String ?? ""
            self.betNumber = betnumber
            
            
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
 
        
    }
    
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        teamOneBet?.resignFirstResponder()
        teamTwoBet?.resignFirstResponder()
        return true
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func submitData(_ sender: Any) {
        // get the userName to tell who is doing the bet and set it as a key
    
        sleep(4)
        
        if let usernamee = self.userName {

            
            let useRef = self.betRef.childByAutoId()
            
            
            var values = ["Show":"yes","OpposingUsername": "","OpposingTeam":"","Username": usernamee,"Bet": "0", "ForTeam": ""]
            if self.teamOneBet?.text != "" {
                if let betOne = Int((self.teamOneBet?.text)!){
                    
                    takeAwayMoney(String(betOne))
                    values["Bet"] = String(betOne)
                    values["ForTeam"] = teamOneLabelAdd.text
                    values["OpposingTeam"] = teamTwoLabelAdd.text
                } else {
                    //Make an alert controller that tells the user he needs to enter in an Int
                    let alertController = UIAlertController(title: "Error", message: "Please enter in a number.", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okButton)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
            } else if self.teamTwoBet?.text != "" {
                if let betTwo = Int((self.teamTwoBet?.text)!){
                    
                    takeAwayMoney(String(betTwo))
                    values["Bet"] = String(betTwo)
                    values["ForTeam"] = teamTwoLabelAdd.text
                    values["OpposingTeam"] = teamOneLabelAdd.text
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Please enter in a number.", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okButton)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            } else {
                //alert them to let them know they didn't enter a value for any team
                let alertController = UIAlertController(title: "Error", message: "Please enter a bet for a team.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.present(alertController, animated: true, completion: nil)
                return
            }
        
        
        //self.betRef.child("Bets").setValue(self.userName)
        if let worked = currentUser?.getTokenWithCompletion() {
            
            useRef.setValue(values)
            /*
            useRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if (error != nil) {
                    print(error!)
                    return
                    
                }
                
            })
            */
            
            
            
        }
            
         sleep(1)
         self.navigationController?.popViewController(animated: true)
            
        }
        
        
    }
    
    func takeAwayMoney(_ howMuch: String){
        if let notMuch = Int(howMuch) {
            
            
            let userID = FIRAuth.auth()?.currentUser?.uid
            ref.child("User").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let money = value?["money"] as? String ?? ""
                
                //convert money to int
                if let conMoney = Int(money) {
                    var conMoreMoney = conMoney
                    if conMoreMoney < notMuch {
                        print(" sorry bitch")
                        return
                    } else {
                        conMoreMoney -= notMuch
                        let value = ["money": String(conMoreMoney)]
                        //update the users money
                        self.ref.child("User").child(userID!).updateChildValues(value)
                    }
                    
                }
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func getUserName() {
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("User").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.userName = username
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let indexPath = self.tableView.indexPathForSelectedRow!
        //var DestViewController : addBets = segue.destination as! addBets
        //DestViewController.teamOne = self.teamOne.text!
        //DestViewController.teamOne = self.teamTTwo
        
        if segue.identifier == "gotobetview" {
            if let destination = segue.destination as? BetView {
                
                //destination.userNames = self.teamOne.text! as? String
                
                //destination.teamTwo = (self.teamTwo.text! as? String)!
            }
        }
        
    }

}
