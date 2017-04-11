//
//  GatherData.swift
//  EDraft
//
//  Created by Devin Tripp on 3/10/17.
//  Copyright © 2017 Devin Tripp. All rights reserved.
//

import Foundation
import Firebase

//gather data from firebase
class User {
    
    let datRef = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/")
    
    
    
    
    func getUserName(username: String, completion: @escaping(_ m: Bool) -> Void) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        datRef.child("User").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let usernameMain = value?["username"] as? String
            
            // set the user name var
            self.userName = usernameMain!
            completion(true)
            
            
            
            
            
        })
    }
    
    
    
    var userName = String()
    var betTotal = String()
    
    
    
    init(username: String, bettotal: String) {
        getUserName(username: username, completion: { (snap) in
            
            if snap == true {
                self.userName = username
                self.betTotal = bettotal
                
            } else {
                
                
            }
            
        })
    
    }
    
    
}

class GatherData {
    
    var userAgain: String = ""
    var userMoney: Int = 0
    var userName: String = ""
    
    //database Reference
    let databaseReference = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/")
    
    
    
    
    //arrays
    var amountBets: [String] = []
    var userNames: [String] = []
    var tieBetToUser: [String] = []
    var opposingUserName = String()
    
    
    //upcoming Bets Arrays
    var amountUpcomingBets: [String] = []
    var userNamesUpcoming: [String] = []
    var tieBetToUserUpcoming: [String] = []
    
    //objects
    var betObjects: [Bet] = []
    var upcomingBetObjects: [Bet] = []
    
    
    
    func getMoneyFromUser(username: String, completion: @escaping(_ mon: Bool) -> Void) {
        //get the current user to put in the database
        let userID = FIRAuth.auth()?.currentUser?.uid
        databaseReference.child("User").child(userID!).observe(.value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let money = value?["money"] as? String
            if let hasMoney = money {
                self.userMoney = Int(hasMoney)!
                completion(true)
            } else {
                print("No money found sorry")
                completion(false)
            }
            
            
            
            
            
        })
        
        
        
    }
    
    func getBetsForUserName(username: String, completion: @escaping(_ some: Bool) -> Void) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        databaseReference.child("User").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            //let username = value?["username"] as? String ?? ""
            //self.userName = username
        self.databaseReference.child("Bets").observe(.childAdded, with: { snapshot in
    
            let betID = snapshot.key as String
            self.databaseReference.child("Bets").child(betID).observe(.value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let show = value?["Show"] as? String
                let betAmount = value?["Bet"] as? String
                let yourTeam = value?["ForTeam"] as? String
                let theirTeam = value?["OpposingTeam"] as? String
                let mainBetUser = value?["Username"] as? String
                let opposingUserName = value?["OpposingUsername"] as? String
                
                if show == "no" {
                    if mainBetUser == username || opposingUserName == username {
                        if mainBetUser == username && opposingUserName == username {
                            self.amountUpcomingBets.append(mainBetUser!)
                            //let user = User(username: mainBetUser, bettotal: betAmount)
                            
                        } else if opposingUserName == username {
                            self.amountUpcomingBets.append(opposingUserName!)
                        } else if mainBetUser == username {
                            self.amountUpcomingBets.append(opposingUserName!)
                        }
                    }
                }
                
                
                
                
                
            })
    
    
            completion(true)
    
        })
            
        })
    
    
    }

    
    
    func getBetsFor(completion: @escaping(_ some: Bool) -> Void) {
        self.amountBets.removeAll()
        self.userNames.removeAll()
        self.tieBetToUser.removeAll()
        if betObjects.isEmpty == true {
            // do nothing
        } else {
            betObjects.removeAll()
        }
        let userID = FIRAuth.auth()?.currentUser?.uid
        databaseReference.child("User").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.userName = username
            
            // ...
            
            
            self.databaseReference.child("Bets").observe(.childAdded, with: { snapshot in
                //
                // this is the unique identifier of the bet.  eg, -Kfx81GvUxoHpmmMwJ9P
                
                let betId = snapshot.key as String
                //guard let dict = snapshot.value as? [String: AnyHashable] else {
                //    print("failed to get dictionary from Bets.\(self.userName)")
                //    return
                //}
                self.databaseReference.child("Bets").child(betId).observe(.value , with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let show = value?["Show"] as? String
                    let bet = value?["Bet"] as? String
                    let usernama = value?["Username"] as? String
                    let forTeam = value?["ForTeam"] as? String
                    //let forteam = value?["ForTeam"] as? String
                    if show == "yes" {
                        if bet != "0" {
                            self.amountBets.append(bet!)
                            self.userNames.append(usernama!)
                            self.tieBetToUser.append(betId)
                            self.betObjects.append(Bet(betamount: bet!, betID: betId, username: usernama!, opposingUserName: "", userTeam: forTeam!, opposingTeam: ""))
                            completion(true)
                            
                        } else {
                            completion(false)
                        }
                    }
                })
                
                
            })
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    func getUpcomingBetsForUser(theUsersName: String, completion: @escaping(_ some: Bool) -> Void) {
        self.amountUpcomingBets.removeAll()
        self.userNamesUpcoming.removeAll()
        self.tieBetToUserUpcoming.removeAll()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        databaseReference.child("User").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.userName = username
            
            // ...
            
            
            self.databaseReference.child("Bets").observe(.childAdded, with: { snapshot in
                //
                // this is the unique identifier of the bet.  eg, -Kfx81GvUxoHpmmMwJ9P
                
                let betId = snapshot.key as String
                //guard let dict = snapshot.value as? [String: AnyHashable] else {
                //    print("failed to get dictionary from Bets.\(self.userName)")
                //    return
                //}
                self.databaseReference.child("Bets").child(betId).observe(.value , with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let show = value?["Show"] as? String
                    let bet = value?["Bet"] as? String
                    let usernama = value?["Username"] as? String
                    let forTeam = value?["ForTeam"] as? String
                    let opposingUser = value?["OpposingUsername"] as? String ?? " "
                    //print(show!)
                    //print(bet!)
                    //print(usernama!)
                    //print(forTeam!)
                    //let opposingTeam = value?["OpposingTeam"] as? String
                    //let forteam = value?["ForTeam"] as? String
                    if show == "no" {
                        if bet != "0" {
                                //self.amountBets.append(bet!)
                                //self.userNames.append(usernama!)
                                //self.tieBetToUser.append(betId)
                            /*
                                if(self.userName == username) {
                                    self.upcomingBetObjects.append(Bet(betamount: bet!, betID: betId, username: usernama!, opposingUserName: opposingUser, userTeam: forTeam!, opposingTeam: "adfaf"))
                                    completion(true)
                                
                                } else*/ if (username == opposingUser) {
                                    self.upcomingBetObjects.append(Bet(betamount: bet!, betID: betId, username: opposingUser, opposingUserName: usernama!, userTeam: forTeam!, opposingTeam: "adfaf"))
                                    completion(true)
                                } else if (username == usernama) {
                                    self.upcomingBetObjects.append(Bet(betamount: bet!, betID: betId, username: usernama!, opposingUserName: opposingUser, userTeam: forTeam!, opposingTeam: "adfaf"))
                                    completion(true)
                                    
                                }
                            
                            
                            
                        } else {
                            completion(false)
                        }
                    }
                })
                
                
            })
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    
    
    
    
    
    
    
}


class Bet {
    let betAmount: String
    let betID: String
    let userName: String
    var opposingUserName: String
    let userTeam: String
    let opposingTeam: String
    
    
    init(betamount: String, betID: String, username: String, opposingUserName: String, userTeam: String, opposingTeam: String) {
        self.betAmount = betamount
        self.betID = betID
        self.userName = username
        self.opposingUserName = opposingUserName
        self.userTeam = userTeam
        self.opposingTeam = opposingTeam
        
    }
    
    
    
    
}
