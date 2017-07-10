//
//  ClientProfileTableViewController.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/16/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import UIKit
import Firebase

//TODO: get snapshot of all users - ?query by child equal to companyCode if exists display client info (reference ownerscheudleTVC)
class ClientProfileTableViewController: UITableViewController {

    //MARK: -- stored properties 
    var clientDetails: UserModel!

    //MARK: -- outlets
    @IBOutlet weak var clientProfileImg: UIImageView!
    @IBOutlet weak var clientNameLBL: UILabel!
    @IBOutlet weak var clientEmaillLBL: UILabel!
    @IBOutlet weak var clientPhoneLBL: UILabel!
    @IBOutlet weak var clientAddressLBL: UILabel!
    @IBOutlet weak var clientEmergencyContantLBL: UILabel!
    @IBOutlet weak var emergencyPhoneLBL: UILabel!

    //MARK: -- viewDidLoaf
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

