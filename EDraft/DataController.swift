//
//  DataController.swift
//  EDraft
//
//  Created by Devin Tripp on 3/14/17.
//  Copyright © 2017 Devin Tripp. All rights reserved.
//

import Foundation
import Firebase



let html = "http://charts.noaa.gov/BookletChart/AtlanticCoastBookletCharts.htm"

class DataController {
    var teams: [String] = []
    var teamOne: [String] = []
    var teamTwo: [String] = []
    var times: [String] = []
    
    var finalTimes: [String] = []
    
    
    var firstTeamScores: [String] = []
    var secondTeamScores: [String] = []
    
    
    var teamObjects: [Teams] = []
    
    
    let teamsRef = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/Teams")
    let timesRef = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/Times")
    
    let firstRef = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/FirstScores")
    let secondRef = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/SecondScores")
    
    
    func getTeamScores() {
        // need to check if the times value is final then get the team scores
        timesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            self.times.removeAll()
            for child in snapshot.children {
                if let time = (child as! FIRDataSnapshot).value as? String {
                    self.times.append(time)
                }
            }
            
            for time in self.times {
                if time == "Final" {
                    //add final times array
                    self.finalTimes.append(time)
                    // now put the first team scores in an array
                    self.firstRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        for child in snapshot.children {
                            if let first = (child as! FIRDataSnapshot).value as? String {
                                self.firstTeamScores.append(first)
                            }
                        }
                        
                    })
                    self.secondRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        for child in snapshot.children {
                            if let second = (child as! FIRDataSnapshot).value as? String {
                                self.secondTeamScores.append(second)
                            }
                        }
                        
                    })
                }
            }
            
            
        })
        
        
    }
    
    func getTeamsAndTimesObject(completion: @escaping(_ mon: Bool) -> Void) {
        teamsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            for child in snapshot.children {
                guard let team = (child as! FIRDataSnapshot).value as? String else{
                    //self.teams.append(team)
                    return
                    
                }
                self.teams.append(team)
            }
            
            self.findTeamOneAndTeamTwo(teams: self.teams)
            //self.findTeamOneAndTeamTwo(teams: self.teams)
            
            //Reload the tabelView after that
        }) { (error) in
            print(error.localizedDescription)
        }
        timesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            for child in snapshot.children {
                if let time = (child as! FIRDataSnapshot).value as? String {
                    //self.times.append(time)
                    var i = 0
                    for t in self.teamOne {
                        self.teamObjects.append(Teams(teamOne: self.teamOne[i], teamTwo: self.teamTwo[i]))
                        if time == "Final" {
                            self.finalTimes.append(time)
                        }
                        i += 1
                    }
                    completion(true)
                }
            }
            
            //Reload the tabelView after that
        }) { (error) in
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    
    func getTeamsAndTimes() {
        teamsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            for child in snapshot.children {
                if let team = (child as! FIRDataSnapshot).value as? String {
                    self.teams.append(team)
                    
                }
            }
            
            self.findTeamOneAndTeamTwo(teams: self.teams)
            //self.findTeamOneAndTeamTwo(teams: self.teams)
            
            //Reload the tabelView after that
        }) { (error) in
            print(error.localizedDescription)
        }
        timesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            for child in snapshot.children {
                if let time = (child as! FIRDataSnapshot).value as? String {
                    self.times.append(time)
                    if time == "Final" {
                        self.finalTimes.append(time)
                    }
                }
            }
            
            //Reload the tabelView after that
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func findTeamOneAndTeamTwo(teams: [String]) {
        //Find the count then divide
        var i = 0
        
        //check if its even
        for team in self.teams{
            if i%2 == 0 {
                self.teamOne = self.teams
            } else {
                self.teamTwo = self.teams
            }
            
            i += 1
        }
        
        
        
    }
    

    
}



class Teams {
    let teamOne: String
    let teamTwo: String
    
    init(teamOne: String, teamTwo: String) {
        self.teamOne = teamOne
        self.teamTwo = teamTwo
    }
    
    
    
    
}


class chart {
    let title: String
    let url: NSURL
    let number: Int
    let scale: Int
    
    required init(title: String, url: NSURL, number: Int, scale: Int) {
        self.title = title
        self.url = url
        self.number = number
        self.scale = scale
    }
    
    
    
}
