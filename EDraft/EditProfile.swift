//
//  EditProfile.swift
//  EDraft
//
//  Created by Devin Tripp on 3/9/17.
//  Copyright © 2017 Devin Tripp. All rights reserved.
//

import Foundation
import Firebase



class EditProfile: UIViewController {
    
    var ref = FIRDatabase.database().reference(fromURL: "https://edraft-77b47.firebaseio.com/")
    
    
    override func viewDidLoad() {
        //load the current user
    }
    
    
}
