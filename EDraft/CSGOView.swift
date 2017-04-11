//
//  CSGOView.swift
//  EDraft
//
//  Created by Devin Tripp on 3/10/17.
//  Copyright © 2017 Devin Tripp. All rights reserved.
//

import UIKit
import Foundation
import Firebase


class CSGOView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableViewView: UITableView!
    
    var teams: [String] = []
    var times: [String] = []
    var teamOneArray: [String] = []
    var teamTwoArray: [String] = []
    var row: Int = 0
    let bview = BetView()
    
    
    
    
    let teamsRef = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/Teams")
    let timesRef = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/Times")
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableViewView.separatorStyle = .none
        self.tableViewView.isScrollEnabled = true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTeamsAndTimes()
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
            
            //Reload the tabelView after that
            self.tableViewView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        timesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            for child in snapshot.children {
                if let time = (child as! FIRDataSnapshot).value as? String {
                    self.times.append(time)
                }
            }
            
            //Reload the tabelView after that
            self.tableViewView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func teamsWithTimes() -> [String : String] {
        var timesTeams: [String: String] = [:]
        
        
        
        return timesTeams
    }
    
    func findTeamOneAndTeamTwo(teams: [String]) {
        //Find the count then divide
        var i = 0
        
        //check if its even
        for team in teams{
            if i%2 == 0 {
                self.teamOneArray.append(team)
                self.tableViewView.reloadData()
            } else {
                self.teamTwoArray.append(team)
                self.tableViewView.reloadData()
            }
            
            i += 1
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.teams.count)/2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        cell.TeamOneLabel?.text = teamOneArray[indexPath.row]
        cell.TeamTwoLabel?.text = teamTwoArray[indexPath.row]
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didselectRowAtIndexPath indexPath: NSIndexPath) {
        self.row = indexPath.row
        bview.teamTOne = self.teamOneArray[indexPath.row]
        //svc.teamTwo.text = teamTwoArray[row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "betView")
        self.present(controller, animated: true, completion: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableViewView.indexPathForSelectedRow!
        var DestViewController : BetView = segue.destination as! BetView
        DestViewController.teamTOne = self.teamOneArray[indexPath.row]
        DestViewController.teamTTwo = self.teamTwoArray[indexPath.row]
        
    }
    
    func getTeam() -> String {
        return teams[row]
    }
    
}
