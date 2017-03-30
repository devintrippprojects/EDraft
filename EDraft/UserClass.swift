//
//  UserClass.swift
//  EDraft
//
//  Created by Devin Tripp on 3/8/17.
//  Copyright © 2017 Devin Tripp. All rights reserved.
//

import Foundation
import FirebaseAuth



class UserTwo {
    var user = FIRAuth.auth()?.currentUser
    
    
    
    
    //name = user.displayName;
    //email = user.email;
    //photoUrl = user.photoURL;
    //emailVerified = user.emailVerified;
    //uid = user.uid;  // The user's ID, unique to the Firebase project. Do NOT use
    // this value to authenticate with your backend server, if
    // you have one. Use User.getToken() instead.
    var firstName: String
    var lastName: String
    var middleName: String?
    var userName: String
    var money: Float
    
    // If you do 100/100 you get one so if two people bet the teams will divide by 100 each time
    // add 100 to a value of the bet when someone bets on a certain team
    
    
    init(firstName: String,
         lastName: String,
         middleName: String?,
         userName: String,
         money: Float) {
            self.middleName = middleName
            self.firstName = firstName
            self.lastName = lastName
            self.userName = userName
            self.money = money
    }
    
    
    func bet(user: UserTwo) {
        
        
        if(user.money != 0){
            //choose which team you want to bet for
            //make a list of teams
            //      CSGOTeams.Astralis(self.money,self.times)
        } else {
            //prompt the user that he/she does not have money
            
        }
    }
}

//var thisUser = User(firstName: "", lastName: "", middleName: "", userName: "", money: 0.0)
