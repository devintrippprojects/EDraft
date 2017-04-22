//
//  RecentViewController.swift
//  EDraft
//
//  Created by Devin Tripp on 4/15/17.
//  Copyright © 2017 Devin Tripp. All rights reserved.
//

import UIKit
import Foundation
import Firebase




class RecentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    let getData = GatherData()
    
    let getTeamTimesStuff = DataController()
    
    
    let test = String()
    
    
    // data
    var userName = String()
    let datRef = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/")
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        
        
        getData.getUpcomingBetsForUser(theUsersName: "", completion: { (resulte) in
            if resulte == true {
                self.tableView.reloadData()
            } else {
                
            }
            
            
        })
        
        
        getTeamTimesStuff.getTeamsAndTimes()
        
        getTeamTimesStuff.getTeamScores()
        
        self.tableView.reloadData()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        for cell in tableView.visibleCells as [UITableViewCell] {
            
            let point = tableView.convert(cell.center, to: tableView.superview)
            cell.alpha = ((point.y * 100) / tableView.bounds.maxY) / 100
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getTeamTimesStuff.finalTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellD", for: indexPath) as! CellD
        
        cell.firstTeamName?.text = getData.firstTeams[indexPath.row]
        
        cell.backgroundColor = UIColor.gray
        cell.alpha = 0
        
        UIView.animate(withDuration: 2, animations: { cell.alpha = 1 })
        
        return cell
    }
    
    
}
