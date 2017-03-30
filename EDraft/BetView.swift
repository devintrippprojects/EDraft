//
//  BetView.swift
//  EDraft
//
//  Created by Devin Tripp on 3/20/17.
//  Copyright © 2017 Devin Tripp. All rights reserved.
//

import UIKit
import Foundation
import Firebase


class BetView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var teamOne: UILabel!
    @IBOutlet weak var teamTwo: UILabel!
    let datRef = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/")
    var userName = String()
    var userNames: [String] = []
    var amountBets: [String] = []
    var tieBetToUser: [String] = []
    var opposingUserNames: String?
    var userHasMoney = true
    
    var testies: String?
    
    var teamTOne = String()
    var teamTTwo = String()
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: 50))
    let navItem = UINavigationItem(title: "Place Bet")
        
    
    let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: nil, action: #selector(sayHello(sender:)))
    
    
    let backItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(goBack(sender:)))
    
    var checkIfRanAlready = true
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(navBar)
        self.tableView.separatorStyle = .none
        
        navItem.rightBarButtonItem = doneItem
        navItem.leftBarButtonItem = backItem
        navBar.setItems([navItem], animated: false)
        
        teamOne.text = teamTOne
        teamTwo.text = teamTTwo
        getBetsFor(completion: { (result: Bool?) in
            guard let resultGot = result else {
                return
            }
            
        })
        
        
    }
    
    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return true
    }
    
    
    func checkForNo(_ index: Int) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        datRef.child("User").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.userName = username
            
            // ...
            
            
            self.datRef.child("Bets").observe(.childAdded, with: { snapshot in
                //
                // this is the unique identifier of the bet.  eg, -Kfx81GvUxoHpmmMwJ9P
                
                let betId = snapshot.key as String
                guard let dict = snapshot.value as? [String: AnyHashable] else {
                    print("failed to get dictionary from Bets.\(self.userName)")
                    return
                }
               
                
                
                
                
                // do something with the above information!
                
            })
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getBetsFor(completion: @escaping(_ some: Bool) -> Void) {
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        datRef.child("User").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.userName = username
            
            // ...
            
            
            self.datRef.child("Bets").observe(.childAdded, with: { snapshot in
                //
                // this is the unique identifier of the bet.  eg, -Kfx81GvUxoHpmmMwJ9P
                
                let betId = snapshot.key as String
                guard let dict = snapshot.value as? [String: AnyHashable] else {
                    print("failed to get dictionary from Bets.\(self.userName)")
                    return
                }
                if let show = dict["Show"] as? String {
                    
                    let bet = dict["Bet"] as! String
                    let usernama = dict["Username"] as! String
                    _ = dict["ForTeam"] as? String
                
                    if show == "yes" {
                        self.amountBets.append(bet)
                        self.userNames.append(usernama)
                        self.tieBetToUser.append(betId)
                        self.tableView.reloadData()
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
                
                
                
                
                // do something with the above information!
                
            })
        }) { (error) in
            print(error.localizedDescription)
        }
    
    }
    
    func updateBet(_ index: Int, completion: @escaping (_ something: Bool?) -> Void) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        datRef.child("User").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            // ...
            
            
            self.datRef.child("Bets").observe(.childAdded, with: { snapshot in
                //
                // this is the unique identifier of the bet.  eg, -Kfx81GvUxoHpmmMwJ9P
                guard let dict = snapshot.value as? [String: AnyHashable] else {
                    print("failed to get dictionary from Bets.\(self.userName)")
                    return
                }
                let values = ["OpposingUsername": self.userName,"Show": "no"]
                
                
                self.datRef.child("Bets").child(self.tieBetToUser[index]).updateChildValues(values)
                let checkTheCodeWentHere = "Success"
                completion(true)
                // now get the opposing username which is just the Username registered to that specific bet
                /*
                self.datRef.child("Bets").child(self.tieBetToUser[index]).observeSingleEvent(of: .value, with: { snapshot in
                    let thisValue = snapshot.value as? NSDictionary
                    if let username = thisValue?["Username"] as? String {
                        self.opposingUserNames = username
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                })
 */
 
            })
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    
    
    }
    
    func getOpoosingUserNames(_ username: String,_ index: Int, completion: @escaping (_ result: Bool?) -> Void ) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        datRef.child("User").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            
            
            self.datRef.child("Bets").child(self.tieBetToUser[index]).observeSingleEvent(of: .value, with: { snapshot in
                let thisValue = snapshot.value as? NSDictionary
                if let username = thisValue?["Username"] as? String {
                    self.opposingUserNames = username
                    completion(true)
                } else {
                    completion(false)
                }
                
            })
        }) { (error) in
            print(error.localizedDescription)
        }
    }
   


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if makeEmpty == true {
        //    return 0
        //} else {
            return amountBets.count
        //}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellB", for: indexPath) as! CellB
        cell.userNameLabel?.text = userNames[indexPath.row]
        cell.amountOfBet?.text = amountBets[indexPath.row]
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Accept Bet", message: "Match the bet of " + amountBets[indexPath.row], preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        
        let yesButton = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            // let them know to wait a second or the bet won't go through
            var waitController = UIAlertController(title: "Please Wait", message: "Your bet is being processed", preferredStyle: .alert)
 
            self.present(waitController, animated: true, completion: nil)
            //take away the usersMoney
            self.takeAwayMoney(self.amountBets[indexPath.row],index: indexPath.row, completion: { (result: Bool?) in
                
                guard let boolResult = result else {
                    return
                }
                var getResult = ""
                print("You have taken away the users money")
                
                    print("you made it this far almost there")
                    //let delayInSeconds = 3.0 // 1
                    //DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) { // 2
            })
            if (self.userHasMoney == true) {
            self.updateBet(indexPath.row, completion: { (result: Bool?) in
                
                guard let checkRes = result else {
                    return
                }
                
                
            })
            
            self.getOpoosingUserNames(self.userName, indexPath.row, completion: { (anothaResult: Bool?) in
                
                guard let value = anothaResult else {
                    return print("didn't work")
                }
                        //wait for the first view to load in case it uploads to fast
                        sleep(1)
                        self.dismiss(animated: true, completion: nil)
                        let successController = UIAlertController(title: "Success", message: "You have made a bet with " + self.opposingUserNames!, preferredStyle: .alert)
                        let okButt = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        successController.addAction(okButt)
                        self.present(successController, animated: true, completion: nil)
                        //lastly delete the opposing UserName
                        self.amountBets.remove(at: indexPath.row)
                        self.tableView.reloadData()
                        print("Second")
                
            })
            } else {
                //display a alert that lets the user know hes broke
                let brokeController = UIAlertController(title: "Failed", message: "Reason: You don't have enough money!", preferredStyle: .alert)
                let okButt = UIAlertAction(title: "Ok", style: .default, handler: nil)
                brokeController.addAction(okButt)
                self.present(brokeController, animated: true, completion: nil)
            }
        
        return
        })
    
        alertController.addAction(okButton)
        alertController.addAction(yesButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete) {
            self.amountBets.remove(at: indexPath.row)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let indexPath = self.tableView.indexPathForSelectedRow!
        //var DestViewController : addBets = segue.destination as! addBets
        //DestViewController.teamOne = self.teamOne.text!
        //DestViewController.teamOne = self.teamTTwo
        
        if segue.identifier == "gotobetview" {
            if let destination = segue.destination as? addBets {
                
                destination.teamOne = self.teamOne.text!
        
                destination.teamTwo = self.teamTwo.text!
            }
        }
        
        
        
        
    }
    
    func takeAwayMoney(_ howMuch: String, index: Int, completion: @escaping (Bool)-> ()) -> Void{
        if let notMuch = Int(howMuch) {

            let userID = FIRAuth.auth()?.currentUser?.uid
            
            datRef.child("User").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let money = value?["money"] as? String ?? ""
                
                //convert money to int
                if let conMoney = Int(money) {
                    var conMoreMoney = conMoney
                    if conMoreMoney < notMuch {
                        
                        print(" You don't have enough money")
                        self.userHasMoney = false
                        completion(false)
                        return
                    } else {
                        conMoreMoney -= notMuch
                        let values = ["money": String(conMoreMoney)]
                        
                        //update the users money
                        self.datRef.child("User").child(userID!).updateChildValues(values)
                        completion(true)
                        /*
                        self.updateBet(index, completion: { (result: Bool?) in
                            guard let checkResult = result else {
                                return print("Failed to get result")
                            }
                            if checkResult == true {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        })
 */
                        
                    }
                    
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func getUserName() -> String {
        let userID = FIRAuth.auth()?.currentUser?.uid
        var useruser: String!
        datRef.child("User").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.userName = username
            useruser = username
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        return useruser
    }
    
    
    
    
    func sayHello(sender: UIBarButtonItem) {
        let userInput = self.teamOne.text
        
        var userInputArray: [String] = []
        userInputArray.append(self.teamOne.text!)
        userInputArray.append(self.teamTwo.text!)
        performSegue(withIdentifier: "gotobetview", sender: userInputArray)
        
        
        
        
        
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let homeView = storyboard.instantiateViewController(withIdentifier: "addBets")
        //self.present(homeView, animated: true, completion: nil)
    }
    
    func goBack(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let backView = storyboard.instantiateViewController(withIdentifier: "tabview")
        self.present(backView, animated: true, completion: nil)
    }
    
}
