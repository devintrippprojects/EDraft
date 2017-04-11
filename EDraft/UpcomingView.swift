//
//  UpcomingView.swift
//  EDraft
//
//  Created by Devin Tripp on 4/3/17.
//  Copyright © 2017 Devin Tripp. All rights reserved.
//

import UIKit
import Foundation
import Firebase




class UpcomingView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    
    
    
    
    
    
    
    
    let getData = GatherData()
    
    
    let test = String()
    
    
    // data
    var userName = String()
    let datRef = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/")
    
    
    // arrays
    var amountUpcomingBets: [String] = []
    var userNamesUpcoming: [String] = []
    var tieBetToUserUpcoming: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        getData.getUpcomingBetsForUser(theUsersName: "", completion: { (resulte) in
            
            
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        getData.getUpcomingBetsForUser(theUsersName: "", completion: { (result) in
            
            if result == true {
                print(self.getData.userName)
                print(self.getData.amountUpcomingBets)
                print(self.getData.userNamesUpcoming)
                self.tableView.reloadData()
            }
            
        })
        
        
        
        
    }
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        getData.upcomingBetObjects.removeAll()
    }
    
    
    /*
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
     
     for cell in tableView.visibleCells as [UITableViewCell] {
     
     let point = tableView.convert(cell.center, to: tableView.superview)
     cell.alpha = ((point.y * 100) / tableView.bounds.maxY) / 100
     }
     }
     */
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getData.upcomingBetObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellC", for: indexPath) as! CellC
        
        cell.test?.text = self.getData.upcomingBetObjects[indexPath.row].opposingUserName
        cell.backgroundColor = UIColor.gray
        cell.alpha = 0
        
        UIView.animate(withDuration: 2, animations: { cell.alpha = 1 })
        
        return cell
    }
    
    
}
