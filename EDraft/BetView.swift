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
    
    
    var userMoney = String()
    
    let getData = GatherData()
    
    var testies: String?
    
    var teamTOne = String()
    var teamTTwo = String()
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width, height: 50))
    var navItem = UINavigationItem(title: "Money: ")
        
    
    let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: nil, action: #selector(sayHello(sender:)))
    
    
    let backItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(goBack(sender:)))


    override func viewWillAppear(_ animated: Bool) {
        self.getData.betObjects.removeAll()
        self.getData.getBetsFor(completion: { (result) in
            if result == true {
                //show the spinning wheel thing
                self.tableView.reloadData()
            } else {
                // error
            }
            
        })
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
        
        
        /*
        getData.getBetsFor(completion: { (result) in
            if result == true {
                
            
                
            
                self.tableView.reloadData()
            } else {
                
            }
            
        })
        */
        
        getData.getMoneyFromUser(username: self.getData.userName, completion: { (money) in
            
            if money == true {
                let usermoney = String(self.getData.userMoney)
                //update the UI
                self.navItem.title = "$" + usermoney
                print(self.getData.userMoney)
            } else {
                print("no money found")
            }
            
            
            
        })
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return true
    }
    
    
    
    
    func updateBet(_ index: Int, completion: @escaping (_ something: Bool) -> Void) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        datRef.child("User").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String
            self.getData.userName = username!
            // ...
            
            
            self.datRef.child("Bets").observe(.childAdded, with: { snapshot in
                //
                // this is the unique identifier of the bet.  eg, -Kfx81GvUxoHpmmMwJ9P
                guard let dict = snapshot.value as? [String: AnyHashable] else {
                    print("failed to get dictionary from Bets.\(self.getData.userName)")
                    return
                }
                let values = ["OpposingUsername": self.getData.userName,"Show": "no"]
                //var val = self.getData.betObjects[index]
                //val.opposingUserName = self.getData.userName
            self.datRef.child("Bets").child(self.getData.tieBetToUser[index]).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let anothaValue = snapshot.value as? NSDictionary
                    let user = anothaValue?["Username"] as? String
                    
                    if user == self.getData.userName {
                        // let the user know he cannot bet his own bet
                        completion(false)
                    } else {
                        self.datRef.child("Bets").child(self.getData.tieBetToUser[index]).updateChildValues(values)
                        completion(true)
                    }
                    
                    
                })
                
                
 
            })
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    
    
    }
    
    func getOpoosingUserNames(_ username: String,_ index: Int, completion: @escaping (_ result: Bool) -> Void ) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        datRef.child("User").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            
            
            self.datRef.child("Bets").child(self.getData.tieBetToUser[index]).observeSingleEvent(of: .value, with: { snapshot in
                let thisValue = snapshot.value as? NSDictionary
                if let thisUserName = thisValue?["Username"] as? String {
                    
                    self.getData.opposingUserName  = thisUserName
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
        print(self.getData.betObjects.count)
            return self.getData.betObjects.count
        //}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellB", for: indexPath) as! CellB
        print(self.getData.betObjects[indexPath.row].userName)
        cell.userNameLabel?.text = getData.betObjects[indexPath.row].userName
        cell.amountOfBet?.text = getData.betObjects[indexPath.row].betAmount
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Accept Bet", message: "Match the bet of " + getData.amountBets[indexPath.row], preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        
        let yesButton = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            // let them know to wait a second or the bet won't go through
            var waitController = UIAlertController(title: "Please Wait", message: "Your bet is being processed", preferredStyle: .alert)
 
            self.present(waitController, animated: true, completion: nil)
            //take away the usersMoney
            self.takeAwayMoney(self.getData.amountBets[indexPath.row],index: indexPath.row, completion: { (result) in
                
                if result == true {
                    self.updateBet(indexPath.row, completion: { (result) in
                        
                        
                        if result == true {
                            self.getOpoosingUserNames(self.getData.userName, indexPath.row, completion: { (anothaResult) in
                                
                                if anothaResult == true {
                                    self.dismiss(animated: true, completion: {
                                        let successController = UIAlertController(title: "Success", message: "You have made a bet with " + self.getData.opposingUserName, preferredStyle: .alert)
                                        let okButt = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                        successController.addAction(okButt)
                                        self.present(successController, animated: true, completion: nil)
                                        //lastly delete the opposing UserName
                                        
                                        let pathIndex = IndexPath(item: indexPath.row, section: 0)
                                        self.getData.betObjects.remove(at: indexPath.row)
                                        self.tableView.deleteRows(at: [pathIndex], with: .fade)
                                        self.tableView.reloadData()
                                        print("Second")
                                    })
                                    
                                    self.getData.getMoneyFromUser(username: self.getData.userName, completion: { (money) in
                                        
                                        if money == true {
                                            self.userMoney = String(self.getData.userMoney)
                                            //update the UI
                                            self.navItem.title = "$" + self.userMoney
                                            
                                        
                                            
                                            print(self.userMoney)
                                        } else {
                                            print("no money found")
                                        }
                                        
                                        
                                        
                                    })
                                } else {
                                    
                                }
                                //wait for the first view to load in case it uploads to fast
                                
                                
                            })
                            
                        } else {
                            self.dismiss(animated: true, completion: {
                                let cannotBet = UIAlertController(title: "Failed", message: "You cannot bet with yourself dummy", preferredStyle: .alert)
                                let okButt = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                cannotBet.addAction(okButt)
                                self.present(cannotBet, animated: true, completion: nil)
                            })
                        }
                        
                        
                    })
                    
                    
                    
                } else {
                    // user doesn't have money
                    //display a alert that lets the user know hes broke
                    print("this should print once")
                    self.dismiss(animated: true, completion: {
                        let brokeController = UIAlertController(title: "Failed", message: "Reason: You don't have enough money!", preferredStyle: .alert)
                        let okButt = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        brokeController.addAction(okButt)
                        self.present(brokeController, animated: true, completion: nil)
                    })
                }
                var getResult = ""
                print("You have taken away the users money")
                
                    print("you made it this far almost there")
                    //let delayInSeconds = 3.0 // 1
                    //DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) { // 2
            })
            
        
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
            self.getData.betObjects.remove(at: indexPath.row)
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
                        completion(false)
                        return
                    } else {
                        conMoreMoney -= notMuch
                        let values = ["money": String(conMoreMoney)]
                        
                        //update the users money
                        self.datRef.child("User").child(userID!).updateChildValues(values)
                        completion(true)
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
            
            self.getData.userName = username
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
